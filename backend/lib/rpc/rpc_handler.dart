import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';

class RpcHandler {
  final _logger = Logger('RpcHandler');
  final ITrueNasClient _trueNasClient;

  RpcHandler(this._trueNasClient);

  Future<Response> handle(Request request) async {
    dynamic requestId;

    try {
      final body = await request.readAsString();

      // Validate JSON format
      Map<String, dynamic> jsonRequest;
      try {
        jsonRequest = jsonDecode(body) as Map<String, dynamic>;
      } catch (e) {
        _logger.warning('JSON parse error: $e');
        return _errorResponse(
          null,
          -32700,
          'Parse error',
          'Invalid JSON format',
        );
      }

      // Extract request components
      final method = jsonRequest['method'] as String?;
      final params = jsonRequest['params'] ?? {};
      requestId = jsonRequest['id'];

      // Validate JSON-RPC format
      if (jsonRequest['jsonrpc'] != '2.0') {
        return _errorResponse(
          requestId,
          -32600,
          'Invalid Request',
          'Missing or invalid jsonrpc version',
        );
      }

      if (method == null || method.isEmpty) {
        return _errorResponse(
          requestId,
          -32600,
          'Invalid Request',
          'Missing method field',
        );
      }

      // Validate parameters format
      if (params is! Map<String, dynamic> && params is! List) {
        return _errorResponse(
          requestId,
          -32602,
          'Invalid params',
          'Parameters must be object or array',
        );
      }

      try {
        final result = await _handleMethod(method, params);
        return Response.ok(
          jsonEncode({'jsonrpc': '2.0', 'result': result, 'id': requestId}),
          headers: {'content-type': 'application/json'},
        );
      } on TrueNasException catch (e) {
        _logger.warning('TrueNAS error for $method: $e');
        return _mapTrueNasExceptionToResponse(e, requestId);
      } catch (e) {
        _logger.severe('Unexpected error for $method: $e');
        return _errorResponse(
          requestId,
          -32603,
          'Internal error',
          e.toString(),
        );
      }
    } catch (e) {
      _logger.severe('Request handling error: $e');
      return _errorResponse(
        requestId,
        -32603,
        'Internal error',
        'Failed to process request',
      );
    }
  }

  Response _errorResponse(
    dynamic id,
    int code,
    String message, [
    String? data,
  ]) {
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

  /// Maps TrueNAS exceptions to appropriate JSON-RPC error responses
  Response _mapTrueNasExceptionToResponse(
    TrueNasException exception,
    dynamic requestId,
  ) {
    // Check specific exceptions first
    if (exception is TrueNasAuthException) {
      return _errorResponse(
        requestId,
        401,
        'Authentication required',
        exception.message,
      );
    } else if (exception is TrueNasNotFoundException) {
      return _errorResponse(
        requestId,
        404,
        'Resource not found',
        exception.message,
      );
    } else if (exception is TrueNasRpcException) {
      return _errorResponse(
        requestId,
        exception.code,
        'RPC error',
        exception.message,
      );
      // Note: We don't need a generic TrueNasException check here
      // because we've already handled all specific TrueNAS exception types
    } else {
      return _errorResponse(
        requestId,
        -32603,
        'Internal error',
        exception.message,
      );
    }
  }

  Future<dynamic> _handleMethod(
    String method,
    Map<String, dynamic> params,
  ) async {
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

      // Disk methods
      case 'disk.list':
        return await _listDisks(params);
      case 'disk.get':
        return await _getDisk(params);
      // The following methods are not yet implemented:
      // case 'disk.temperatures':
      // case 'disk.temperature_alerts':
      // case 'disk.temperature_history':
      // case 'pool.disks':
      // case 'pool.topology':
      // case 'disk.smart_data':
      // case 'disk.run_smart_test':

      default:
        throw Exception('Method not found: $method');
    }
  }

  Future<Map<String, dynamic>> _getSystemInfo(
    Map<String, dynamic> params,
  ) async {
    final info = await _trueNasClient.getSystemInfo();
    return info.toJson();
  }

  Future<List<Map<String, dynamic>>> _getAlerts(
    Map<String, dynamic> params,
  ) async {
    final alerts = await _trueNasClient.getAlerts();
    return alerts.map((a) => a.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> _listPools(
    Map<String, dynamic> params,
  ) async {
    final pools = await _trueNasClient.listPools();
    return pools.map((p) => p.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getPool(Map<String, dynamic> params) async {
    final id = params['id'] as String;
    final pool = await _trueNasClient.getPool(id);
    return pool.toJson();
  }

  Future<List<Map<String, dynamic>>> _listDatasets(
    Map<String, dynamic> params,
  ) async {
    final poolId = params['poolId'] as String?;
    final datasets = await _trueNasClient.listDatasets(poolId: poolId);
    return datasets.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDataset(Map<String, dynamic> params) async {
    final id = params['id'] as String;
    final dataset = await _trueNasClient.getDataset(id);
    return dataset.toJson();
  }

  Future<Map<String, dynamic>> _createDataset(
    Map<String, dynamic> params,
  ) async {
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

  Future<List<Map<String, dynamic>>> _listShares(
    Map<String, dynamic> params,
  ) async {
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

  Future<List<Map<String, dynamic>>> _listDisks(
    Map<String, dynamic> params,
  ) async {
    // Note: includePools parameter is ignored in the simplified client
    final disks = await _trueNasClient.listDisks();
    return disks.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDisk(Map<String, dynamic> params) async {
    final identifier = params['identifier'] as String;
    final disk = await _trueNasClient.getDisk(identifier);
    return disk.toJson();
  }

  // Note: The following methods are not yet implemented in the simplified client:
  // - getDiskTemperatures
  // - getDiskTemperatureAlerts
  // - getDiskTemperatureHistory
  // - getPoolDisks
  // - getPoolTopology
  // - getDiskSmartData
  // - runSmartTest
  // These would need to be added to the TrueNAS client interfaces if needed
}
