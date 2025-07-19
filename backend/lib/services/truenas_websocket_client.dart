import 'dart:async';
import 'package:logging/logging.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../interfaces/truenas_api_client.dart';
import '../interfaces/connection_manager.dart';
import '../interfaces/auth_manager.dart';
import '../interfaces/version_manager.dart';
import '../interfaces/event_manager.dart';
import '../interfaces/json_rpc_client.dart';
import '../interfaces/rate_limiter.dart';
import '../exceptions/truenas_exceptions.dart';
import '../utils/error_handler.dart';
import '../utils/retry_handler.dart';

/// Main TrueNAS WebSocket API client with dependency injection
class TrueNasWebSocketClient implements ITrueNasApiClient {
  final _logger = Logger('TrueNasWebSocketClient');
  final IConnectionManager _connectionManager;
  final IAuthManager _authManager;
  final IVersionManager _versionManager;
  final IEventManager _eventManager;
  final IJsonRpcClient _jsonRpcClient;
  final IRateLimiter _rateLimiter;

  TrueNasWebSocketClient({
    required IConnectionManager connectionManager,
    required IAuthManager authManager,
    required IVersionManager versionManager,
    required IEventManager eventManager,
    required IJsonRpcClient jsonRpcClient,
    required IRateLimiter rateLimiter,
  }) : _connectionManager = connectionManager,
       _authManager = authManager,
       _versionManager = versionManager,
       _eventManager = eventManager,
       _jsonRpcClient = jsonRpcClient,
       _rateLimiter = rateLimiter;

  @override
  IAuthManager get auth => _authManager;

  @override
  IVersionManager get version => _versionManager;

  @override
  IEventManager get events => _eventManager;

  @override
  bool get isReady => _connectionManager.isConnected && 
                     _authManager.isAuthenticated && 
                     _jsonRpcClient.isReady;

  @override
  Future<void> connect(String uri) async {
    return TrueNasErrorHandler.handleOperation(
      () async {
        // Connect WebSocket with retry
        await RetryHandler.execute(
          () => _connectionManager.connect(uri),
          config: RetryConfig.critical,
          operationName: 'connect_websocket',
        );
        
        // Detect version with retry
        await RetryHandler.execute(
          () => _versionManager.detectVersion(),
          config: RetryConfig.apiCalls,
          operationName: 'detect_version',
        );
        
        // Check compatibility
        if (!_versionManager.isVersionCompatible()) {
          throw TrueNasVersionException(
            'TrueNAS version ${_versionManager.currentVersion} is not compatible',
            requiredVersion: '25.04.0', // Minimum supported version
            actualVersion: _versionManager.currentVersion?.toString() ?? 'unknown',
            code: 'VERSION_INCOMPATIBLE',
          );
        }
        
        _logger.info('Successfully connected to TrueNAS ${_versionManager.currentVersion}');
      },
      operationName: 'connect_to_truenas',
      timeout: const Duration(seconds: 30),
    );
  }

  @override
  Future<void> disconnect() async {
    return TrueNasErrorHandler.handleOperation(
      () async {
        // Graceful logout (don't fail if already logged out)
        try {
          await _authManager.logout();
        } catch (e) {
          _logger.warning('Logout failed (continuing): $e');
        }
        
        // Unsubscribe from events (don't fail if not subscribed)
        try {
          await _eventManager.unsubscribe();
        } catch (e) {
          _logger.warning('Event unsubscribe failed (continuing): $e');
        }
        
        // Disconnect WebSocket
        await _connectionManager.disconnect();
        
        _logger.info('Successfully disconnected from TrueNAS');
      },
      operationName: 'disconnect_from_truenas',
      timeout: const Duration(seconds: 10),
    );
  }

  @override
  Future<void> dispose() async {
    _logger.info('Disposing TrueNAS client');
    
    await disconnect();
    await _connectionManager.dispose();
  }

