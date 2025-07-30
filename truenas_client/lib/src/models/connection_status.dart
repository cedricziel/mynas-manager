/// Connection status for heartbeat monitoring
enum ConnectionStatus {
  /// WebSocket is connected and responsive
  connected,

  /// WebSocket is disconnected
  disconnected,

  /// Attempting to reconnect
  reconnecting,

  /// Connection error occurred
  error,
}
