import 'dart:async';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:stream_channel/stream_channel.dart';
import '../interfaces/connection_manager.dart';

/// WebSocket connection manager with automatic reconnection
class WebSocketConnectionManager implements IConnectionManager {
  final _logger = Logger('WebSocketConnectionManager');
  final StreamController<ConnectionState> _stateController =
      StreamController<ConnectionState>.broadcast();
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription? _channelSubscription;
  Timer? _reconnectTimer;

  ConnectionState _state = ConnectionState.disconnected;
  String? _uri;
  Map<String, String>? _headers;
  int _reconnectAttempts = 0;

  // Configuration
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const Duration _connectionTimeout = Duration(seconds: 10);

  @override
  ConnectionState get state => _state;

  @override
  Stream<ConnectionState> get stateStream => _stateController.stream;

  @override
  bool get isConnected => _state == ConnectionState.connected;

  @override
  Stream<String> get messageStream => _messageController.stream;

  @override
  Future<void> connect(String uri) async {
    if (_state == ConnectionState.connecting ||
        _state == ConnectionState.connected) {
      _logger.warning('Already connecting or connected');
      return;
    }

    _uri = uri;
    _setState(ConnectionState.connecting);
    _logger.info('Connecting to WebSocket: $uri');

    try {
      await _connectWebSocket();
      _reconnectAttempts = 0;
    } catch (e) {
      _logger.severe('Failed to connect: $e');
      _setState(ConnectionState.error);
      _scheduleReconnect();
    }
  }

  // Add method to set authentication headers
  @override
  void setAuthHeaders(Map<String, String> headers) {
    _headers = headers;
    _logger.fine('Authentication headers set');
  }

  Future<void> _connectWebSocket() async {
    if (_uri == null) {
      throw StateError('URI not set');
    }

    try {
      _channel = IOWebSocketChannel.connect(
        _uri!,
        headers: _headers,
        connectTimeout: _connectionTimeout,
      );

      // Wait for connection to be established
      await _channel!.ready;

      _setState(ConnectionState.connected);
      _logger.info('WebSocket connected successfully');

      // Listen for messages
      _channelSubscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );

      // Don't start heartbeat when using with json_rpc_2 Peer
      // The Peer handles its own connection management
    } catch (e) {
      _logger.severe('WebSocket connection failed: $e');
      await _cleanup();
      rethrow;
    }
  }

  void _onMessage(dynamic message) {
    if (message is String) {
      _logger.fine('Received message: ${message.length} chars');
      _messageController.add(message);
    } else {
      _logger.warning('Received non-string message: ${message.runtimeType}');
    }
  }

  void _onError(dynamic error) {
    _logger.severe('WebSocket error: $error');
    _setState(ConnectionState.error);
    _scheduleReconnect();
  }

  void _onDone() {
    _logger.info('WebSocket connection closed');
    if (_state == ConnectionState.connected) {
      _setState(ConnectionState.disconnected);
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _logger.severe('Max reconnection attempts reached, giving up');
      _setState(ConnectionState.error);
      return;
    }

    if (_reconnectTimer?.isActive == true) {
      return; // Already scheduled
    }

    _reconnectAttempts++;
    final delay = Duration(
      seconds: _reconnectDelay.inSeconds * _reconnectAttempts,
    );

    _logger.info(
      'Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s',
    );
    _setState(ConnectionState.reconnecting);

    _reconnectTimer = Timer(delay, () async {
      if (_uri != null && _state != ConnectionState.connected) {
        try {
          await _connectWebSocket();
          _reconnectAttempts = 0;
        } catch (e) {
          _logger.severe('Reconnection attempt $_reconnectAttempts failed: $e');
          _scheduleReconnect();
        }
      }
    });
  }

  @override
  Future<void> send(String data) async {
    if (!isConnected) {
      throw StateError('WebSocket not connected');
    }

    try {
      _channel?.sink.add(data);
      _logger.fine('Sent message: ${data.length} chars');
    } catch (e) {
      _logger.severe('Failed to send message: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    _logger.info('Disconnecting WebSocket');
    _setState(ConnectionState.disconnected);
    _reconnectAttempts = _maxReconnectAttempts; // Prevent reconnection
    await _cleanup();
  }

  Future<void> _cleanup() async {
    _reconnectTimer?.cancel();

    await _channelSubscription?.cancel();
    _channelSubscription = null;

    await _channel?.sink.close();
    _channel = null;
  }

  @override
  StreamChannel<String> getStreamChannel() {
    if (!isConnected) {
      throw StateError('WebSocket not connected');
    }

    // Create a sink controller that forwards messages to the WebSocket
    final sinkController = StreamController<String>();
    sinkController.stream.listen((data) {
      send(data).catchError((error) {
        _logger.severe('Failed to send via StreamChannel: $error');
      });
    });

    // Return a StreamChannel that combines our message stream and the sink
    return StreamChannel<String>(messageStream, sinkController.sink);
  }

  @override
  Future<void> dispose() async {
    _logger.info('Disposing WebSocket connection manager');
    await _cleanup();
    await _stateController.close();
    await _messageController.close();
  }

  void _setState(ConnectionState newState) {
    if (_state != newState) {
      final oldState = _state;
      _state = newState;
      _logger.fine('State changed: $oldState -> $newState');
      _stateController.add(newState);
    }
  }
}
