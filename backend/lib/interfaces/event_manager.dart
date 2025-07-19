import 'dart:async';

/// TrueNAS system event
class TrueNasEvent {
  final String type;
  final String? id;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  const TrueNasEvent({
    required this.type,
    this.id,
    required this.data,
    required this.timestamp,
  });

  factory TrueNasEvent.fromJson(Map<String, dynamic> json) {
    return TrueNasEvent(
      type: json['msg'] ?? json['type'] ?? 'unknown',
      id: json['id']?.toString(),
      data: json,
      timestamp: DateTime.now(),
    );
  }
}

/// Event subscription configuration
class EventSubscription {
  final List<String> eventTypes;
  final bool includeChanged;
  final bool includeAdded;
  final bool includeRemoved;

  const EventSubscription({
    required this.eventTypes,
    this.includeChanged = true,
    this.includeAdded = true,
    this.includeRemoved = true,
  });

  /// Subscribe to all system events
  factory EventSubscription.all() => const EventSubscription(eventTypes: ['*']);

  /// Subscribe to specific event types
  factory EventSubscription.types(List<String> types) =>
      EventSubscription(eventTypes: types);
}

/// Manages real-time event subscriptions from TrueNAS
abstract class IEventManager {
  /// Whether event subscription is active
  bool get isSubscribed;

  /// Stream of all events
  Stream<TrueNasEvent> get eventStream;

  /// Subscribe to events with the given configuration
  Future<void> subscribe(EventSubscription subscription);

  /// Subscribe to specific event types
  Future<void> subscribeToTypes(List<String> eventTypes);

  /// Unsubscribe from all events
  Future<void> unsubscribe();

  /// Get a filtered stream for specific event types
  Stream<TrueNasEvent> getEventsOfType(String eventType);

  /// Get a filtered stream for multiple event types
  Stream<TrueNasEvent> getEventsOfTypes(List<String> eventTypes);
}