  // Helper method for making rate-limited API calls with comprehensive error handling
  Future<T> _call<T>(String method, [Map<String, dynamic>? params]) async {
    return TrueNasErrorHandler.handleOperation(
      () async {
        // Validate authentication state
        if (!_authManager.isAuthenticated) {
          throw TrueNasAuthenticationException(
            'Authentication required for method: $method',
            code: 'NOT_AUTHENTICATED',
          );
        }

        // Validate connection state
        if (!_connectionManager.isConnected) {
          throw TrueNasConnectionException(
            'WebSocket connection required for method: $method',
            code: 'NOT_CONNECTED',
          );
        }

        // Apply rate limiting
        await _rateLimiter.waitForPermission();
        _rateLimiter.recordRequest();
        
        return await RetryHandler.execute(
          () => _jsonRpcClient.call<T>(method, params),
          config: RetryConfig.apiCalls,
          operationName: method,
          shouldRetry: (exception) {
            // Record rate limit violations
            if (exception is TrueNasRateLimitException) {
              _rateLimiter.recordViolation();
              return true;
            }
            // Use default retry logic for other exceptions
            return false;
          },
        );
      },
      operationName: 'api_call_$method',
      context: {'method': method, 'params': params},
      timeout: const Duration(seconds: 30),
    );
  }

  // System Information
  @override
  Future<SystemInfo> getSystemInfo() async {
    final result = await _call<Map<String, dynamic>>('system.info');
    
    // Get additional system data
    final uptime = await getUptime();
    final alerts = await getAlerts();
    
    return SystemInfo(
      hostname: result['hostname'] ?? 'unknown',
      version: result['version'] ?? _versionManager.currentVersion?.fullVersion ?? 'unknown',
      uptime: uptime,
      cpuUsage: (result['cpu_usage'] as num?)?.toDouble() ?? 0.0,
      memory: MemoryInfo(
        total: (result['physmem'] as num?)?.toInt() ?? 0,
        used: (result['memused'] as num?)?.toInt() ?? 0,
        free: (result['memfree'] as num?)?.toInt() ?? 0,
        cached: (result['memcached'] as num?)?.toInt() ?? 0,
      ),
      cpuTemperature: (result['temperature'] as num?)?.toDouble() ?? 0.0,
      alerts: alerts,
    );
  }

  @override
  Future<List<Alert>> getAlerts() async {
    final result = await _call<List<dynamic>>('alert.list');
    
    return result.map((alertData) {
      final alert = alertData as Map<String, dynamic>;
      return Alert(
        id: alert['id']?.toString() ?? '',
        level: _parseAlertLevel(alert['level']?.toString() ?? 'info'),
        message: alert['formatted'] ?? alert['text'] ?? alert['message'] ?? '',
        timestamp: DateTime.tryParse(alert['datetime'] ?? '') ?? DateTime.now(),
        dismissed: alert['dismissed'] ?? false,
      );
    }).toList();
  }

  AlertLevel _parseAlertLevel(String level) {
    switch (level.toLowerCase()) {
      case 'info':
        return AlertLevel.info;
      case 'warning':
        return AlertLevel.warning;
      case 'error':
        return AlertLevel.error;
      case 'critical':
        return AlertLevel.critical;
      default:
        return AlertLevel.info;
    }
  }

  @override
  Future<String> getUptime() async {
    try {
      final result = await _call<dynamic>('system.uptime');
      return result?.toString() ?? 'unknown';
    } catch (e) {
      _logger.warning('Failed to get uptime: $e');
      return 'unknown';
    }
  }

  // Pool Management
  @override
  Future<List<Pool>> listPools() async {
    final result = await _call<List<dynamic>>('pool.query');
    
    return result.map((poolData) {
      final pool = poolData as Map<String, dynamic>;
      return Pool(
        id: pool['id']?.toString() ?? '',
        name: pool['name'] ?? '',
        status: pool['status'] ?? 'unknown',
        size: (pool['size'] as num?)?.toInt() ?? 0,
        allocated: (pool['allocated'] as num?)?.toInt() ?? 0,
        free: (pool['free'] as num?)?.toInt() ?? 0,
        fragmentation: (pool['fragmentation'] as num?)?.toDouble() ?? 0.0,
        isHealthy: pool['healthy'] ?? false,
        path: pool['path'],
        vdevs: _parseVdevs(pool['topology']),
      );
    }).toList();
  }

  List<PoolVdev> _parseVdevs(dynamic topology) {
    if (topology == null) return [];
    
    final vdevs = <PoolVdev>[];
    final topologyMap = topology as Map<String, dynamic>;
    
    for (final type in ['data', 'cache', 'log', 'spare']) {
      final vdevList = topologyMap[type] as List?;
      if (vdevList != null) {
        for (final vdev in vdevList) {
          final vdevMap = vdev as Map<String, dynamic>;
          vdevs.add(PoolVdev(
            type: vdevMap['type']?.toString() ?? type,
            status: vdevMap['status']?.toString() ?? 'ONLINE',
            disks: (vdevMap['children'] as List?)
                ?.map((child) => (child as Map<String, dynamic>)['disk']?.toString() ?? '')
                .where((disk) => disk.isNotEmpty)
                .toList() ?? [],
          ));
        }
      }
    }
    return vdevs;
  }

