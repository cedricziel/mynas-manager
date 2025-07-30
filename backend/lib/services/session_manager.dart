import 'dart:async';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';

class SessionManager {
  final _logger = Logger('SessionManager');
  final Map<String, UserSession> _sessions = {};
  final Duration sessionTimeout;
  final Duration inactivityTimeout;
  Timer? _cleanupTimer;

  SessionManager({
    this.sessionTimeout = const Duration(hours: 24),
    this.inactivityTimeout = const Duration(minutes: 15),
  }) {
    // Start periodic cleanup
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _cleanupExpiredSessions(),
    );
  }

  Future<UserSession> createSession({
    required String username,
    required ITrueNasClient trueNasClient,
    Map<String, dynamic>? userInfo,
  }) async {
    final sessionId = _generateSessionId();
    final session = UserSession(
      id: sessionId,
      username: username,
      trueNasClient: trueNasClient,
      createdAt: DateTime.now(),
      lastActivity: DateTime.now(),
      userInfo: userInfo,
    );

    _sessions[sessionId] = session;
    _logger.info('Created session for user: $username (ID: $sessionId)');

    return session;
  }

  UserSession? getSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session != null) {
      // Update last activity
      session.lastActivity = DateTime.now();
    }
    return session;
  }

  Future<void> removeSession(String sessionId) async {
    final session = _sessions[sessionId];
    if (session != null) {
      try {
        await session.dispose();
      } catch (e) {
        _logger.warning('Error disposing session $sessionId: $e');
      }
      _sessions.remove(sessionId);
      _logger.info('Removed session: $sessionId');
    }
  }

  Future<void> updateSessionActivity(String sessionId) async {
    final session = _sessions[sessionId];
    if (session != null) {
      session.lastActivity = DateTime.now();
    }
  }

  void _cleanupExpiredSessions() {
    final now = DateTime.now();
    final sessionsToRemove = <String>[];

    _sessions.forEach((id, session) {
      // Check for session timeout
      if (now.difference(session.createdAt) > sessionTimeout) {
        sessionsToRemove.add(id);
        _logger.info('Session expired (timeout): $id');
      }
      // Check for inactivity timeout
      else if (now.difference(session.lastActivity) > inactivityTimeout) {
        sessionsToRemove.add(id);
        _logger.info('Session expired (inactivity): $id');
      }
    });

    // Remove expired sessions
    for (final id in sessionsToRemove) {
      removeSession(id);
    }

    if (sessionsToRemove.isNotEmpty) {
      _logger.info('Cleaned up ${sessionsToRemove.length} expired sessions');
    }
  }

  String _generateSessionId() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final hash = sha256.convert(values);
    return hash.toString();
  }

  Future<void> dispose() async {
    _cleanupTimer?.cancel();

    // Dispose all sessions
    final futures = _sessions.values.map((session) => session.dispose());
    await Future.wait(futures);

    _sessions.clear();
    _logger.info('SessionManager disposed');
  }

  int get activeSessionCount => _sessions.length;

  List<SessionInfo> getActiveSessions() {
    return _sessions.values
        .map(
          (session) => SessionInfo(
            id: session.id,
            username: session.username,
            createdAt: session.createdAt,
            lastActivity: session.lastActivity,
          ),
        )
        .toList();
  }
}

class UserSession {
  final String id;
  final String username;
  final ITrueNasClient trueNasClient;
  final DateTime createdAt;
  DateTime lastActivity;
  final Map<String, dynamic>? userInfo;

  // Heartbeat subscription for this user's TrueNAS connection
  StreamSubscription<ConnectionStatus>? _heartbeatSubscription;

  UserSession({
    required this.id,
    required this.username,
    required this.trueNasClient,
    required this.createdAt,
    required this.lastActivity,
    this.userInfo,
  });

  void startHeartbeatMonitoring(Function(ConnectionStatus) onStatusChange) {
    _heartbeatSubscription = trueNasClient
        .heartbeat(interval: const Duration(seconds: 30))
        .listen(onStatusChange);
  }

  Future<void> dispose() async {
    await _heartbeatSubscription?.cancel();
    await trueNasClient.stopHeartbeat();
    await trueNasClient.disconnect();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
      'userInfo': userInfo,
    };
  }
}

class SessionInfo {
  final String id;
  final String username;
  final DateTime createdAt;
  final DateTime lastActivity;

  SessionInfo({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.lastActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
    };
  }
}
