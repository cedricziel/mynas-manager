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
import 'package:mynas_backend/factories/truenas_client_factory.dart';
import 'package:mynas_backend/interfaces/truenas_api_client.dart';

class Server {
  final _logger = Logger('Server');
  late final Router _router;
  late final ITrueNasApiClient _trueNasClient;
  late final RpcHandler _rpcHandler;
  HttpServer? _server;
  
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
    _trueNasUrl = trueNasUrl ?? Platform.environment['TRUENAS_URL'] ?? 'ws://localhost/api/current';
    _trueNasApiKey = trueNasApiKey ?? Platform.environment['TRUENAS_API_KEY'];
    _trueNasUsername = trueNasUsername ?? Platform.environment['TRUENAS_USERNAME'];
    _trueNasPassword = trueNasPassword ?? Platform.environment['TRUENAS_PASSWORD'];
    
    _logger.info('Server configuration:');
    _logger.info('  TrueNAS URL (param): $trueNasUrl');
    _logger.info('  TrueNAS URL (env): ${Platform.environment['TRUENAS_URL']}');
    _logger.info('  Final URL: $_trueNasUrl');
    _logger.info('  Has API Key: ${_trueNasApiKey != null ? 'yes' : 'no'}');
    
    _trueNasClient = TrueNasClientFactory.createClient(
      uri: _trueNasUrl,
      apiKey: _trueNasApiKey,
      username: _trueNasUsername,
      password: _trueNasPassword,
    );
    _rpcHandler = RpcHandler(_trueNasClient);
    _setupRoutes();
  }

  void _setupRoutes() {
    _router = Router()
      ..get('/health', _healthHandler)
      ..post('/rpc', _rpcHandler.handle)
      ..get('/ws', webSocketHandler(_handleWebSocket))
      ..all('/<ignored|.*>', _notFoundHandler);
  }
  
  void _handleWebSocket(dynamic webSocket) {
    final handler = WebSocketHandler(webSocket, _trueNasClient);
    handler.start();
  }

  Response _healthHandler(Request request) {
    return Response.ok('{"status":"ok"}', 
      headers: {'content-type': 'application/json'});
  }

  Response _notFoundHandler(Request request) {
    return Response.notFound('{"error":"Not found"}',
      headers: {'content-type': 'application/json'});
  }

  Future<void> start({
    required String host,
    required int port,
  }) async {
    // Initialize TrueNAS client connection
    await _initializeTrueNasClient();
    
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(corsHeaders(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          },
        ))
        .addHandler(_router.call);

    _server = await shelf_io.serve(handler, host, port);
    _logger.info('Server started on $host:$port');
  }

  Future<void> _initializeTrueNasClient() async {
    try {
      _logger.info('Initializing TrueNAS client connection...');
      
      // Connect to TrueNAS using stored configuration
      await _trueNasClient.connect(_trueNasUrl);
      
      // Authenticate if credentials are available
      final apiKey = _trueNasApiKey;
      final username = _trueNasUsername;
      final password = _trueNasPassword;
      
      if (apiKey != null) {
        _logger.info('Authenticating with API key...');
        await _trueNasClient.auth.authenticateWithApiKey(apiKey);
      } else if (username != null && password != null) {
        _logger.info('Authenticating with credentials...');
        await _trueNasClient.auth.authenticateWithCredentials(username, password);
      } else {
        _logger.warning('No authentication credentials provided');
      }
      
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
    
    // Dispose TrueNAS client
    try {
      await _trueNasClient.dispose();
      _logger.info('TrueNAS client disposed');
    } catch (e) {
      _logger.warning('Error disposing TrueNAS client: $e');
    }
    
    _logger.info('Server stopped');
  }
}