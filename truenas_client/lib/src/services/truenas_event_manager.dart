import 'dart:async';
import 'package:logging/logging.dart';
import '../interfaces/event_manager.dart';
import '../interfaces/json_rpc_client.dart';

/// TrueNAS event manager for real-time notifications
class TrueNasEventManager implements IEventManager {
  final _logger = Logger('TrueNasEventManager');
  final StreamController<TrueNasEvent> _eventController =
      StreamController<TrueNasEvent>.broadcast();

  final IJsonRpcClient _jsonRpcClient;
  StreamSubscription<JsonRpcNotification>? _notificationSubscription;
  bool _isSubscribed = false;
  EventSubscription? _currentSubscription;

  TrueNasEventManager({required IJsonRpcClient jsonRpcClient})
    : _jsonRpcClient = jsonRpcClient {
    _initialize();
  }

  void _initialize() {
    // Listen to JSON-RPC notifications
    _notificationSubscription = _jsonRpcClient.notifications.listen(
      _handleNotification,
      onError: (Object error) {
        _logger.severe('Notification stream error: $error');
      },
    );
  }

  @override
  bool get isSubscribed => _isSubscribed;

  @override
  Stream<TrueNasEvent> get eventStream => _eventController.stream;

  @override
  Future<void> subscribe(EventSubscription subscription) async {
    _logger.info('Subscribing to events: ${subscription.eventTypes}');

    try {
      if (_isSubscribed) {
        await unsubscribe();
      }

      // Subscribe to events using TrueNAS WebSocket protocol
      await _jsonRpcClient.call<dynamic>('core.subscribe', {
        'name': subscription.eventTypes,
      });

      _currentSubscription = subscription;
      _isSubscribed = true;
      _logger.info('Successfully subscribed to events');
    } catch (e) {
      _logger.severe('Failed to subscribe to events: $e');
      _isSubscribed = false;
      rethrow;
    }
  }

  @override
  Future<void> subscribeToTypes(List<String> eventTypes) async {
    final subscription = EventSubscription.types(eventTypes);
    await subscribe(subscription);
  }

  @override
  Future<void> unsubscribe() async {
    if (!_isSubscribed) {
      return;
    }

    _logger.info('Unsubscribing from events');

    try {
      if (_currentSubscription != null) {
        await _jsonRpcClient.call<dynamic>('core.unsubscribe', {
          'name': _currentSubscription!.eventTypes,
        });
      }
    } catch (e) {
      _logger.warning('Failed to unsubscribe cleanly: $e');
    } finally {
      _currentSubscription = null;
      _isSubscribed = false;
      _logger.info('Unsubscribed from events');
    }
  }

  @override
  Stream<TrueNasEvent> getEventsOfType(String eventType) {
    return eventStream.where((event) => event.type == eventType);
  }

  @override
  Stream<TrueNasEvent> getEventsOfTypes(List<String> eventTypes) {
    final eventTypeSet = eventTypes.toSet();
    return eventStream.where((event) => eventTypeSet.contains(event.type));
  }

  void _handleNotification(JsonRpcNotification notification) {
    try {
      _logger.fine('Received notification: ${notification.method}');

      // Convert JSON-RPC notification to TrueNAS event
      final event = _parseNotificationToEvent(notification);
      _eventController.add(event);
    } catch (e) {
      _logger.severe('Failed to parse notification: $e');
    }
  }

  TrueNasEvent _parseNotificationToEvent(JsonRpcNotification notification) {
    final data = <String, dynamic>{
      'method': notification.method,
      'original_params': notification.params,
    };

    // Extract common event data
    String eventType = notification.method;
    String? eventId;

    if (notification.params != null) {
      final params = notification.params!;

      // Handle different notification formats
      if (params.containsKey('msg')) {
        eventType = params['msg'] as String;
      }

      if (params.containsKey('id')) {
        eventId = params['id']?.toString();
      }

      // Add all params to event data
      data.addAll(params);
    }

    return TrueNasEvent(
      type: eventType,
      id: eventId,
      data: data,
      timestamp: DateTime.now(),
    );
  }

  /// Subscribe to common system events
  Future<void> subscribeToSystemEvents() async {
    await subscribeToTypes([
      'system',
      'pool',
      'dataset',
      'share',
      'alert',
      'task',
      'service',
      'user',
      'group',
    ]);
  }

  /// Subscribe to storage-related events only
  Future<void> subscribeToStorageEvents() async {
    await subscribeToTypes([
      'pool',
      'dataset',
      'snapshot',
      'scrub',
      'resilver',
    ]);
  }

  /// Subscribe to share-related events only
  Future<void> subscribeToShareEvents() async {
    await subscribeToTypes(['share', 'smb', 'nfs', 'iscsi']);
  }

  void dispose() {
    _notificationSubscription?.cancel();
    _eventController.close();
  }
}
