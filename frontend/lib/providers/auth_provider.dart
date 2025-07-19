import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final String? username;
  final String? serverUrl;

  const AuthState({
    this.isAuthenticated = false,
    this.username,
    this.serverUrl,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? username,
    String? serverUrl,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      serverUrl: serverUrl ?? this.serverUrl,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login({
    required String username,
    required String password,
    String? serverUrl,
  }) async {
    try {
      // TODO: Implement actual authentication
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        isAuthenticated: true,
        username: username,
        serverUrl: serverUrl,
      );
      
      return true;
    } catch (e) {
      state = const AuthState();
      return false;
    }
  }

  void logout() {
    state = const AuthState();
  }
}