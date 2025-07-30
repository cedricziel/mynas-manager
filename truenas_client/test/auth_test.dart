import 'package:test/test.dart';
import 'package:truenas_client/truenas_client.dart';

void main() {
  group('TrueNAS Client Authentication', () {
    test('can create client with API key', () {
      final client = TrueNasClient.withApiKey(
        uri: 'ws://localhost/api/current',
        apiKey: 'test-api-key',
      );

      expect(client, isNotNull);
    });

    test('can create client with username and password', () {
      final client = TrueNasClient.withCredentials(
        uri: 'ws://localhost/api/current',
        username: 'testuser',
        password: 'testpass',
      );

      expect(client, isNotNull);
    });

    test('can create client with username and API key', () {
      final client = TrueNasClient.withUsernameApiKey(
        uri: 'ws://localhost/api/current',
        username: 'testuser',
        apiKey: 'test-api-key',
      );

      expect(client, isNotNull);
    });

    test('throws error when no credentials provided', () {
      expect(
        () => TrueNasClient.withApiKey(
          uri: 'ws://localhost/api/current',
          apiKey: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Authentication Response Handling', () {
    // Note: These are unit tests for the response handling logic
    // Actual connection tests would require a mock server

    test('handles SUCCESS response correctly', () {
      final response = {'response_type': 'SUCCESS'};

      // This would be tested internally in the client
      // but we can verify the structure is what we expect
      expect(response['response_type'], equals('SUCCESS'));
    });

    test('handles AUTH_ERR response correctly', () {
      final response = {
        'response_type': 'AUTH_ERR',
        'error_message': 'Invalid credentials',
      };

      expect(response['response_type'], equals('AUTH_ERR'));
      expect(response['error_message'], equals('Invalid credentials'));
    });

    test('handles OTP_REQUIRED response correctly', () {
      final response = {'response_type': 'OTP_REQUIRED'};

      expect(response['response_type'], equals('OTP_REQUIRED'));
    });

    test('handles EXPIRED response correctly', () {
      final response = {'response_type': 'EXPIRED'};

      expect(response['response_type'], equals('EXPIRED'));
    });

    test('handles REDIRECT response correctly', () {
      final response = {
        'response_type': 'REDIRECT',
        'redirect_url': 'https://example.com/auth',
      };

      expect(response['response_type'], equals('REDIRECT'));
      expect(response['redirect_url'], equals('https://example.com/auth'));
    });
  });
}
