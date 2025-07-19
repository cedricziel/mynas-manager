import 'dart:async';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../interfaces/connection_manager.dart';

/// WebSocket connection manager with automatic reconnection
class WebSocketConnectionManager implements IConnectionManager {
  final _logger = Logger('WebSocketConnectionManager');
  final StreamController<ConnectionState> _stateController = StreamController<ConnectionState>.broadcast();
  final StreamController<String> _messageController = StreamController<String>.broadcast();
  
  WebSocketChannel? _channel;
  StreamSubscription? _channelSubscription;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  
  ConnectionState _state = ConnectionState.disconnected;
  String? _uri;
  int _reconnectAttempts = 0;
  
  // Configuration
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const Duration _heartbeatInterval = Duration(seconds: 30);
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
    if (_state == ConnectionState.connecting || _state == ConnectionState.connected) {
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

  Future<void> _connectWebSocket() async {
    if (_uri == null) {
      throw StateError('URI not set');
    }

    try {
      _channel = IOWebSocketChannel.connect(
        _uri!,
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

      // Start heartbeat
      _startHeartbeat();
      
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
    final delay = Duration(seconds: _reconnectDelay.inSeconds * _reconnectAttempts);
    
    _logger.info('Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s');
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

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_state == ConnectionState.connected) {
        try {
          // Send ping frame
          _channel?.sink.add('{"jsonrpc":"2.0","method":"core.ping","id":"heartbeat"}');
        } catch (e) {
          _logger.warning('Heartbeat failed: $e');
          _onError(e);
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
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    
    await _channelSubscription?.cancel();
    _channelSubscription = null;
    
    await _channel?.sink.close();
    _channel = null;
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