import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';
import 'package:mynas_shared/mynas_shared.dart';

class RpcHandler {
  final _logger = Logger('RpcHandler');
  final ITrueNasApiClient _trueNasClient;

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
    if (exception is TrueNasAuthenticationException) {
      return _errorResponse(
        requestId,
        401,
        'Authentication required',
        exception.message,
      );
    } else if (exception is TrueNasAuthorizationException) {
      return _errorResponse(
        requestId,
        403,
        'Insufficient permissions',
        exception.message,
      );
    } else if (exception is TrueNasNotFoundException) {
      return _errorResponse(
        requestId,
        404,
        'Resource not found',
        '${exception.resourceType} with id ${exception.resourceId} not found',
      );
    } else if (exception is TrueNasValidationException) {
      return _errorResponse(
        requestId,
        -32602,
        'Invalid params',
        jsonEncode(exception.validationErrors),
      );
    } else if (exception is TrueNasRateLimitException) {
      return _errorResponse(
        requestId,
        429,
        'Rate limit exceeded',
        'Retry after ${exception.retryAfter.inSeconds} seconds',
      );
    } else if (exception is TrueNasConnectionException) {
      return _errorResponse(
        requestId,
        -32603,
        'Connection error',
        exception.message,
      );
    } else if (exception is TrueNasNetworkException) {
      return _errorResponse(
        requestId,
        -32603,
        'Network error',
        exception.message,
      );
    } else if (exception is TrueNasTimeoutException) {
      return _errorResponse(
        requestId,
        -32603,
        'Request timeout',
        'Operation timed out after ${exception.timeout.inSeconds} seconds',
      );
    } else if (exception is TrueNasVersionException) {
      return _errorResponse(
        requestId,
        -32603,
        'Version incompatible',
        'Required: ${exception.requiredVersion}, Found: ${exception.actualVersion}',
      );
    } else if (exception is TrueNasServerException) {
      final code = exception.statusCode ?? -32603;
      return _errorResponse(requestId, code, 'Server error', exception.message);
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
      case 'disk.temperatures':
        return await _getDiskTemperatures(params);
      case 'disk.temperature_alerts':
        return await _getDiskTemperatureAlerts(params);
      case 'disk.temperature_history':
        return await _getDiskTemperatureHistory(params);
      case 'pool.disks':
        return await _getPoolDisks(params);
      case 'pool.topology':
        return await _getPoolTopology(params);
      case 'disk.smart_data':
        return await _getDiskSmartData(params);
      case 'disk.run_smart_test':
        return await _runSmartTest(params);

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
    final includePools = params['includePools'] as bool? ?? true;
    final disks = await _trueNasClient.listDisks(includePools: includePools);
    return disks.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDisk(Map<String, dynamic> params) async {
    final identifier = params['identifier'] as String;
    final disk = await _trueNasClient.getDisk(identifier);
    return disk.toJson();
  }

  Future<List<Map<String, dynamic>>> _getDiskTemperatures(
    Map<String, dynamic> params,
  ) async {
    final diskNames = (params['diskNames'] as List).cast<String>();
    final temperatures = await _trueNasClient.getDiskTemperatures(diskNames);
    return temperatures.map((t) => t.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDiskTemperatureAlerts(
    Map<String, dynamic> params,
  ) async {
    final diskNames = (params['diskNames'] as List).cast<String>();
    return await _trueNasClient.getDiskTemperatureAlerts(diskNames);
  }

  Future<Map<String, dynamic>> _getDiskTemperatureHistory(
    Map<String, dynamic> params,
  ) async {
    final diskNames = (params['diskNames'] as List).cast<String>();
    final days = params['days'] as int;
    return await _trueNasClient.getDiskTemperatureHistory(
      diskNames: diskNames,
      days: days,
    );
  }

  Future<List<Map<String, dynamic>>> _getPoolDisks(
    Map<String, dynamic> params,
  ) async {
    final poolId = params['poolId'] as String;
    final disks = await _trueNasClient.getPoolDisks(poolId);
    return disks.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getPoolTopology(
    Map<String, dynamic> params,
  ) async {
    final poolId = params['poolId'] as String;
    final topology = await _trueNasClient.getPoolTopology(poolId);
    return topology.toJson();
  }

  Future<Map<String, dynamic>> _getDiskSmartData(
    Map<String, dynamic> params,
  ) async {
    final diskName = params['diskName'] as String;
    return await _trueNasClient.getDiskSmartData(diskName);
  }

  Future<bool> _runSmartTest(Map<String, dynamic> params) async {
    final diskName = params['diskName'] as String;
    final testType = params['testType'] as String;
    return await _trueNasClient.runSmartTest(
      diskName: diskName,
      testType: testType,
    );
  }
}
