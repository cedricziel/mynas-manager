import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';

class TrueNasHeartbeatService {
  final _logger = Logger('TrueNasHeartbeatService');
  final ITrueNasClient client;

  // Configuration
  final Duration heartbeatInterval;
  final Duration reconnectDelay;
  final int maxReconnectAttempts;

  // State
  StreamSubscription<ConnectionStatus>? _heartbeatSubscription;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;

  // Connection status stream
  final _statusController = StreamController<ConnectionStatus>.broadcast();
  Stream<ConnectionStatus> get connectionStatus => _statusController.stream;

  // Current status
  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;
  ConnectionStatus get currentConnectionStatus => _currentStatus;

  TrueNasHeartbeatService({
    required this.client,
    Duration? heartbeatInterval,
    Duration? reconnectDelay,
    int? maxReconnectAttempts,
  }) : heartbeatInterval =
           heartbeatInterval ??
           Duration(
             seconds:
                 int.tryParse(
                   Platform.environment['TRUENAS_HEARTBEAT_INTERVAL'] ?? '30',
                 ) ??
                 30,
           ),
       reconnectDelay =
           reconnectDelay ??
           Duration(
             seconds:
                 int.tryParse(
                   Platform.environment['TRUENAS_RECONNECT_DELAY'] ?? '5',
                 ) ??
                 5,
           ),
       maxReconnectAttempts =
           maxReconnectAttempts ??
           int.tryParse(
             Platform.environment['TRUENAS_MAX_RECONNECT_ATTEMPTS'] ?? '10',
           ) ??
           10;

  Future<void> start() async {
    if (_heartbeatSubscription != null) {
      _logger.warning('Heartbeat service already started');
      return;
    }

    _logger.info('Starting TrueNAS heartbeat service');
    _logger.info('Heartbeat interval: ${heartbeatInterval.inSeconds}s');
    _logger.info('Reconnect delay: ${reconnectDelay.inSeconds}s');
    _logger.info('Max reconnect attempts: $maxReconnectAttempts');

    // Start heartbeat monitoring
    _heartbeatSubscription = client
        .heartbeat(interval: heartbeatInterval)
        .listen(
          (status) {
            _handleStatusChange(status);
          },
          onError: (error) {
            _logger.severe('Heartbeat error: $error');
            _handleStatusChange(ConnectionStatus.error);
          },
          cancelOnError: false,
        );
  }

  void _handleStatusChange(ConnectionStatus status) {
    if (_currentStatus == status) {
      return;
    }

    _currentStatus = status;
    _statusController.add(status);

    _logger.info('TrueNAS connection status changed: ${status.name}');

    switch (status) {
      case ConnectionStatus.connected:
        _reconnectAttempts = 0;
        _cancelReconnectTimer();
        break;

      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        _scheduleReconnect();
        break;

      case ConnectionStatus.reconnecting:
        // Already reconnecting, do nothing
        break;
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;

    _cancelReconnectTimer();

    if (_reconnectAttempts >= maxReconnectAttempts) {
      _logger.severe(
        'Maximum reconnection attempts ($maxReconnectAttempts) reached. '
        'Manual intervention required.',
      );
      return;
    }

    _reconnectAttempts++;
    _logger.info(
      'Scheduling reconnection attempt $_reconnectAttempts/$maxReconnectAttempts '
      'in ${reconnectDelay.inSeconds} seconds',
    );

    _reconnectTimer = Timer(reconnectDelay, () async {
      if (_isDisposed) return;

      try {
        _statusController.add(ConnectionStatus.reconnecting);
        await client.disconnect();
        await client.connect();

        // Connection successful, heartbeat will detect it
        _logger.info('Reconnection successful');
      } catch (e) {
        _logger.warning('Reconnection attempt failed: $e');
        // Status will be updated by heartbeat
      }
    });
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  Future<void> stop() async {
    _logger.info('Stopping TrueNAS heartbeat service');
    _isDisposed = true;

    _cancelReconnectTimer();
    await _heartbeatSubscription?.cancel();
    _heartbeatSubscription = null;

    await client.stopHeartbeat();
    await _statusController.close();
  }

  Future<void> dispose() async {
    await stop();
  }
}
