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
  final String? _apiKey;

  AuthState _state = AuthState.unauthenticated;
  Timer? _sessionCheckTimer;

  TrueNasAuthManager({required IJsonRpcClient jsonRpcClient, String? apiKey})
    : _jsonRpcClient = jsonRpcClient,
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
  Future<AuthResult> authenticateWithApiKey(String apiKey) async {
    _logger.info('Authenticating with API key (header-based)');
    _setState(AuthState.authenticating);

    try {
      // For backend-to-TrueNAS authentication, we use the API key in WebSocket headers.
      // The authentication is handled by the Authorization header in the connection.
      // We don't need to validate immediately - we'll mark as authenticated
      // and let actual API calls validate the key.

      _logger.info('API key authentication configured (header-based)');
      _setState(AuthState.authenticated);
      return AuthResult.success();
    } catch (e) {
      _logger.severe('API key authentication failed: $e');
      _setState(AuthState.error);
      return AuthResult.failure('API key authentication failed: $e');
    }
  }

  // Logout is not needed for API key authentication

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
    } else {
      _logger.warning('No API key available for refresh');
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