  @override
  Future<Pool> getPool(String id) async {
    final result = await _call<Map<String, dynamic>>('pool.get_instance', {'id': id});
    
    return Pool(
      id: result['id']?.toString() ?? '',
      name: result['name'] ?? '',
      status: result['status'] ?? 'unknown',
      size: (result['size'] as num?)?.toInt() ?? 0,
      allocated: (result['allocated'] as num?)?.toInt() ?? 0,
      free: (result['free'] as num?)?.toInt() ?? 0,
      fragmentation: (result['fragmentation'] as num?)?.toDouble() ?? 0.0,
      isHealthy: result['healthy'] ?? false,
      path: result['path'],
      vdevs: _parseVdevs(result['topology']),
    );
  }

  @override
  Future<Pool> importPool(String poolName, {Map<String, dynamic>? options}) async {
    final params = {'name': poolName, ...?options};
    final result = await _call<Map<String, dynamic>>('pool.import_pool', params);
    return getPool(result['id']?.toString() ?? '');
  }

  @override
  Future<bool> exportPool(String poolId, {bool destroy = false}) async {
    await _call('pool.export', {
      'id': poolId,
      'destroy': destroy,
    });
    return true;
  }

  // Dataset Management
  @override
  Future<List<Dataset>> listDatasets({String? poolId}) async {
    final result = await _call<List<dynamic>>('pool.dataset.query');
    
    return result
        .where((datasetData) {
          if (poolId == null) return true;
          final dataset = datasetData as Map<String, dynamic>;
          return dataset['pool']?.toString() == poolId;
        })
        .map((datasetData) {
          final dataset = datasetData as Map<String, dynamic>;
          return Dataset(
            id: dataset['id'] ?? '',
            name: dataset['name'] ?? '',
            pool: dataset['pool'] ?? '',
            type: dataset['type'] ?? 'FILESYSTEM',
            used: (dataset['used']?['parsed'] as num?)?.toInt() ?? 0,
            available: (dataset['available']?['parsed'] as num?)?.toInt() ?? 0,
            referenced: (dataset['referenced']?['parsed'] as num?)?.toInt() ?? 0,
            mountpoint: dataset['mountpoint'] ?? '',
            encrypted: dataset['encrypted'] ?? false,
            children: (dataset['children'] as List?)
                ?.map((c) => (c as Map<String, dynamic>)['name']?.toString() ?? '')
                .where((name) => name.isNotEmpty)
                .toList() ?? [],
            properties: dataset['properties'] as Map<String, dynamic>? ?? {},
          );
        }).toList();
  }

