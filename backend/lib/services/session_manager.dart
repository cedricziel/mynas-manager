import 'dart:async';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';

enum SessionEventType {
  created,
  expired,
  expiringSoon,
  removed,
  activityUpdated,
}

class SessionEvent {
  final SessionEventType type;
  final String sessionId;
  final String? username;
  final DateTime timestamp;
  final Duration? timeRemaining;

  SessionEvent({
    required this.type,
    required this.sessionId,
    this.username,
    required this.timestamp,
    this.timeRemaining,
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'sessionId': sessionId,
    'username': username,
    'timestamp': timestamp.toIso8601String(),
    'timeRemaining': timeRemaining?.inSeconds,
  };
}

class SessionManager {
  final _logger = Logger('SessionManager');
  final Map<String, UserSession> _sessions = {};
  final Duration sessionTimeout;
  final Duration inactivityTimeout;
  Timer? _cleanupTimer;

  // Session event stream
  final _sessionEventController = StreamController<SessionEvent>.broadcast();
  Stream<SessionEvent> get sessionEvents => _sessionEventController.stream;

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

    // Emit session created event
    _sessionEventController.add(
      SessionEvent(
        type: SessionEventType.created,
        sessionId: sessionId,
        username: username,
        timestamp: DateTime.now(),
      ),
    );

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
    final warningThreshold = const Duration(minutes: 5);

    _sessions.forEach((id, session) {
      final timeSinceCreation = now.difference(session.createdAt);
      final timeSinceActivity = now.difference(session.lastActivity);

      // Check for session timeout
      if (timeSinceCreation > sessionTimeout) {
        sessionsToRemove.add(id);
        _logger.info('Session expired (timeout): $id');
        _sessionEventController.add(
          SessionEvent(
            type: SessionEventType.expired,
            sessionId: id,
            username: session.username,
            timestamp: now,
          ),
        );
      }
      // Check for inactivity timeout
      else if (timeSinceActivity > inactivityTimeout) {
        sessionsToRemove.add(id);
        _logger.info('Session expired (inactivity): $id');
        _sessionEventController.add(
          SessionEvent(
            type: SessionEventType.expired,
            sessionId: id,
            username: session.username,
            timestamp: now,
          ),
        );
      }
      // Check if session is expiring soon (within 5 minutes)
      else if (timeSinceActivity > inactivityTimeout - warningThreshold &&
          timeSinceActivity < inactivityTimeout) {
        final timeRemaining = inactivityTimeout - timeSinceActivity;
        _sessionEventController.add(
          SessionEvent(
            type: SessionEventType.expiringSoon,
            sessionId: id,
            username: session.username,
            timestamp: now,
            timeRemaining: timeRemaining,
          ),
        );
        _logger.info(
          'Session expiring soon: $id (${timeRemaining.inMinutes} minutes remaining)',
        );
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
    await _sessionEventController.close();
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

  void stopHeartbeatMonitoring() {
    _heartbeatSubscription?.cancel();
    _heartbeatSubscription = null;
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
