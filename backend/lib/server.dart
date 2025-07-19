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
import 'package:mynas_backend/services/truenas_client.dart';

class Server {
  final _logger = Logger('Server');
  late final Router _router;
  late final TrueNasClient _trueNasClient;
  late final RpcHandler _rpcHandler;
  HttpServer? _server;

  Server() {
    _trueNasClient = TrueNasClient();
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

  Future<void> stop() async {
    if (_server != null) {
      await _server!.close();
      _logger.info('Server stopped');
    }
  }
}