import '../interfaces/truenas_api_client.dart';
import '../services/websocket_connection_manager.dart';
import '../services/json_rpc_websocket_client.dart';
import '../services/truenas_auth_manager.dart';
import '../services/truenas_version_manager.dart';
import '../services/truenas_event_manager.dart';
import '../services/token_bucket_rate_limiter.dart';
import '../services/truenas_websocket_client.dart';

/// Factory for creating TrueNAS API client instances with proper dependency injection
class TrueNasClientFactory {
  /// Create a production TrueNAS client with all dependencies
  static ITrueNasApiClient createClient({
    required String uri,
    String? username,
    String? password,
    String? apiKey,
  }) {
    // Create connection manager
    final connectionManager = WebSocketConnectionManager();
    
    // Configure authentication headers if API key is provided
    if (apiKey != null) {
      connectionManager.setAuthHeaders({
        'Authorization': 'Bearer $apiKey',
      });
    }
    
    // Create JSON-RPC client
    final jsonRpcClient = JsonRpcWebSocketClient(
      connectionManager: connectionManager,
    );
    
    // Create authentication manager
    final authManager = TrueNasAuthManager(
      jsonRpcClient: jsonRpcClient,
      username: username,
      password: password,
      apiKey: apiKey,
    );
    
    // Create version manager
    final versionManager = TrueNasVersionManager(
      jsonRpcClient: jsonRpcClient,
    );
    
    // Create event manager
    final eventManager = TrueNasEventManager(
      jsonRpcClient: jsonRpcClient,
    );
    
    // Create rate limiter with TrueNAS settings
    final rateLimiter = TokenBucketRateLimiter.truenas();
    
    // Create the main client
    return TrueNasWebSocketClient(
      connectionManager: connectionManager,
      authManager: authManager,
      versionManager: versionManager,
      eventManager: eventManager,
      jsonRpcClient: jsonRpcClient,
      rateLimiter: rateLimiter,
    );
  }

  /// Create a client factory function for lazy initialization
  static ITrueNasApiClient Function() createClientFactory({
    required String uri,
    String? username,
    String? password,
    String? apiKey,
  }) {
    return () => createClient(
      uri: uri,
      username: username,
      password: password,
      apiKey: apiKey,
    );
  }
}