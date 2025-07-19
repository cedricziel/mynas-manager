import 'dart:async';

/// Authentication methods supported by TrueNAS
enum AuthMethod {
  credentials,
  apiKey,
}

/// Authentication state
enum AuthState {
  unauthenticated,
  authenticating,
  authenticated,
  expired,
  error,
}

/// Authentication result
class AuthResult {
  final bool success;
  final String? sessionId;
  final String? error;
  final AuthMethod? method;

  const AuthResult({
    required this.success,
    this.sessionId,
    this.error,
    this.method,
  });

  factory AuthResult.success({
    String? sessionId,
    AuthMethod? method,
  }) =>
      AuthResult(
        success: true,
        sessionId: sessionId,
        method: method,
      );

  factory AuthResult.failure(String error) =>
      AuthResult(
        success: false,
        error: error,
      );
}

/// Manages authentication with TrueNAS API
abstract class IAuthManager {
  /// Current authentication state
  AuthState get state;
  
  /// Stream of authentication state changes
  Stream<AuthState> get stateStream;
  
  /// Whether currently authenticated
  bool get isAuthenticated;
  
  /// Current session ID (if available)
  String? get sessionId;
  
  /// Authenticate using username and password
  Future<AuthResult> authenticateWithCredentials(String username, String password);
  
  /// Authenticate using API key
  Future<AuthResult> authenticateWithApiKey(String apiKey);
  
  /// Logout and clear session
  Future<void> logout();
  
  /// Check if current session is still valid
  Future<bool> validateSession();
  
  /// Refresh authentication if needed
  Future<bool> refreshAuth();
}