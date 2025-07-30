import 'dart:convert';
import 'package:test/test.dart';
import 'package:shelf/shelf.dart';
import 'package:mynas_backend/middleware/auth.dart';

void main() {
  group('AuthMiddleware', () {
    Response okHandler(Request request) => Response.ok('OK');

    group('none mode', () {
      test('allows all requests', () async {
        final auth = AuthMiddleware(mode: AuthMode.none);
        final handler = auth.middleware(okHandler);

        final request = Request('GET', Uri.parse('http://localhost/test'));
        final response = await handler(request);

        expect(response.statusCode, equals(200));
      });
    });

    group('apiKey mode', () {
      const testApiKey = 'test-api-key-123';
      late AuthMiddleware auth;

      setUp(() {
        auth = AuthMiddleware(mode: AuthMode.apiKey, apiKey: testApiKey);
      });

      test('rejects requests without authentication', () async {
        final handler = auth.middleware(okHandler);
        final request = Request('GET', Uri.parse('http://localhost/test'));
        final response = await handler(request);

        expect(response.statusCode, equals(401));
        expect(
          response.headers['www-authenticate'],
          equals('Bearer realm="MyNAS Manager"'),
        );
      });

      test('accepts requests with valid Bearer token', () async {
        final handler = auth.middleware(okHandler);
        final request = Request(
          'GET',
          Uri.parse('http://localhost/test'),
          headers: {'authorization': 'Bearer $testApiKey'},
        );
        final response = await handler(request);

        expect(response.statusCode, equals(200));
      });

      test('accepts requests with valid X-API-Key header', () async {
        final handler = auth.middleware(okHandler);
        final request = Request(
          'GET',
          Uri.parse('http://localhost/test'),
          headers: {'x-api-key': testApiKey},
        );
        final response = await handler(request);

        expect(response.statusCode, equals(200));
      });

      test('rejects requests with invalid API key', () async {
        final handler = auth.middleware(okHandler);
        final request = Request(
          'GET',
          Uri.parse('http://localhost/test'),
          headers: {'authorization': 'Bearer wrong-key'},
        );
        final response = await handler(request);

        expect(response.statusCode, equals(401));
      });
    });

    group('basic mode', () {
      const testUsername = 'admin';
      const testPassword = 'secret123';
      late AuthMiddleware auth;

      setUp(() {
        auth = AuthMiddleware(
          mode: AuthMode.basic,
          basicUsername: testUsername,
          basicPassword: testPassword,
        );
      });

      test('rejects requests without authentication', () async {
        final handler = auth.middleware(okHandler);
        final request = Request('GET', Uri.parse('http://localhost/test'));
        final response = await handler(request);

        expect(response.statusCode, equals(401));
        expect(
          response.headers['www-authenticate'],
          equals('Basic realm="MyNAS Manager"'),
        );
      });

      test('accepts requests with valid basic auth', () async {
        final handler = auth.middleware(okHandler);
        final credentials = base64.encode(
          utf8.encode('$testUsername:$testPassword'),
        );
        final request = Request(
          'GET',
          Uri.parse('http://localhost/test'),
          headers: {'authorization': 'Basic $credentials'},
        );
        final response = await handler(request);

        expect(response.statusCode, equals(200));
      });

      test('rejects requests with invalid credentials', () async {
        final handler = auth.middleware(okHandler);
        final credentials = base64.encode(utf8.encode('wrong:credentials'));
        final request = Request(
          'GET',
          Uri.parse('http://localhost/test'),
          headers: {'authorization': 'Basic $credentials'},
        );
        final response = await handler(request);

        expect(response.statusCode, equals(401));
      });
    });

    group('validateWebSocketRequest', () {
      test('validates WebSocket requests with API key', () {
        final auth = AuthMiddleware(mode: AuthMode.apiKey, apiKey: 'test-key');

        expect(
          auth.validateWebSocketRequest({'authorization': 'Bearer test-key'}),
          isTrue,
        );

        expect(
          auth.validateWebSocketRequest({'x-api-key': 'test-key'}),
          isTrue,
        );

        expect(
          auth.validateWebSocketRequest({'authorization': 'Bearer wrong-key'}),
          isFalse,
        );
      });
    });

    group('configuration validation', () {
      test('throws error when API key is missing for apiKey mode', () {
        expect(
          () => AuthMiddleware(mode: AuthMode.apiKey),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws error when basic auth credentials are missing', () {
        expect(
          () => AuthMiddleware(mode: AuthMode.basic),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => AuthMiddleware(mode: AuthMode.basic, basicUsername: 'admin'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('fromEnvironment', () {
      test('creates middleware from environment variables', () {
        // This test would need to mock Platform.environment
        // For now, we just test that it doesn't throw
        expect(() => AuthMiddleware.fromEnvironment(), returnsNormally);
      });
    });
  });
}
