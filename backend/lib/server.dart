import 'dart:async';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:logging/logging.dart';
import 'package:mynas_backend/rpc/rpc_handler.dart';
import 'package:mynas_backend/rpc/websocket_handler.dart';
import 'package:mynas_backend/middleware/auth.dart';
import 'package:mynas_backend/services/truenas_heartbeat_service.dart';
import 'package:truenas_client/truenas_client.dart';

class Server {
  final _logger = Logger('Server');
  late final Router _router;
  late final ITrueNasClient _trueNasClient;
  late final RpcHandler _rpcHandler;
  late final AuthMiddleware _authMiddleware;
  late final TrueNasHeartbeatService _heartbeatService;
  HttpServer? _server;

  // Active WebSocket handlers
  final List<WebSocketHandler> _activeHandlers = [];

  // Store configuration
  late final String _trueNasUrl;
  late final String? _trueNasApiKey;
  late final String? _trueNasUsername;
  late final String? _trueNasPassword;

  Server({
    String? trueNasUrl,
    String? trueNasApiKey,
    String? trueNasUsername,
    String? trueNasPassword,
  }) {
    // Get configuration from environment or parameters
    _trueNasUrl =
        trueNasUrl ??
        Platform.environment['TRUENAS_URL'] ??
        'ws://localhost/api/current';
    _trueNasApiKey = trueNasApiKey ?? Platform.environment['TRUENAS_API_KEY'];
    _trueNasUsername =
        trueNasUsername ?? Platform.environment['TRUENAS_USERNAME'];
    _trueNasPassword =
        trueNasPassword ?? Platform.environment['TRUENAS_PASSWORD'];

    _logger.info('Server configuration:');
    _logger.info('  TrueNAS URL: $_trueNasUrl');
    _logger.info('  Has API Key: ${_trueNasApiKey != null ? 'yes' : 'no'}');
    _logger.info('  Has Username: ${_trueNasUsername != null ? 'yes' : 'no'}');
    _logger.info('  Has Password: ${_trueNasPassword != null ? 'yes' : 'no'}');

    // Create client based on available credentials
    if (_trueNasApiKey != null && _trueNasUsername != null) {
      // Username/API key authentication (preferred)
      _trueNasClient = TrueNasClient.withUsernameApiKey(
        uri: _trueNasUrl,
        username: _trueNasUsername,
        apiKey: _trueNasApiKey,
      );
    } else if (_trueNasApiKey != null) {
      // API key only authentication
      _trueNasClient = TrueNasClient.withApiKey(
        uri: _trueNasUrl,
        apiKey: _trueNasApiKey,
      );
    } else if (_trueNasUsername != null && _trueNasPassword != null) {
      // Username/password authentication
      _logger.warning(
        'Using username/password authentication. Consider using API key for better security.',
      );
      _trueNasClient = TrueNasClient.withCredentials(
        uri: _trueNasUrl,
        username: _trueNasUsername,
        password: _trueNasPassword,
      );
    } else {
      // No valid credentials provided
      throw ArgumentError(
        'Authentication credentials must be provided. Set either:\n'
        '  - TRUENAS_API_KEY (for API key authentication)\n'
        '  - TRUENAS_USERNAME and TRUENAS_API_KEY (for username/API key authentication)\n'
        '  - TRUENAS_USERNAME and TRUENAS_PASSWORD (for username/password authentication)',
      );
    }
    _rpcHandler = RpcHandler(_trueNasClient);

    // Initialize authentication middleware
    _authMiddleware = AuthMiddleware.fromEnvironment();
    _logger.info('Authentication mode: ${_authMiddleware.mode.name}');

    // Initialize heartbeat service
    _heartbeatService = TrueNasHeartbeatService(client: _trueNasClient);

    _setupRoutes();
  }

  void _setupRoutes() {
    _router = Router()
      ..get('/health', _healthHandler)
      ..post('/rpc', _rpcHandler.handle)
      ..get('/ws', webSocketHandler(_handleWebSocket))
      ..all('/<ignored|.*>', _notFoundHandler);
  }

  void _handleWebSocket(dynamic webSocket, dynamic _) {
    // For WebSocket connections, authentication would need to be handled
    // after connection is established, through the protocol itself
    // Since shelf_web_socket doesn't provide the request context,
    // we'll rely on the WebSocket protocol for authentication

    final handler = WebSocketHandler(
      webSocket,
      _trueNasClient,
      isAuthenticated: _authMiddleware.mode == AuthMode.none,
    );
    _activeHandlers.add(handler);

    // Listen for heartbeat status changes and notify all handlers
    _heartbeatService.connectionStatus.listen((status) {
      handler.notifyConnectionStatus(status);
    });

    handler.start();
  }

  Response _healthHandler(Request request) {
    return Response.ok(
      '{"status":"ok"}',
      headers: {'content-type': 'application/json'},
    );
  }

  Response _notFoundHandler(Request request) {
    return Response.notFound(
      '{"error":"Not found"}',
      headers: {'content-type': 'application/json'},
    );
  }

  Future<void> start({required String host, required int port}) async {
    // Initialize TrueNAS client connection
    await _initializeTrueNasClient();

    // Start heartbeat service
    await _heartbeatService.start();

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(
          corsHeaders(
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
              'Access-Control-Allow-Headers':
                  'Content-Type, Authorization, X-API-Key',
            },
          ),
        )
        .addMiddleware(_authMiddleware.middleware)
        .addHandler(_router.call);

    _server = await shelf_io.serve(handler, host, port);
    _logger.info('Server started on $host:$port');
  }

  Future<void> _initializeTrueNasClient() async {
    try {
      _logger.info('Initializing TrueNAS client connection...');

      // Connect to TrueNAS (authentication happens automatically)
      await _trueNasClient.connect();

      _logger.info('TrueNAS client initialized successfully');
    } catch (e) {
      _logger.severe('Failed to initialize TrueNAS client: $e');
      // Don't rethrow - server can still start and handle other requests
    }
  }

  Future<void> stop() async {
    if (_server != null) {
      await _server!.close();
    }

    // Stop heartbeat service
    await _heartbeatService.stop();

    // Dispose all active WebSocket handlers
    for (final handler in _activeHandlers) {
      handler.dispose();
    }
    _activeHandlers.clear();

    // Dispose TrueNAS client
    try {
      await _trueNasClient.disconnect();
      _logger.info('TrueNAS client disposed');
    } catch (e) {
      _logger.warning('Error disposing TrueNAS client: $e');
    }

    _logger.info('Server stopped');
  }
}
