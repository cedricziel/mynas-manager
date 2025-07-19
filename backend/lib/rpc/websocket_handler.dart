import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';
import 'package:mynas_backend/interfaces/truenas_api_client.dart';
import 'package:mynas_shared/mynas_shared.dart';

class WebSocketHandler {
  final _logger = Logger('WebSocketHandler');
  final WebSocketChannel _channel;
  final ITrueNasApiClient _trueNasClient;
  late final json_rpc.Peer _peer;

  WebSocketHandler(WebSocketChannel webSocket, this._trueNasClient)
    : _channel = webSocket;

  void start() {
    _logger.info('New WebSocket connection established');

    // Create JSON-RPC peer
    _peer = json_rpc.Peer(_channel.cast<String>());

    // Register all methods
    _registerMethods();

    // Start listening
    _peer
        .listen()
        .then((_) {
          _logger.info('WebSocket connection closed');
        })
        .catchError((error) {
          _logger.severe('WebSocket error: $error');
        });
  }

  void _registerMethods() {
    // System methods
    _peer.registerMethod('system.info', _getSystemInfo);
    _peer.registerMethod('system.alerts', _getAlerts);

    // Pool methods
    _peer.registerMethod('pool.list', _listPools);
    _peer.registerMethod('pool.get', _getPool);

    // Dataset methods
    _peer.registerMethod('dataset.list', _listDatasets);
    _peer.registerMethod('dataset.get', _getDataset);
    _peer.registerMethod('dataset.create', _createDataset);

    // Share methods
    _peer.registerMethod('share.list', _listShares);
    _peer.registerMethod('share.get', _getShare);
    _peer.registerMethod('share.create', _createShare);
    _peer.registerMethod('share.update', _updateShare);
    _peer.registerMethod('share.delete', _deleteShare);

    // Connection methods
    _peer.registerMethod('truenas.connect', _connectToTrueNAS);
    _peer.registerMethod('truenas.disconnect', _disconnectFromTrueNAS);
  }

  // TrueNAS connection methods
  Future<Map<String, dynamic>> _connectToTrueNAS(
    json_rpc.Parameters params,
  ) async {
    final url = params['url'].asString;

    // TODO: Create WebSocket connection to TrueNAS
    return {'connected': true, 'url': url};
  }

  Future<void> _disconnectFromTrueNAS(json_rpc.Parameters params) async {
    // TODO: Disconnect from TrueNAS
  }

  // System methods
  Future<Map<String, dynamic>> _getSystemInfo(
    json_rpc.Parameters params,
  ) async {
    final info = await _trueNasClient.getSystemInfo();
    return info.toJson();
  }

  Future<List<Map<String, dynamic>>> _getAlerts(
    json_rpc.Parameters params,
  ) async {
    final alerts = await _trueNasClient.getAlerts();
    return alerts.map((a) => a.toJson()).toList();
  }

  // Pool methods
  Future<List<Map<String, dynamic>>> _listPools(
    json_rpc.Parameters params,
  ) async {
    final pools = await _trueNasClient.listPools();
    return pools.map((p) => p.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getPool(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final pool = await _trueNasClient.getPool(id);
    return pool.toJson();
  }

  // Dataset methods
  Future<List<Map<String, dynamic>>> _listDatasets(
    json_rpc.Parameters params,
  ) async {
    String? poolId;
    try {
      poolId = params['poolId'].asString;
    } catch (_) {
      poolId = null;
    }
    final datasets = await _trueNasClient.listDatasets(poolId: poolId);
    return datasets.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDataset(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final dataset = await _trueNasClient.getDataset(id);
    return dataset.toJson();
  }

  Future<Map<String, dynamic>> _createDataset(
    json_rpc.Parameters params,
  ) async {
    final pool = params['pool'].asString;
    final name = params['name'].asString;
    final properties = params['properties'].asMapOr({});

    final dataset = await _trueNasClient.createDataset(
      pool: pool,
      name: name,
      properties: properties.cast<String, dynamic>(),
    );
    return dataset.toJson();
  }

  // Share methods
  Future<List<Map<String, dynamic>>> _listShares(
    json_rpc.Parameters params,
  ) async {
    String? type;
    try {
      type = params['type'].asString;
    } catch (_) {
      type = null;
    }
    ShareType? shareType;
    if (type != null) {
      shareType = ShareType.values.firstWhere(
        (t) => t.name == type,
        orElse: () => throw ArgumentError('Invalid share type: $type'),
      );
    }

    final shares = await _trueNasClient.listShares(type: shareType);
    return shares.map((s) => s.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getShare(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final share = await _trueNasClient.getShare(id);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _createShare(json_rpc.Parameters params) async {
    final shareData = Share.fromJson(params.asMap.cast<String, dynamic>());
    final share = await _trueNasClient.createShare(shareData);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _updateShare(json_rpc.Parameters params) async {
    final shareData = Share.fromJson(params.asMap.cast<String, dynamic>());
    final share = await _trueNasClient.updateShare(shareData);
    return share.toJson();
  }

  Future<bool> _deleteShare(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    return await _trueNasClient.deleteShare(id);
  }
}
