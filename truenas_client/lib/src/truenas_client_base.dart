import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logging/logging.dart';
import 'interfaces/connection_api.dart';
import 'truenas_exceptions.dart';

/// Base TrueNAS client with connection functionality
abstract class TrueNasClientBase implements IConnectionApi {
  final _logger = Logger('TrueNasClient');
  final String uri;
  final String? apiKey;
  final String? username;
  final String? password;

  WebSocketChannel? _channel;
  json_rpc.Peer? _peer;

  TrueNasClientBase({
    required this.uri,
    this.apiKey,
    this.username,
    this.password,
  }) {
    // Check for empty strings as well as null values
    final hasApiKey = apiKey != null && apiKey!.isNotEmpty;
    final hasUsername = username != null && username!.isNotEmpty;
    final hasPassword = password != null && password!.isNotEmpty;

    if (!hasApiKey && (!hasUsername || !hasPassword)) {
      throw ArgumentError(
        'Either apiKey or username/password must be provided',
      );
    }
  }

  @override
  Future<void> connect() async {
    try {
      _logger.info('Connecting to TrueNAS at $uri');

      // Create WebSocket connection
      _channel = IOWebSocketChannel.connect(uri);
      await _channel!.ready;

      // Create JSON-RPC Peer
      _peer = json_rpc.Peer(_channel!.cast<String>());

      // Start listening (don't await - it completes when connection closes)
      _peer!.listen().catchError((Object error) {
        _logger.severe('Peer connection error: $error');
      });

      _logger.info('Connected, authenticating...');

      // Authenticate based on provided credentials
      final hasApiKey = apiKey != null && apiKey!.isNotEmpty;
      final hasUsername = username != null && username!.isNotEmpty;

      if (hasApiKey && hasUsername) {
        // Username/API key authentication (new)
        await _authenticateWithUsernameApiKey(username!, apiKey!);
      } else if (hasApiKey) {
        // API key only authentication
        await _authenticateWithApiKey();
      } else {
        // Username/password authentication
        await _authenticateWithCredentials();
      }

      _logger.info('Authentication successful');
    } catch (e) {
      await disconnect();
      rethrow;
    }
  }

  Future<void> _authenticateWithApiKey() async {
    _logger.fine('Authenticating with API key');

    // TrueNAS expects API key as single array parameter
    final success = await call<bool>('auth.login_with_api_key', [apiKey]);

    if (!success) {
      throw const TrueNasAuthException('Invalid API key');
    }
  }

  Future<void> _authenticateWithCredentials() async {
    _logger.fine('Authenticating with username/password using auth.login_ex');

    // Use auth.login_ex for more flexible authentication
    final response = await call<Map<String, dynamic>>('auth.login_ex', {
      'mechanism': 'PASSWORD_PLAIN',
      'username': username,
      'password': password,
    });

    _handleAuthResponse(response);
  }

  Future<void> _authenticateWithUsernameApiKey(
    String username,
    String apiKey,
  ) async {
    _logger.fine('Authenticating with username/API key using auth.login_ex');

    final response = await call<Map<String, dynamic>>('auth.login_ex', {
      'mechanism': 'API_KEY',
      'username': username,
      'api_key': apiKey,
    });

    _handleAuthResponse(response);
  }

  void _handleAuthResponse(Map<String, dynamic> response) {
    final responseType = response['response_type'] as String?;

    switch (responseType) {
      case 'SUCCESS':
        // Authentication successful
        _logger.info('Authentication successful');
        return;
      case 'OTP_REQUIRED':
        throw const TrueNasOtpRequiredException();
      case 'AUTH_ERR':
        throw TrueNasAuthException(
          (response['error_message'] as String?) ?? 'Authentication failed',
        );
      case 'EXPIRED':
        throw const TrueNasExpiredCredentialsException();
      case 'REDIRECT':
        // Handle redirect if needed in the future
        throw TrueNasAuthException(
          'Authentication redirect: ${response['redirect_url']}',
        );
      default:
        throw TrueNasAuthException(
          'Unknown authentication response: $responseType',
        );
    }
  }

  @override
  Future<void> disconnect() async {
    _logger.info('Disconnecting from TrueNAS');

    try {
      await _channel?.sink.close();
    } catch (e) {
      _logger.warning('Error closing WebSocket: $e');
    }

    _channel = null;
    _peer = null;
  }

  @override
  Future<T> call<T>(String method, [dynamic params]) async {
    if (_peer == null) {
      throw const TrueNasException('Not connected to TrueNAS');
    }

    try {
      _logger.fine('Calling $method');
      final result = await _peer!.sendRequest(method, params);
      return result as T;
    } on json_rpc.RpcException catch (e) {
      _logger.warning('RPC error calling $method: ${e.code} - ${e.message}');
      throw TrueNasRpcException(e.code, e.message, e.data);
    } catch (e) {
      _logger.severe('Unexpected error calling $method: $e');
      rethrow;
    }
  }
}
