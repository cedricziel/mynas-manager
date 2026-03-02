import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mynas_backend/services/session_manager.dart';
import 'package:truenas_client/truenas_client.dart';

@GenerateMocks([ITrueNasClient])
import 'session_manager_test.mocks.dart';

void main() {
  group('SessionManager', () {
    late SessionManager sessionManager;
    late MockITrueNasClient mockClient;

    setUp(() {
      sessionManager = SessionManager(
        sessionTimeout: const Duration(seconds: 10),
        inactivityTimeout: const Duration(seconds: 5),
      );
      mockClient = MockITrueNasClient();
    });

    tearDown(() async {
      await sessionManager.dispose();
    });

    test('creates a new session', () async {
      final session = await sessionManager.createSession(
        username: 'testuser',
        trueNasClient: mockClient,
        userInfo: {'role': 'admin'},
      );

      expect(session.username, equals('testuser'));
      expect(session.userInfo?['role'], equals('admin'));
      expect(session.id, isNotEmpty);
      expect(sessionManager.activeSessionCount, equals(1));
    });

    test('retrieves an existing session', () async {
      final session = await sessionManager.createSession(
        username: 'testuser',
        trueNasClient: mockClient,
      );

      final retrievedSession = sessionManager.getSession(session.id);
      expect(retrievedSession, isNotNull);
      expect(retrievedSession?.id, equals(session.id));
      expect(retrievedSession?.username, equals('testuser'));
    });

    test('removes a session', () async {
      when(mockClient.stopHeartbeat()).thenAnswer((_) async {});
      when(mockClient.disconnect()).thenAnswer((_) async {});

      final session = await sessionManager.createSession(
        username: 'testuser',
        trueNasClient: mockClient,
      );

      expect(sessionManager.activeSessionCount, equals(1));

      await sessionManager.removeSession(session.id);

      expect(sessionManager.activeSessionCount, equals(0));
      expect(sessionManager.getSession(session.id), isNull);
    });

    test('updates session activity', () async {
      final session = await sessionManager.createSession(
        username: 'testuser',
        trueNasClient: mockClient,
      );

      final originalActivity = session.lastActivity;

      // Wait a bit to ensure time difference
      await Future.delayed(const Duration(milliseconds: 100));

      await sessionManager.updateSessionActivity(session.id);

      final updatedSession = sessionManager.getSession(session.id);
      expect(updatedSession?.lastActivity.isAfter(originalActivity), isTrue);
    });

    test('returns active sessions list', () async {
      await sessionManager.createSession(
        username: 'user1',
        trueNasClient: mockClient,
      );
      await sessionManager.createSession(
        username: 'user2',
        trueNasClient: mockClient,
      );

      final activeSessions = sessionManager.getActiveSessions();
      expect(activeSessions.length, equals(2));
      expect(
        activeSessions.map((s) => s.username),
        containsAll(['user1', 'user2']),
      );
    });

    test('generates unique session IDs', () async {
      final sessions = <String>{};

      for (int i = 0; i < 10; i++) {
        final session = await sessionManager.createSession(
          username: 'user$i',
          trueNasClient: mockClient,
        );
        sessions.add(session.id);
      }

      // All session IDs should be unique
      expect(sessions.length, equals(10));
    });
  });
}
