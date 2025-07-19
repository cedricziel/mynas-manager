import 'dart:async';
import 'package:logging/logging.dart';
import '../interfaces/auth_manager.dart';
import '../interfaces/json_rpc_client.dart';

/// TrueNAS authentication manager
class TrueNasAuthManager implements IAuthManager {
  final _logger = Logger('TrueNasAuthManager');
  final StreamController<AuthState> _stateController = 
      StreamController<AuthState>.broadcast();
  
  final IJsonRpcClient _jsonRpcClient;
  final String? _username;
  final String? _password;
  final String? _apiKey;
  
  AuthState _state = AuthState.unauthenticated;
  String? _sessionId;
  Timer? _sessionCheckTimer;

  TrueNasAuthManager({
    required IJsonRpcClient jsonRpcClient,
    String? username,
    String? password,
    String? apiKey,
  }) : _jsonRpcClient = jsonRpcClient,
       _username = username,
       _password = password,
       _apiKey = apiKey {
    _initialize();
  }

  void _initialize() {
    // Start periodic session validation
    _sessionCheckTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _checkSessionValidity(),
    );
  }

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stateStream => _stateController.stream;

  @override
  bool get isAuthenticated => _state == AuthState.authenticated;

  @override
  String? get sessionId => _sessionId;

  @override
  Future<AuthResult> authenticateWithCredentials(String username, String password) async {
    _logger.info('Authenticating with credentials for user: $username');
    _setState(AuthState.authenticating);

    try {
      final result = await _jsonRpcClient.call('auth.login', {
        'username': username,
        'password': password,
      });

      if (result is bool && result) {
        _logger.info('Authentication successful');
        _setState(AuthState.authenticated);
        return AuthResult.success(method: AuthMethod.credentials);
      } else if (result is Map<String, dynamic>) {
        // Some versions return session info
        final sessionId = result['session_id']?.toString();
        _sessionId = sessionId;
        _logger.info('Authentication successful with session ID');
        _setState(AuthState.authenticated);
        return AuthResult.success(
          sessionId: sessionId,
          method: AuthMethod.credentials,
        );
      } else {
        _logger.warning('Authentication failed: unexpected result type');
        _setState(AuthState.error);
        return AuthResult.failure('Authentication failed: unexpected response');
      }
    } catch (e) {
      _logger.severe('Authentication failed: $e');
      _setState(AuthState.error);
      return AuthResult.failure('Authentication failed: $e');
    }
  }

  @override
  Future<AuthResult> authenticateWithApiKey(String apiKey) async {
    _logger.info('Authenticating with API key');
    _setState(AuthState.authenticating);

    try {
      // For WebSocket API with headers, we assume authentication is handled
      // by the Authorization header in the WebSocket connection.
      // We'll validate by calling a simple authenticated method.
      
      try {
        // Test authentication by calling auth.me
        await _jsonRpcClient.call('auth.me');
        _logger.info('API key authentication successful (header-based)');
        _setState(AuthState.authenticated);
        return AuthResult.success(method: AuthMethod.apiKey);
      } catch (e) {
        // If auth.me fails, the API key might be invalid or headers not working
        _logger.warning('API key authentication failed - auth.me test failed: $e');
        _setState(AuthState.error);
        return AuthResult.failure('API key authentication failed: $e');
      }
    } catch (e) {
      _logger.severe('API key authentication failed: $e');
      _setState(AuthState.error);
      return AuthResult.failure('API key authentication failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    _logger.info('Logging out');

    try {
      if (isAuthenticated) {
        await _jsonRpcClient.call('auth.logout');
      }
    } catch (e) {
      _logger.warning('Logout failed: $e');
    } finally {
      _sessionId = null;
      _setState(AuthState.unauthenticated);
    }
  }

  @override
  Future<bool> validateSession() async {
    if (!isAuthenticated) {
      return false;
    }

    try {
      // Try to call a simple authenticated method
      await _jsonRpcClient.call('auth.me');
      return true;
    } catch (e) {
      _logger.warning('Session validation failed: $e');
      _setState(AuthState.expired);
      return false;
    }
  }

  @override
  Future<bool> refreshAuth() async {
    _logger.info('Refreshing authentication');

    if (_apiKey != null) {
      final result = await authenticateWithApiKey(_apiKey);
      return result.success;
    } else if (_username != null && _password != null) {
      final result = await authenticateWithCredentials(_username, _password);
      return result.success;
    } else {
      _logger.warning('No credentials available for refresh');
      return false;
    }
  }

  Future<void> _checkSessionValidity() async {
    if (isAuthenticated) {
      final isValid = await validateSession();
      if (!isValid) {
        _logger.info('Session expired, attempting to refresh');
        await refreshAuth();
      }
    }
  }

  void _setState(AuthState newState) {
    if (_state != newState) {
      final oldState = _state;
      _state = newState;
      _logger.fine('Auth state changed: $oldState -> $newState');
      _stateController.add(newState);
    }
  }

  void dispose() {
    _sessionCheckTimer?.cancel();
    _stateController.close();
  }
}