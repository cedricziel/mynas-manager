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
import 'package:mynas_backend/rpc/session_websocket_handler.dart';
import 'package:mynas_backend/rpc/hybrid_websocket_handler.dart';
import 'package:mynas_backend/middleware/auth.dart';
import 'package:mynas_backend/services/truenas_heartbeat_service.dart';
import 'package:mynas_backend/services/session_manager.dart';
import 'package:truenas_client/truenas_client.dart';

class Server {
  final _logger = Logger('Server');
  late final Router _router;
  late final ITrueNasClient? _trueNasClient;
  late final RpcHandler? _rpcHandler;
  late final AuthMiddleware _authMiddleware;
  late final TrueNasHeartbeatService? _heartbeatService;
  late final SessionManager _sessionManager;
  HttpServer? _server;

  // Authentication mode
  final bool useSessionAuth;
  final bool useHybridAuth;

  // Active WebSocket handlers
  final List<dynamic> _activeHandlers = [];

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
    this.useSessionAuth = false,
    this.useHybridAuth = false,
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
    _logger.info(
      '  Auth Mode: ${useHybridAuth ? 'hybrid' : (useSessionAuth ? 'session' : 'legacy')}',
    );

    // Initialize authentication middleware
    _authMiddleware = AuthMiddleware.fromEnvironment();
    _logger.info('  Backend Auth Mode: ${_authMiddleware.mode.name}');

    // Initialize session manager
    _sessionManager = SessionManager();

    if (useSessionAuth && !useHybridAuth) {
      // Session-only authentication mode
      _logger.info('Using session-only authentication');
      // No shared TrueNAS client needed
      _trueNasClient = null;
      _rpcHandler = null;
      _heartbeatService = null;
    } else {
      // Shared connection mode (legacy)
      _logger.info('  Has API Key: ${_trueNasApiKey != null ? 'yes' : 'no'}');
      _logger.info(
        '  Has Username: ${_trueNasUsername != null ? 'yes' : 'no'}',
      );
      _logger.info(
        '  Has Password: ${_trueNasPassword != null ? 'yes' : 'no'}',
      );

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
      _rpcHandler = RpcHandler(_trueNasClient!);
      _heartbeatService = TrueNasHeartbeatService(client: _trueNasClient);
    }

    _setupRoutes();
  }

  void _setupRoutes() {
    _router = Router()..get('/health', _healthHandler);

    if (!useSessionAuth && _rpcHandler != null) {
      _router.post('/rpc', _rpcHandler.handle);
    }

    _router
      ..get('/ws', webSocketHandler(_handleWebSocket))
      ..all('/<ignored|.*>', _notFoundHandler);
  }

  void _handleWebSocket(dynamic webSocket, dynamic _) {
    if (useHybridAuth) {
      // Hybrid authentication mode (both API key and session)
      final handler = HybridWebSocketHandler(
        webSocket,
        _sessionManager,
        _trueNasClient,
        _trueNasUrl,
      );
      _activeHandlers.add(handler);

      // Listen for heartbeat status changes if we have a shared client
      if (_heartbeatService != null) {
        _heartbeatService.connectionStatus.listen((status) {
          handler.notifyConnectionStatus(status);
        });
      }

      handler.start();
    } else if (useSessionAuth) {
      // Session-only authentication mode
      final handler = SessionWebSocketHandler(
        webSocket,
        _sessionManager,
        _trueNasUrl,
      );
      _activeHandlers.add(handler);
      handler.start();
    } else {
      // Legacy shared connection mode
      final handler = WebSocketHandler(
        webSocket,
        _trueNasClient!,
        isAuthenticated: _authMiddleware.mode == AuthMode.none,
      );
      _activeHandlers.add(handler);

      // Listen for heartbeat status changes and notify all handlers
      _heartbeatService?.connectionStatus.listen((status) {
        handler.notifyConnectionStatus(status);
      });

      handler.start();
    }
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
    if (!useSessionAuth || useHybridAuth) {
      // Initialize TrueNAS client connection for shared/hybrid mode
      await _initializeTrueNasClient();

      // Start heartbeat service
      await _heartbeatService?.start();
    }

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
    if (_trueNasClient == null) return;

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
    await _heartbeatService?.stop();

    // Dispose all active WebSocket handlers
    for (final handler in _activeHandlers) {
      if (handler is WebSocketHandler) {
        handler.dispose();
      } else if (handler is SessionWebSocketHandler) {
        handler.dispose();
      } else if (handler is HybridWebSocketHandler) {
        handler.dispose();
      }
    }
    _activeHandlers.clear();

    // Dispose session manager
    await _sessionManager.dispose();

    // Dispose TrueNAS client
    if (_trueNasClient != null) {
      try {
        await _trueNasClient.disconnect();
        _logger.info('TrueNAS client disposed');
      } catch (e) {
        _logger.warning('Error disposing TrueNAS client: $e');
      }
    }

    _logger.info('Server stopped');
  }
}
