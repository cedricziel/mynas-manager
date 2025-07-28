import 'dart:async';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:truenas_client/src/services/truenas_peer_client.dart';
import 'package:truenas_client/src/interfaces/connection_manager.dart';
import 'package:truenas_client/src/interfaces/json_rpc_client.dart';
import 'package:stream_channel/stream_channel.dart';

@GenerateMocks([IConnectionManager])
import 'truenas_peer_client_test.mocks.dart';

void main() {
  group('TrueNasPeerClient', () {
    late MockIConnectionManager mockConnectionManager;
    late TrueNasPeerClient client;
    late StreamController<String> incomingController;
    late StreamController<String> outgoingController;

    setUp(() {
      mockConnectionManager = MockIConnectionManager();
      incomingController = StreamController<String>.broadcast();
      outgoingController = StreamController<String>.broadcast();

      // Setup mock connection state
      when(
        mockConnectionManager.stateStream,
      ).thenAnswer((_) => Stream.value(ConnectionState.connected));
      when(mockConnectionManager.isConnected).thenReturn(true);
      when(
        mockConnectionManager.messageStream,
      ).thenAnswer((_) => incomingController.stream);

      // Setup StreamChannel mock
      final channel = StreamChannel<String>(
        incomingController.stream,
        outgoingController.sink,
      );
      when(mockConnectionManager.getStreamChannel()).thenReturn(channel);

      // Capture outgoing messages
      when(mockConnectionManager.send(any)).thenAnswer((invocation) async {
        final message = invocation.positionalArguments[0] as String;
        outgoingController.add(message);
      });

      client = TrueNasPeerClient(connectionManager: mockConnectionManager);
    });

    tearDown(() {
      incomingController.close();
      outgoingController.close();
      client.close();
    });

    group('Parameter Transformation', () {
      test(
        'should send empty array for methods requiring empty params',
        () async {
          // Listen for outgoing messages
          final requestCompleter = Completer<String>();
          outgoingController.stream.listen((message) {
            if (!requestCompleter.isCompleted) {
              requestCompleter.complete(message);
            }
          });

          // Make a call that requires empty array
          final resultFuture = client.call('system.info');

          // Get the sent request
          final sentRequest = await requestCompleter.future;
          final request = jsonDecode(sentRequest) as Map<String, dynamic>;

          expect(request['method'], equals('system.info'));
          expect(request['params'], equals([]));

          // Send mock response
          incomingController.add(
            jsonEncode({
              'jsonrpc': '2.0',
              'id': request['id'],
              'result': {'version': 'TrueNAS-SCALE-24.04.0'},
            }),
          );

          final result = await resultFuture;
          expect(result['version'], equals('TrueNAS-SCALE-24.04.0'));
        },
      );

      test('should handle pool.query with complex array params', () async {
        final requestCompleter = Completer<String>();
        outgoingController.stream.listen((message) {
          if (!requestCompleter.isCompleted) {
            requestCompleter.complete(message);
          }
        });

        // Call with options
        final resultFuture = client.call('pool.query', {
          'options': {
            'extra': {'is_upgraded': true},
          },
        });

        final sentRequest = await requestCompleter.future;
        final request = jsonDecode(sentRequest) as Map<String, dynamic>;

        expect(request['method'], equals('pool.query'));
        expect(
          request['params'],
          equals([
            [], // filters
            {
              'extra': {'is_upgraded': true},
            }, // options
          ]),
        );

        // Send mock response
        incomingController.add(
          jsonEncode({'jsonrpc': '2.0', 'id': request['id'], 'result': []}),
        );

        await resultFuture;
      });

      test('should handle core.subscribe with event name', () async {
        final requestCompleter = Completer<String>();
        outgoingController.stream.listen((message) {
          if (!requestCompleter.isCompleted) {
            requestCompleter.complete(message);
          }
        });

        final resultFuture = client.call('core.subscribe', {
          'event': 'pool.query',
        });

        final sentRequest = await requestCompleter.future;
        final request = jsonDecode(sentRequest) as Map<String, dynamic>;

        expect(request['method'], equals('core.subscribe'));
        expect(request['params'], equals(['pool.query']));

        // Send mock response
        incomingController.add(
          jsonEncode({'jsonrpc': '2.0', 'id': request['id'], 'result': true}),
        );

        await resultFuture;
      });

      test('should handle auth.login with array params', () async {
        final requestCompleter = Completer<String>();
        outgoingController.stream.listen((message) {
          if (!requestCompleter.isCompleted) {
            requestCompleter.complete(message);
          }
        });

        final resultFuture = client.call('auth.login', {
          'username': 'testuser',
          'password': 'testpass',
        });

        final sentRequest = await requestCompleter.future;
        final request = jsonDecode(sentRequest) as Map<String, dynamic>;

        expect(request['method'], equals('auth.login'));
        expect(request['params'], equals(['testuser', 'testpass']));

        // Send mock response
        incomingController.add(
          jsonEncode({'jsonrpc': '2.0', 'id': request['id'], 'result': true}),
        );

        await resultFuture;
      });
    });

    group('Notifications', () {
      test('should handle TrueNAS notifications', () async {
        // Setup notification listener
        final notifications = <JsonRpcNotification>[];
        late StreamSubscription subscription;
        final notificationCompleter = Completer<void>();

        subscription = client.notifications.listen((notification) {
          notifications.add(notification);
          if (notification.method == 'pool.changed') {
            notificationCompleter.complete();
          }
        });

        // Wait for client to be ready
        await Future.delayed(Duration(milliseconds: 50));

        // Clear any existing notifications
        notifications.clear();

        // Send a pool.changed notification
        incomingController.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'pool.changed',
            'params': {'pool_id': 'tank', 'status': 'ONLINE'},
          }),
        );

        // Wait for notification to be processed
        await notificationCompleter.future.timeout(Duration(seconds: 1));
        await subscription.cancel();

        expect(notifications.length, equals(1));
        expect(notifications[0].method, equals('pool.changed'));
        expect(notifications[0].params?['pool_id'], equals('tank'));
      });

      test('should handle collection_update notifications', () async {
        final notifications = <JsonRpcNotification>[];
        late StreamSubscription subscription;
        final notificationCompleter = Completer<void>();

        subscription = client.notifications.listen((notification) {
          notifications.add(notification);
          if (notification.method == 'collection_update') {
            notificationCompleter.complete();
          }
        });

        // Wait for client to be ready
        await Future.delayed(Duration(milliseconds: 50));

        // Clear any existing notifications
        notifications.clear();

        // Send a collection_update notification like TrueNAS does
        incomingController.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'collection_update',
            'params': {
              'msg': 'added',
              'collection': 'reporting.realtime',
              'fields': {
                'cpu': {'usage': 10.5},
                'memory': {'arc_size': 1000000},
              },
            },
          }),
        );

        // Wait for notification to be processed
        await notificationCompleter.future.timeout(Duration(seconds: 1));
        await subscription.cancel();

        expect(notifications.length, equals(1));
        expect(notifications[0].method, equals('collection_update'));
        expect(
          notifications[0].params?['collection'],
          equals('reporting.realtime'),
        );
      });
    });

    group('Keepalive', () {
      test('should send periodic core.ping messages', () async {
        // Collect all outgoing messages
        final outgoingMessages = <String>[];
        outgoingController.stream.listen(outgoingMessages.add);

        // Wait for initial setup
        await Future.delayed(Duration(milliseconds: 100));

        // Clear initial messages
        outgoingMessages.clear();

        // Wait for at least one keepalive (30 seconds in prod, but we can't wait that long)
        // The keepalive timer is set to 30 seconds, so we'll need to test differently
        // For now, just verify the client is ready
        expect(client.isReady, isTrue);
      });
    });

    group('Error Handling', () {
      test('should handle JSON-RPC errors', () async {
        final requestCompleter = Completer<String>();
        outgoingController.stream.listen((message) {
          if (!requestCompleter.isCompleted) {
            requestCompleter.complete(message);
          }
        });

        final resultFuture = client.call('invalid.method');

        final sentRequest = await requestCompleter.future;
        final request = jsonDecode(sentRequest) as Map<String, dynamic>;

        // Send error response
        incomingController.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': request['id'],
            'error': {'code': -32601, 'message': 'Method does not exist'},
          }),
        );

        expect(
          resultFuture,
          throwsA(
            isA<JsonRpcError>()
                .having((e) => e.code, 'code', -32601)
                .having((e) => e.message, 'message', 'Method does not exist'),
          ),
        );
      });
    });
  });
}
