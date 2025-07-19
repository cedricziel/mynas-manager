import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';
import 'package:mynas_backend/services/truenas_client.dart';
import 'package:mynas_shared/mynas_shared.dart';

class RpcHandler {
  final _logger = Logger('RpcHandler');
  final TrueNasClient _trueNasClient;

  RpcHandler(this._trueNasClient);

  Future<Response> handle(Request request) async {
    try {
      final body = await request.readAsString();
      final server = json_rpc.Server();
      
      _registerMethods(server);
      
      final response = await server.parseRequest(body);
      
      return Response.ok(
        response,
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      _logger.severe('RPC error: $e');
      return Response.internalServerError(
        body: jsonEncode({
          'jsonrpc': '2.0',
          'error': {
            'code': -32603,
            'message': 'Internal error',
            'data': e.toString(),
          },
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  void _registerMethods(json_rpc.Server server) {
    // System methods
    server.registerMethod('system.info', _getSystemInfo);
    server.registerMethod('system.alerts', _getAlerts);
    
    // Pool methods
    server.registerMethod('pool.list', _listPools);
    server.registerMethod('pool.get', _getPool);
    
    // Dataset methods
    server.registerMethod('dataset.list', _listDatasets);
    server.registerMethod('dataset.get', _getDataset);
    server.registerMethod('dataset.create', _createDataset);
    
    // Share methods
    server.registerMethod('share.list', _listShares);
    server.registerMethod('share.get', _getShare);
    server.registerMethod('share.create', _createShare);
    server.registerMethod('share.update', _updateShare);
    server.registerMethod('share.delete', _deleteShare);
  }

  Future<Map<String, dynamic>> _getSystemInfo(json_rpc.Parameters params) async {
    final info = await _trueNasClient.getSystemInfo();
    return info.toJson();
  }

  Future<List<Map<String, dynamic>>> _getAlerts(json_rpc.Parameters params) async {
    final alerts = await _trueNasClient.getAlerts();
    return alerts.map((a) => a.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> _listPools(json_rpc.Parameters params) async {
    final pools = await _trueNasClient.listPools();
    return pools.map((p) => p.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getPool(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final pool = await _trueNasClient.getPool(id);
    return pool.toJson();
  }

  Future<List<Map<String, dynamic>>> _listDatasets(json_rpc.Parameters params) async {
    final poolId = params['poolId'].asStringOr(null);
    final datasets = await _trueNasClient.listDatasets(poolId: poolId);
    return datasets.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDataset(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final dataset = await _trueNasClient.getDataset(id);
    return dataset.toJson();
  }

  Future<Map<String, dynamic>> _createDataset(json_rpc.Parameters params) async {
    final pool = params['pool'].asString;
    final name = params['name'].asString;
    final properties = params['properties'].asMapOr({});
    
    final dataset = await _trueNasClient.createDataset(
      pool: pool,
      name: name,
      properties: properties as Map<String, dynamic>,
    );
    return dataset.toJson();
  }

  Future<List<Map<String, dynamic>>> _listShares(json_rpc.Parameters params) async {
    final type = params['type'].asStringOr(null);
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
    final shareData = Share.fromJson(params.asMap);
    final share = await _trueNasClient.createShare(shareData);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _updateShare(json_rpc.Parameters params) async {
    final shareData = Share.fromJson(params.asMap);
    final share = await _trueNasClient.updateShare(shareData);
    return share.toJson();
  }

  Future<bool> _deleteShare(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    return await _trueNasClient.deleteShare(id);
  }
}