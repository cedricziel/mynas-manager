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
    if (apiKey == null && (username == null || password == null)) {
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
      if (apiKey != null) {
        await _authenticateWithApiKey();
      } else {
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
    _logger.fine('Authenticating with username/password');

    // TrueNAS expects username and password as array parameters
    final success = await call<bool>('auth.login', [username, password]);

    if (!success) {
      throw const TrueNasAuthException('Invalid username or password');
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