  @override
  Future<Dataset> getDataset(String id) async {
    final result = await _call<Map<String, dynamic>>('pool.dataset.get_instance', {'id': id});
    
    return Dataset(
      id: result['id'] ?? '',
      name: result['name'] ?? '',
      pool: result['pool'] ?? '',
      type: result['type'] ?? 'FILESYSTEM',
      used: (result['used']?['parsed'] as num?)?.toInt() ?? 0,
      available: (result['available']?['parsed'] as num?)?.toInt() ?? 0,
      referenced: (result['referenced']?['parsed'] as num?)?.toInt() ?? 0,
      mountpoint: result['mountpoint'] ?? '',
      encrypted: result['encrypted'] ?? false,
      children: (result['children'] as List?)
          ?.map((c) => (c as Map<String, dynamic>)['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList() ?? [],
      properties: result['properties'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  Future<Dataset> createDataset({
    required String pool,
    required String name,
    String? type,
    Map<String, dynamic>? properties,
  }) async {
    final params = {
      'name': '$pool/$name',
      'type': type ?? 'FILESYSTEM',
      ...?properties,
    };
    
    final result = await _call<Map<String, dynamic>>('pool.dataset.create', params);
    return getDataset(result['id']?.toString() ?? '');
  }

  @override
  Future<Dataset> updateDataset(String id, Map<String, dynamic> properties) async {
    await _call('pool.dataset.update', {'id': id, ...properties});
    return getDataset(id);
  }

  @override
  Future<bool> deleteDataset(String id, {bool recursive = false}) async {
    await _call('pool.dataset.delete', {
      'id': id,
      'recursive': recursive,
    });
    return true;
  }

  // Share Management
  @override
  Future<List<Share>> listShares({ShareType? type}) async {
    final shares = <Share>[];
    
    if (type == null || type == ShareType.smb) {
      final smbShares = await _call<List<dynamic>>('sharing.smb.query');
      shares.addAll(smbShares.map((share) => _parseSmbShare(share as Map<String, dynamic>)));
    }
    
    if (type == null || type == ShareType.nfs) {
      final nfsShares = await _call<List<dynamic>>('sharing.nfs.query');
      shares.addAll(nfsShares.map((share) => _parseNfsShare(share as Map<String, dynamic>)));
    }
    
    return shares;
  }

  Share _parseSmbShare(Map<String, dynamic> data) {
    return Share(
      id: data['id']?.toString() ?? '',
      name: data['name'] ?? '',
      path: data['path'] ?? '',
      type: ShareType.smb,
      enabled: data['enabled'] ?? false,
      comment: data['comment'],
      config: data,
    );
  }

  Share _parseNfsShare(Map<String, dynamic> data) {
    return Share(
      id: data['id']?.toString() ?? '',
      name: data['comment'] ?? 'NFS Share ${data['id']}',
      path: data['path'] ?? '',
      type: ShareType.nfs,
      enabled: data['enabled'] ?? false,
      comment: data['comment'],
      config: data,
    );
  }

  @override
  Future<Share> getShare(String id) async {
    // Try SMB first, then NFS
    try {
      final result = await _call<Map<String, dynamic>>('sharing.smb.get_instance', {'id': id});
      return _parseSmbShare(result);
    } catch (e) {
      final result = await _call<Map<String, dynamic>>('sharing.nfs.get_instance', {'id': id});
      return _parseNfsShare(result);
    }
  }

  @override
  Future<Share> createShare(Share shareData) async {
    Map<String, dynamic> result;
    
    switch (shareData.type) {
      case ShareType.smb:
        result = await _call<Map<String, dynamic>>('sharing.smb.create', {
          'name': shareData.name,
          'path': shareData.path,
          'enabled': shareData.enabled,
          'comment': shareData.comment,
          ...?shareData.config,
        });
        break;
      case ShareType.nfs:
        result = await _call<Map<String, dynamic>>('sharing.nfs.create', {
          'path': shareData.path,
          'enabled': shareData.enabled,
          'comment': shareData.comment ?? shareData.name,
          ...?shareData.config,
        });
        break;
      default:
        throw UnsupportedError('Share type ${shareData.type} not supported');
    }
    
    return getShare(result['id']?.toString() ?? '');
  }

  @override
  Future<Share> updateShare(Share shareData) async {
    switch (shareData.type) {
      case ShareType.smb:
        await _call('sharing.smb.update', {
          'id': shareData.id,
          'name': shareData.name,
          'path': shareData.path,
          'enabled': shareData.enabled,
          'comment': shareData.comment,
          ...?shareData.config,
        });
        break;
      case ShareType.nfs:
        await _call('sharing.nfs.update', {
          'id': shareData.id,
          'path': shareData.path,
          'enabled': shareData.enabled,
          'comment': shareData.comment,
          ...?shareData.config,
        });
        break;
      default:
        throw UnsupportedError('Share type ${shareData.type} not supported');
    }
    
    return getShare(shareData.id);
  }

  @override
  Future<bool> deleteShare(String id) async {
    // Try both SMB and NFS deletion
    try {
      await _call('sharing.smb.delete', {'id': id});
      return true;
    } catch (e) {
      await _call('sharing.nfs.delete', {'id': id});
      return true;
    }
  }

  // Stub implementations for remaining methods (to be expanded as needed)
  @override
  Future<List<Map<String, dynamic>>> listUsers() async {
    return await _call<List<dynamic>>('user.query').then((result) => 
        result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getUser(String username) async {
    return await _call<Map<String, dynamic>>('user.get_instance', {'username': username});
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    return await _call<Map<String, dynamic>>('user.create', userData);
  }

  @override
  Future<Map<String, dynamic>> updateUser(String username, Map<String, dynamic> userData) async {
    return await _call<Map<String, dynamic>>('user.update', {'username': username, ...userData});
  }

  @override
  Future<bool> deleteUser(String username) async {
    await _call('user.delete', {'username': username});
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> listGroups() async {
    return await _call<List<dynamic>>('group.query').then((result) => 
        result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getGroup(String groupname) async {
    return await _call<Map<String, dynamic>>('group.get_instance', {'groupname': groupname});
  }

  @override
  Future<Map<String, dynamic>> createGroup(Map<String, dynamic> groupData) async {
    return await _call<Map<String, dynamic>>('group.create', groupData);
  }

  @override
  Future<Map<String, dynamic>> updateGroup(String groupname, Map<String, dynamic> groupData) async {
    return await _call<Map<String, dynamic>>('group.update', {'groupname': groupname, ...groupData});
  }

  @override
  Future<bool> deleteGroup(String groupname) async {
    await _call('group.delete', {'groupname': groupname});
    return true;
  }

  @override
  Future<Map<String, dynamic>> getNetworkConfig() async {
    return await _call<Map<String, dynamic>>('network.configuration.config');
  }

  @override
  Future<Map<String, dynamic>> updateNetworkConfig(Map<String, dynamic> config) async {
    return await _call<Map<String, dynamic>>('network.configuration.update', config);
  }

  @override
  Future<List<Map<String, dynamic>>> listNetworkInterfaces() async {
    return await _call<List<dynamic>>('interface.query').then((result) => 
        result.cast<Map<String, dynamic>>());
  }

  @override
  Future<List<Map<String, dynamic>>> listServices() async {
    return await _call<List<dynamic>>('service.query').then((result) => 
        result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getService(String serviceName) async {
    return await _call<Map<String, dynamic>>('service.get_instance', {'service': serviceName});
  }

  @override
  Future<bool> startService(String serviceName) async {
    await _call('service.start', {'service': serviceName});
    return true;
  }

  @override
  Future<bool> stopService(String serviceName) async {
    await _call('service.stop', {'service': serviceName});
    return true;
  }

  @override
  Future<bool> restartService(String serviceName) async {
    await _call('service.restart', {'service': serviceName});
    return true;
  }

  @override
  Future<Map<String, dynamic>> updateService(String serviceName, Map<String, dynamic> config) async {
    return await _call<Map<String, dynamic>>('service.update', {'service': serviceName, ...config});
  }

  @override
  Future<List<Map<String, dynamic>>> listVMs() async {
    return await _call<List<dynamic>>('vm.query').then((result) => 
        result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getVM(String vmId) async {
    return await _call<Map<String, dynamic>>('vm.get_instance', {'id': vmId});
  }

  @override
  Future<bool> startVM(String vmId) async {
    await _call('vm.start', {'id': vmId});
    return true;
  }

  @override
  Future<bool> stopVM(String vmId) async {
    await _call('vm.stop', {'id': vmId});
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> listApps() async {
    return await _call<List<dynamic>>('app.query').then((result) => 
        result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getApp(String appId) async {
    return await _call<Map<String, dynamic>>('app.get_instance', {'id': appId});
  }

  @override
  Future<Map<String, dynamic>> installApp(String appName, Map<String, dynamic> config) async {
    return await _call<Map<String, dynamic>>('app.create', {'name': appName, ...config});
  }

  @override
  Future<Map<String, dynamic>> updateApp(String appId, Map<String, dynamic> config) async {
    return await _call<Map<String, dynamic>>('app.update', {'id': appId, ...config});
  }

  @override
  Future<bool> deleteApp(String appId) async {
    await _call('app.delete', {'id': appId});
    return true;
  }

  @override
  Future<bool> reboot({int delay = 0}) async {
    await _call('system.reboot', {'delay': delay});
    return true;
  }

  @override
  Future<bool> shutdown({int delay = 0}) async {
    await _call('system.shutdown', {'delay': delay});
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> getSystemLogs({
    int? limit,
    String? level,
    DateTime? since,
  }) async {
    final params = <String, dynamic>{};
    if (limit != null) params['limit'] = limit;
    if (level != null) params['level'] = level;
    if (since != null) params['since'] = since.toIso8601String();
    
    return await _call<List<dynamic>>('system.logs', params).then((result) => 
        result.cast<Map<String, dynamic>>());
  }
}