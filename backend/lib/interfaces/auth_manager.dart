import 'dart:async';

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
  final String? error;

  const AuthResult({required this.success, this.error});

  factory AuthResult.success() => const AuthResult(success: true);

  factory AuthResult.failure(String error) =>
      AuthResult(success: false, error: error);
}

/// Manages authentication with TrueNAS API
abstract class IAuthManager {
  /// Current authentication state
  AuthState get state;

  /// Stream of authentication state changes
  Stream<AuthState> get stateStream;

  /// Whether currently authenticated
  bool get isAuthenticated;

  /// Authenticate using API key
  Future<AuthResult> authenticateWithApiKey(String apiKey);

  /// Check if current session is still valid
  Future<bool> validateSession();

  /// Refresh authentication if needed
  Future<bool> refreshAuth();
}
