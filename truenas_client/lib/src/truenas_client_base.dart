import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logging/logging.dart';
import 'interfaces/connection_api.dart';
import 'models/connection_status.dart';
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
  Timer? _heartbeatTimer;
  StreamController<ConnectionStatus>? _heartbeatController;

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

    // Use auth.login_ex with array parameters
    final response = await call<Map<String, dynamic>>('auth.login_ex', [
      {
        'mechanism': 'PASSWORD_PLAIN',
        'username': username,
        'password': password,
      },
    ]);

    _handleAuthResponse(response);
  }

  Future<void> _authenticateWithUsernameApiKey(
    String username,
    String apiKey,
  ) async {
    _logger.fine('Authenticating with username/API key using auth.login_ex');

    final response = await call<Map<String, dynamic>>('auth.login_ex', [
      {'mechanism': 'API_KEY_PLAIN', 'username': username, 'api_key': apiKey},
    ]);

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

    // Stop heartbeat monitoring
    await stopHeartbeat();

    try {
      // Close the peer first to stop listening
      if (_peer != null) {
        _peer!.close();
        _peer = null;
      }

      // Then close the WebSocket channel
      if (_channel != null) {
        await _channel!.sink.close();
        _channel = null;
      }
    } catch (e) {
      _logger.warning('Error during disconnect: $e');
    }
  }

  @override
  Future<T> call<T>(String method, [List<dynamic> params = const []]) async {
    if (_peer == null) {
      throw const TrueNasException('Not connected to TrueNAS');
    }

    try {
      _logger.fine('Calling $method with params: $params');
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

  @override
  Stream<ConnectionStatus> heartbeat({
    Duration interval = const Duration(seconds: 30),
  }) {
    // Stop any existing heartbeat
    stopHeartbeat();

    // Create new stream controller
    _heartbeatController = StreamController<ConnectionStatus>.broadcast();

    // Start heartbeat timer
    _heartbeatTimer = Timer.periodic(interval, (_) async {
      if (_heartbeatController == null || _heartbeatController!.isClosed) {
        return;
      }

      try {
        // Check if we're connected
        if (_peer == null || _channel == null) {
          _heartbeatController!.add(ConnectionStatus.disconnected);
          return;
        }

        // Try to ping the server using a lightweight call
        // Using 'core.ping' which is a standard JSON-RPC method
        // If not available, fall back to 'system.info' which should always work
        try {
          await call<dynamic>('core.ping').timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('Ping timeout');
            },
          );
          _heartbeatController!.add(ConnectionStatus.connected);
        } on json_rpc.RpcException catch (e) {
          // If core.ping is not available, try system.info
          if (e.code == -32601) {
            // Method not found, try alternative
            await call<Map<String, dynamic>>('system.info').timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException('System info timeout');
              },
            );
            _heartbeatController!.add(ConnectionStatus.connected);
          } else {
            _logger.warning('Heartbeat error: ${e.message}');
            _heartbeatController!.add(ConnectionStatus.error);
          }
        }
      } on TimeoutException {
        _logger.warning('Heartbeat timeout');
        _heartbeatController!.add(ConnectionStatus.error);
      } catch (e) {
        _logger.warning('Heartbeat failed: $e');
        _heartbeatController!.add(ConnectionStatus.error);
      }
    });

    // Send initial status
    if (_peer != null && _channel != null) {
      _heartbeatController!.add(ConnectionStatus.connected);
    } else {
      _heartbeatController!.add(ConnectionStatus.disconnected);
    }

    return _heartbeatController!.stream;
  }

  @override
  Future<void> stopHeartbeat() async {
    _logger.fine('Stopping heartbeat');

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
