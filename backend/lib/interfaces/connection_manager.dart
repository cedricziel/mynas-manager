import 'dart:async';

/// Connection states for the WebSocket connection
enum ConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Manages WebSocket connections with automatic reconnection and state tracking
abstract class IConnectionManager {
  /// Current connection state
  ConnectionState get state;
  
  /// Stream of connection state changes
  Stream<ConnectionState> get stateStream;
  
  /// Whether the connection is currently active
  bool get isConnected;
  
  /// Connect to the specified WebSocket URI
  Future<void> connect(String uri);
  
  /// Disconnect from the WebSocket
  Future<void> disconnect();
  
  /// Send raw data through the WebSocket
  Future<void> send(String data);
  
  /// Stream of incoming messages
  Stream<String> get messageStream;
  
  /// Dispose resources and close connections
  Future<void> dispose();
}