import 'dart:async';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mynas_backend/services/truenas_heartbeat_service.dart';
import 'package:truenas_client/truenas_client.dart';

@GenerateMocks([ITrueNasClient])
import 'truenas_heartbeat_service_test.mocks.dart';

void main() {
  group('TrueNasHeartbeatService', () {
    late MockITrueNasClient mockClient;
    late TrueNasHeartbeatService service;
    late StreamController<ConnectionStatus> heartbeatController;

    setUp(() {
      mockClient = MockITrueNasClient();
      heartbeatController = StreamController<ConnectionStatus>.broadcast();

      // Setup mock heartbeat stream
      when(
        mockClient.heartbeat(interval: anyNamed('interval')),
      ).thenAnswer((_) => heartbeatController.stream);

      when(mockClient.stopHeartbeat()).thenAnswer((_) async {});

      service = TrueNasHeartbeatService(
        client: mockClient,
        heartbeatInterval: const Duration(seconds: 1),
        reconnectDelay: const Duration(milliseconds: 100),
        maxReconnectAttempts: 3,
      );
    });

    tearDown(() async {
      await service.dispose();
      await heartbeatController.close();
    });

    test('starts heartbeat monitoring', () async {
      await service.start();

      verify(
        mockClient.heartbeat(interval: const Duration(seconds: 1)),
      ).called(1);
    });

    test('emits connection status changes', () async {
      await service.start();

      final statuses = <ConnectionStatus>[];
      service.connectionStatus.listen(statuses.add);

      // Simulate status changes
      heartbeatController.add(ConnectionStatus.connected);
      await Future.delayed(Duration.zero);
      heartbeatController.add(ConnectionStatus.disconnected);
      await Future.delayed(Duration.zero);
      heartbeatController.add(ConnectionStatus.error);
      await Future.delayed(Duration.zero);

      expect(statuses, [
        ConnectionStatus.connected,
        ConnectionStatus.disconnected,
        ConnectionStatus.error,
      ]);
    });

    test('broadcasts connection status changes', () async {
      await service.start();

      // Simulate status changes
      heartbeatController.add(ConnectionStatus.disconnected);
      await Future.delayed(const Duration(milliseconds: 50));

      // Verify status is tracked
      expect(service.currentConnectionStatus, ConnectionStatus.disconnected);
    });

    test('maintains connection status through multiple changes', () async {
      await service.start();

      // Initial state
      expect(service.currentConnectionStatus, ConnectionStatus.disconnected);

      // Change to connected
      heartbeatController.add(ConnectionStatus.connected);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(service.currentConnectionStatus, ConnectionStatus.connected);

      // Change to error
      heartbeatController.add(ConnectionStatus.error);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(service.currentConnectionStatus, ConnectionStatus.error);
    });

    test('stops heartbeat monitoring', () async {
      await service.start();
      await service.stop();

      verify(mockClient.stopHeartbeat()).called(1);
    });

    test('handles errors in heartbeat stream', () async {
      await service.start();

      final statuses = <ConnectionStatus>[];
      service.connectionStatus.listen(statuses.add);

      // Simulate error in heartbeat stream
      heartbeatController.addError('Test error');
      await Future.delayed(Duration.zero);

      expect(statuses, [ConnectionStatus.error]);
    });

    test('current connection status reflects latest status', () async {
      await service.start();

      expect(service.currentConnectionStatus, ConnectionStatus.disconnected);

      heartbeatController.add(ConnectionStatus.connected);
      await Future.delayed(Duration.zero);
      expect(service.currentConnectionStatus, ConnectionStatus.connected);

      heartbeatController.add(ConnectionStatus.error);
      await Future.delayed(Duration.zero);
      expect(service.currentConnectionStatus, ConnectionStatus.error);
    });
  });
}
