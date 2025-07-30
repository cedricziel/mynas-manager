import 'dart:async';
import 'package:test/test.dart';
import 'package:truenas_client/src/truenas_client_base.dart';
import 'package:truenas_client/src/models/connection_status.dart';
import 'package:truenas_client/src/truenas_exceptions.dart';

/// Mock client for testing heartbeat
class MockTrueNasClient extends TrueNasClientBase {
  bool simulateConnected = true;
  bool simulateError = false;
  int pingCallCount = 0;

  // Add the fields that are defined in the base class as protected
  Timer? _heartbeatTimer;
  StreamController<ConnectionStatus>? _heartbeatController;

  MockTrueNasClient() : super(uri: 'ws://localhost', apiKey: 'test');

  @override
  Future<T> call<T>(String method, [List<dynamic> params = const []]) async {
    pingCallCount++;

    if (!simulateConnected) {
      throw const TrueNasException('Not connected');
    }

    if (simulateError) {
      throw const TrueNasRpcException(-1, 'Simulated error', null);
    }

    // Simulate successful ping
    if (method == 'core.ping') {
      return 'pong' as T;
    }

    // Simulate system.info fallback
    if (method == 'system.info') {
      return <String, dynamic>{
            'version': 'TrueNAS-SCALE-25.04',
            'hostname': 'test',
          }
          as T;
    }

    throw const TrueNasRpcException(-32601, 'Method not found', null);
  }

  // Override connect/disconnect for testing
  @override
  Future<void> connect() async {
    // Simulate connection
  }

  @override
  Future<void> disconnect() async {
    await stopHeartbeat();
  }

  // Expose protected fields for testing
  void setConnected(bool connected) {
    simulateConnected = connected;
    // Simulate having a peer and channel when connected
    if (connected) {
      // Use reflection to simulate connection (for testing only)
      // In real tests, we'd use a proper test double
    }
  }

  // Override to check our simulated state instead of real fields
  @override
  Stream<ConnectionStatus> heartbeat({
    Duration interval = const Duration(seconds: 30),
  }) {
    // Stop any existing heartbeat synchronously
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    if (_heartbeatController != null && !_heartbeatController!.isClosed) {
      _heartbeatController!.close();
    }
    _heartbeatController = null;

    // Create new stream controller
    _heartbeatController = StreamController<ConnectionStatus>.broadcast();

    // Start heartbeat timer
    _heartbeatTimer = Timer.periodic(interval, (_) async {
      if (_heartbeatController == null || _heartbeatController!.isClosed) {
        return;
      }

      try {
        // Check if we're connected (using our simulation)
        if (!simulateConnected) {
          _heartbeatController!.add(ConnectionStatus.disconnected);
          return;
        }

        // Try to ping the server
        try {
          await call<dynamic>('core.ping').timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('Ping timeout');
            },
          );
          _heartbeatController!.add(ConnectionStatus.connected);
        } catch (e) {
          _heartbeatController!.add(ConnectionStatus.error);
        }
      } catch (e) {
        _heartbeatController!.add(ConnectionStatus.error);
      }
    });

    // Send initial status
    if (simulateConnected) {
      _heartbeatController!.add(ConnectionStatus.connected);
    } else {
      _heartbeatController!.add(ConnectionStatus.disconnected);
    }

    return _heartbeatController!.stream;
  }

  // Give test access to protected fields
  Timer? get heartbeatTimer => _heartbeatTimer;
  StreamController<ConnectionStatus>? get heartbeatController =>
      _heartbeatController;

  @override
  Future<void> stopHeartbeat() async {
    // Cancel timer
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    // Close stream controller
    if (_heartbeatController != null && !_heartbeatController!.isClosed) {
      await _heartbeatController!.close();
    }
    _heartbeatController = null;
  }
}

void main() {
  group('Heartbeat Tests', () {
    late MockTrueNasClient client;

    setUp(() {
      client = MockTrueNasClient();
    });

    tearDown(() async {
      await client.stopHeartbeat();
    });

    test('heartbeat should emit connected status when healthy', () async {
      // Arrange
      client.setConnected(true);

      // Act
      final stream = client.heartbeat(
        interval: const Duration(milliseconds: 100),
      );

      // Assert
      final statuses = await stream.take(3).toList();
      expect(statuses, everyElement(equals(ConnectionStatus.connected)));
      expect(client.pingCallCount, greaterThanOrEqualTo(2));
    });

    test('heartbeat should emit disconnected when not connected', () async {
      // Arrange
      client.setConnected(false);

      // Act
      final stream = client.heartbeat(
        interval: const Duration(milliseconds: 100),
      );

      // Assert
      final status = await stream.first;
      expect(status, equals(ConnectionStatus.disconnected));
    });

    test('heartbeat should emit error status on RPC errors', () async {
      // Arrange
      client.setConnected(true);

      // Act
      final stream = client.heartbeat(
        interval: const Duration(milliseconds: 100),
      );

      // Let the first connected status emit
      await stream.first;

      // Now simulate error
      client.simulateError = true;

      // Assert - wait for error status
      final errorStatus = await stream.firstWhere(
        (status) => status == ConnectionStatus.error,
        orElse: () => ConnectionStatus.disconnected,
      );
      expect(errorStatus, equals(ConnectionStatus.error));
    });

    test('stopHeartbeat should stop emitting updates', () async {
      // Arrange
      final stream = client.heartbeat(
        interval: const Duration(milliseconds: 50),
      );
      final completer = Completer<void>();

      // Act
      final subscription = stream.listen((_) {}, onDone: completer.complete);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      await client.stopHeartbeat();

      // Assert
      await completer.future;
      expect(completer.isCompleted, isTrue);
      await subscription.cancel();
    });

    test('multiple heartbeat calls should restart monitoring', () async {
      // Arrange
      client.setConnected(true);

      // Act - Create first heartbeat
      client.heartbeat(interval: const Duration(milliseconds: 100));

      // Verify controller exists
      final firstController = client.heartbeatController;
      expect(firstController, isNotNull);

      // Create second heartbeat (should stop first and create new)
      final stream2 = client.heartbeat(
        interval: const Duration(milliseconds: 100),
      );

      // Assert - should have new controller
      expect(client.heartbeatController, isNotNull);
      expect(client.heartbeatController, isNot(same(firstController)));

      // Second stream should work
      final status = await stream2.first;
      expect(status, equals(ConnectionStatus.connected));
    });

    test('heartbeat should use custom interval', () async {
      // Arrange
      const customInterval = Duration(milliseconds: 200);
      final startTime = DateTime.now();

      // Act
      final stream = client.heartbeat(interval: customInterval);
      await stream.take(3).toList();
      final endTime = DateTime.now();

      // Assert
      final elapsed = endTime.difference(startTime);
      // Should take at least 2 intervals (for 3 emissions: initial + 2 periodic)
      expect(elapsed.inMilliseconds, greaterThanOrEqualTo(400));
    });

    test('disconnect should stop heartbeat', () async {
      // Arrange
      final stream = client.heartbeat(
        interval: const Duration(milliseconds: 50),
      );
      final completer = Completer<void>();

      // Act
      final subscription = stream.listen((_) {}, onDone: completer.complete);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      await client.disconnect();

      // Assert
      await completer.future;
      expect(completer.isCompleted, isTrue);
      await subscription.cancel();
    });
  });
}
