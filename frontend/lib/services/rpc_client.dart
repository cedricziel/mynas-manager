import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rpcClientProvider = Provider<RpcClient>((ref) {
  final client = RpcClient();
  ref.onDispose(() => client.disconnect());
  return client;
});

class RpcClient {
  final _logger = Logger('RpcClient');
  WebSocketChannel? _channel;
  json_rpc.Peer? _peer;
  final _connectionCompleter = Completer<void>();
  bool _isConnected = false;
  String? _sessionId;
  Timer? _heartbeatTimer;

  bool get isConnected => _isConnected;
  String? get sessionId => _sessionId;

  Future<void> connect({
    String host = 'localhost',
    int port = 8080,
    bool secure = false,
  }) async {
    try {
      final protocol = secure ? 'wss' : 'ws';
      final url = '$protocol://$host:$port/ws';

      _logger.info('Connecting to $url');

      // Create WebSocket connection
      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Create JSON-RPC peer
      _peer = json_rpc.Peer(_channel!.cast<String>());

      // Start listening
      unawaited(
        _peer!
            .listen()
            .then((_) {
              _logger.info('WebSocket connection closed');
              _isConnected = false;
            })
            .catchError((error) {
              _logger.severe('WebSocket error: $error');
              _isConnected = false;
            }),
      );

      _isConnected = true;
      _connectionCompleter.complete();
      _logger.info('Connected to backend');
    } catch (e) {
      _logger.severe('Failed to connect: $e');
      _isConnected = false;
      rethrow;
    }
  }

  Future<void> disconnect() async {
    _stopHeartbeat();
    await _peer?.close();
    await _channel?.sink.close();
    _isConnected = false;
    _sessionId = null;
    _logger.info('Disconnected from backend');
  }

  Future<T> sendRequest<T>(
    String method, [
    Map<String, dynamic>? params,
  ]) async {
    if (!_isConnected || _peer == null) {
      await connect();
    }

    try {
      final result = await _peer!.sendRequest(method, params);
      return result as T;
    } catch (e) {
      _logger.severe('RPC request failed: $e');
      rethrow;
    }
  }

  void sendNotification(String method, [Map<String, dynamic>? params]) {
    if (!_isConnected || _peer == null) {
      throw StateError('Not connected');
    }

    _peer!.sendNotification(method, params);
  }

  // Convenience methods for common operations
  Future<Map<String, dynamic>> getSystemInfo() async {
    return await sendRequest('system.info');
  }

  Future<List<dynamic>> getAlerts() async {
    return await sendRequest('system.alerts');
  }

  Future<List<dynamic>> listPools() async {
    return await sendRequest('pool.list');
  }

  Future<Map<String, dynamic>> getPool(String id) async {
    return await sendRequest('pool.get', {'id': id});
  }

  Future<List<dynamic>> listDatasets({String? poolId}) async {
    return await sendRequest('dataset.list', {
      if (poolId != null) 'poolId': poolId,
    });
  }

  Future<Map<String, dynamic>> getDataset(String id) async {
    return await sendRequest('dataset.get', {'id': id});
  }

  Future<Map<String, dynamic>> createDataset({
    required String pool,
    required String name,
    Map<String, dynamic>? properties,
  }) async {
    return await sendRequest('dataset.create', {
      'pool': pool,
      'name': name,
      if (properties != null) 'properties': properties,
    });
  }

  Future<List<dynamic>> listShares({String? type}) async {
    return await sendRequest('share.list', {if (type != null) 'type': type});
  }

  Future<Map<String, dynamic>> getShare(String id) async {
    return await sendRequest('share.get', {'id': id});
  }

  Future<Map<String, dynamic>> createShare(
    Map<String, dynamic> shareData,
  ) async {
    return await sendRequest('share.create', shareData);
  }

  Future<Map<String, dynamic>> updateShare(
    Map<String, dynamic> shareData,
  ) async {
    return await sendRequest('share.update', shareData);
  }

  Future<bool> deleteShare(String id) async {
    return await sendRequest('share.delete', {'id': id});
  }

  // Authentication methods
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    String? trueNasUrl,
  }) async {
    final result = await sendRequest<Map<String, dynamic>>('auth.login', {
      'username': username,
      'password': password,
      if (trueNasUrl != null) 'trueNasUrl': trueNasUrl,
    });

    // Store session ID
    _sessionId = result['sessionId'] as String?;

    // Start heartbeat
    if (_sessionId != null) {
      _startHeartbeat();
    }

    return result;
  }

  Future<Map<String, dynamic>> logout() async {
    final result = await sendRequest<Map<String, dynamic>>('auth.logout');
    _sessionId = null;
    _stopHeartbeat();
    return result;
  }

  Future<Map<String, dynamic>> getSessionInfo() async {
    return await sendRequest('session.info');
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      try {
        await sendRequest('session.heartbeat');
      } catch (e) {
        _logger.warning('Heartbeat failed: $e');
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }
}
