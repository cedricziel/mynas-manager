import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/services/rpc_client.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final rpcClient = ref.watch(rpcClientProvider);
  return AuthNotifier(rpcClient);
});

class AuthState {
  final bool isAuthenticated;
  final String? username;
  final String? serverUrl;
  final String? sessionId;
  final Map<String, dynamic>? userInfo;
  final String? error;
  final Duration? sessionExpiringIn;

  const AuthState({
    this.isAuthenticated = false,
    this.username,
    this.serverUrl,
    this.sessionId,
    this.userInfo,
    this.error,
    this.sessionExpiringIn,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? username,
    String? serverUrl,
    String? sessionId,
    Map<String, dynamic>? userInfo,
    String? error,
    Duration? sessionExpiringIn,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      serverUrl: serverUrl ?? this.serverUrl,
      sessionId: sessionId ?? this.sessionId,
      userInfo: userInfo ?? this.userInfo,
      error: error,
      sessionExpiringIn: sessionExpiringIn ?? this.sessionExpiringIn,
    );
  }
}

// Separate notifier for router refresh
class AuthRouterRefreshNotifier extends ChangeNotifier {
  AuthRouterRefreshNotifier(Ref ref) {
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (_, next) {
      notifyListeners();
    });
  }
}

final authRouterRefreshProvider = Provider<AuthRouterRefreshNotifier>((ref) {
  return AuthRouterRefreshNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final RpcClient _rpcClient;
  StreamSubscription<Map<String, dynamic>>? _sessionEventSubscription;

  AuthNotifier(this._rpcClient) : super(const AuthState()) {
    _listenToSessionEvents();
  }

  void _listenToSessionEvents() {
    _sessionEventSubscription = _rpcClient.sessionEvents.listen((event) {
      final eventType = event['type'] as String?;

      switch (eventType) {
        case 'expired':
          _handleSessionExpired();
          break;
        case 'expiringSoon':
          _handleSessionExpiringSoon(event);
          break;
      }
    });
  }

  void _handleSessionExpired() {
    state = const AuthState(
      isAuthenticated: false,
      error: 'Your session has expired. Please log in again.',
    );
  }

  void _handleSessionExpiringSoon(Map<String, dynamic> event) {
    final timeRemaining = event['timeRemaining'] as int?;
    if (timeRemaining != null) {
      state = state.copyWith(
        sessionExpiringIn: Duration(seconds: timeRemaining),
      );
    }
  }

  @override
  void dispose() {
    _sessionEventSubscription?.cancel();
    super.dispose();
  }

  Future<bool> login({
    required String username,
    required String password,
    String? serverUrl,
  }) async {
    try {
      state = state.copyWith(error: null);

      final result = await _rpcClient.login(
        username: username,
        password: password,
        trueNasUrl: serverUrl,
      );

      if (result['success'] == true) {
        state = state.copyWith(
          isAuthenticated: true,
          username: username,
          serverUrl: serverUrl,
          sessionId: result['sessionId'] as String?,
          userInfo: result['userInfo'] as Map<String, dynamic>?,
        );
        return true;
      } else {
        state = state.copyWith(
          error: result['error'] as String? ?? 'Login failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _rpcClient.logout();
    } catch (e) {
      // Log error but continue with local logout
    }

    state = const AuthState();
  }

  Future<void> refreshSession() async {
    if (!state.isAuthenticated) return;

    try {
      final sessionInfo = await _rpcClient.getSessionInfo();
      state = state.copyWith(
        userInfo: sessionInfo['userInfo'] as Map<String, dynamic>?,
      );
    } catch (e) {
      // Session might be expired
      state = const AuthState();
    }
  }
}
