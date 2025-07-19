import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
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
      final jsonRequest = jsonDecode(body);
      
      // Handle JSON-RPC request manually
      final method = jsonRequest['method'] as String?;
      final params = jsonRequest['params'] ?? {};
      final id = jsonRequest['id'];
      
      if (method == null) {
        return _errorResponse(id, -32600, 'Invalid Request');
      }
      
      try {
        final result = await _handleMethod(method, params);
        return Response.ok(
          jsonEncode({
            'jsonrpc': '2.0',
            'result': result,
            'id': id,
          }),
          headers: {'content-type': 'application/json'},
        );
      } catch (e) {
        _logger.severe('Method error: $e');
        return _errorResponse(id, -32603, 'Internal error', e.toString());
      }
    } catch (e) {
      _logger.severe('RPC error: $e');
      return _errorResponse(null, -32700, 'Parse error');
    }
  }
  
  Response _errorResponse(dynamic id, int code, String message, [String? data]) {
    return Response.ok(
      jsonEncode({
        'jsonrpc': '2.0',
        'error': {
          'code': code,
          'message': message,
          if (data != null) 'data': data,
        },
        'id': id,
      }),
      headers: {'content-type': 'application/json'},
    );
  }

  Future<dynamic> _handleMethod(String method, Map<String, dynamic> params) async {
    switch (method) {
      // System methods
      case 'system.info':
        return await _getSystemInfo(params);
      case 'system.alerts':
        return await _getAlerts(params);
      
      // Pool methods
      case 'pool.list':
        return await _listPools(params);
      case 'pool.get':
        return await _getPool(params);
      
      // Dataset methods
      case 'dataset.list':
        return await _listDatasets(params);
      case 'dataset.get':
        return await _getDataset(params);
      case 'dataset.create':
        return await _createDataset(params);
      
      // Share methods
      case 'share.list':
        return await _listShares(params);
      case 'share.get':
        return await _getShare(params);
      case 'share.create':
        return await _createShare(params);
      case 'share.update':
        return await _updateShare(params);
      case 'share.delete':
        return await _deleteShare(params);
      
      default:
        throw Exception('Method not found: $method');
    }
  }

  Future<Map<String, dynamic>> _getSystemInfo(Map<String, dynamic> params) async {
    final info = await _trueNasClient.getSystemInfo();
    return info.toJson();
  }

  Future<List<Map<String, dynamic>>> _getAlerts(Map<String, dynamic> params) async {
    final alerts = await _trueNasClient.getAlerts();
    return alerts.map((a) => a.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> _listPools(Map<String, dynamic> params) async {
    final pools = await _trueNasClient.listPools();
    return pools.map((p) => p.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getPool(Map<String, dynamic> params) async {
    final id = params['id'] as String;
    final pool = await _trueNasClient.getPool(id);
    return pool.toJson();
  }

  Future<List<Map<String, dynamic>>> _listDatasets(Map<String, dynamic> params) async {
    final poolId = params['poolId'] as String?;
    final datasets = await _trueNasClient.listDatasets(poolId: poolId);
    return datasets.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDataset(Map<String, dynamic> params) async {
    final id = params['id'] as String;
    final dataset = await _trueNasClient.getDataset(id);
    return dataset.toJson();
  }

  Future<Map<String, dynamic>> _createDataset(Map<String, dynamic> params) async {
    final pool = params['pool'] as String;
    final name = params['name'] as String;
    final properties = params['properties'] as Map<String, dynamic>? ?? {};
    
    final dataset = await _trueNasClient.createDataset(
      pool: pool,
      name: name,
      properties: properties,
    );
    return dataset.toJson();
  }

  Future<List<Map<String, dynamic>>> _listShares(Map<String, dynamic> params) async {
    final type = params['type'] as String?;
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

  Future<Map<String, dynamic>> _getShare(Map<String, dynamic> params) async {
    final id = params['id'] as String;
    final share = await _trueNasClient.getShare(id);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _createShare(Map<String, dynamic> params) async {
    final shareData = Share.fromJson(params);
    final share = await _trueNasClient.createShare(shareData);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _updateShare(Map<String, dynamic> params) async {
    final shareData = Share.fromJson(params);
    final share = await _trueNasClient.updateShare(shareData);
    return share.toJson();
  }

  Future<bool> _deleteShare(Map<String, dynamic> params) async {
    final id = params['id'] as String;
    return await _trueNasClient.deleteShare(id);
  }
}