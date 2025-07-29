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
  bool get isReady =>
      _connectionManager.isConnected &&
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
            actualVersion:
                _versionManager.currentVersion?.toString() ?? 'unknown',
            code: 'VERSION_INCOMPATIBLE',
          );
        }

        _logger.info(
          'Successfully connected to TrueNAS ${_versionManager.currentVersion}',
        );
      },
      operationName: 'connect_to_truenas',
      timeout: const Duration(seconds: 30),
    );
  }

  @override
  Future<void> disconnect() async {
    return TrueNasErrorHandler.handleOperation(
      () async {
        // No logout needed for API key authentication

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
      hostname: (result['hostname'] as String?) ?? 'unknown',
      version:
          (result['version'] as String?) ??
          _versionManager.currentVersion?.fullVersion ??
          'unknown',
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
        message:
            (alert['formatted'] as String?) ??
            (alert['text'] as String?) ??
            (alert['message'] as String?) ??
            '',
        timestamp:
            DateTime.tryParse((alert['datetime'] as String?) ?? '') ??
            DateTime.now(),
        dismissed: (alert['dismissed'] as bool?) ?? false,
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
    final result = await _call<List<dynamic>>('pool.query', {
      'filters': <dynamic>[],
      'options': {
        'extra': {'is_upgraded': true},
      },
    });

    return result.map((poolData) {
      final pool = poolData as Map<String, dynamic>;
      return Pool(
        id: pool['id']?.toString() ?? '',
        name: (pool['name'] as String?) ?? '',
        status: (pool['status'] as String?) ?? 'unknown',
        size: (pool['size'] as num?)?.toInt() ?? 0,
        allocated: (pool['allocated'] as num?)?.toInt() ?? 0,
        free: (pool['free'] as num?)?.toInt() ?? 0,
        fragmentation: (pool['fragmentation'] as num?)?.toDouble() ?? 0.0,
        isHealthy: (pool['healthy'] as bool?) ?? false,
        path: pool['path'] as String?,
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
          vdevs.add(
            PoolVdev(
              type: vdevMap['type']?.toString() ?? type,
              status: vdevMap['status']?.toString() ?? 'ONLINE',
              disks:
                  (vdevMap['children'] as List?)
                      ?.map(
                        (child) =>
                            (child as Map<String, dynamic>)['disk']
                                ?.toString() ??
                            '',
                      )
                      .where((disk) => disk.isNotEmpty)
                      .toList() ??
                  [],
            ),
          );
        }
      }
    }
    return vdevs;
  }

  @override
  Future<Pool> getPool(String id) async {
    final result = await _call<Map<String, dynamic>>('pool.get_instance', {
      'id': id,
    });

    return Pool(
      id: result['id']?.toString() ?? '',
      name: (result['name'] as String?) ?? '',
      status: (result['status'] as String?) ?? 'unknown',
      size: (result['size'] as num?)?.toInt() ?? 0,
      allocated: (result['allocated'] as num?)?.toInt() ?? 0,
      free: (result['free'] as num?)?.toInt() ?? 0,
      fragmentation: (result['fragmentation'] as num?)?.toDouble() ?? 0.0,
      isHealthy: (result['healthy'] as bool?) ?? false,
      path: result['path'] as String?,
      vdevs: _parseVdevs(result['topology']),
    );
  }

  @override
  Future<Pool> importPool(
    String poolName, {
    Map<String, dynamic>? options,
  }) async {
    final params = {'name': poolName, ...?options};
    final result = await _call<Map<String, dynamic>>(
      'pool.import_pool',
      params,
    );
    return getPool(result['id']?.toString() ?? '');
  }

  @override
  Future<bool> exportPool(String poolId, {bool destroy = false}) async {
    await _call<dynamic>('pool.export', {'id': poolId, 'destroy': destroy});
    return true;
  }

  // Pool Health & Monitoring
  @override
  Future<Map<String, dynamic>> getPoolStatus(String poolId) async {
    return await _call<Map<String, dynamic>>('pool.get_instance', {
      'id': poolId,
    });
  }

  @override
  Future<Map<String, dynamic>> getPoolUsage(String poolId) async {
    return await _call<Map<String, dynamic>>('pool.filesystem_stat', {
      'id': poolId,
    });
  }

  // Pool Scrub Management
  @override
  Future<List<PoolScrubTask>> listScrubTasks({String? poolId}) async {
    final filters = poolId != null
        ? [
            ['pool', '=', poolId],
          ]
        : <List<dynamic>>[];
    final result = await _call<List<dynamic>>('pool.scrub.query', {
      'filters': filters,
    });

    return result.map((taskData) {
      final task = taskData as Map<String, dynamic>;
      return PoolScrubTask(
        id: task['id']?.toString() ?? '',
        pool: (task['pool'] as String?) ?? '',
        description: (task['description'] as String?) ?? '',
        schedule: (task['schedule'] as String?) ?? '',
        enabled: (task['enabled'] as bool?) ?? true,
        nextRun: task['next_run'] != null
            ? DateTime.tryParse(task['next_run'] as String)
            : null,
        lastRun: task['last_run'] != null
            ? DateTime.tryParse(task['last_run'] as String)
            : null,
        options: task,
      );
    }).toList();
  }

  @override
  Future<PoolScrubTask> getScrubTask(String taskId) async {
    final result = await _call<Map<String, dynamic>>(
      'pool.scrub.get_instance',
      {'id': taskId},
    );

    return PoolScrubTask(
      id: result['id']?.toString() ?? '',
      pool: (result['pool'] as String?) ?? '',
      description: (result['description'] as String?) ?? '',
      schedule: (result['schedule'] as String?) ?? '',
      enabled: (result['enabled'] as bool?) ?? true,
      nextRun: result['next_run'] != null
          ? DateTime.tryParse(result['next_run'] as String)
          : null,
      lastRun: result['last_run'] != null
          ? DateTime.tryParse(result['last_run'] as String)
          : null,
      options: result,
    );
  }

  @override
  Future<PoolScrubTask> createScrubTask({
    required String poolId,
    required String schedule,
    String? description,
    bool enabled = true,
  }) async {
    final result = await _call<Map<String, dynamic>>('pool.scrub.create', {
      'pool': poolId,
      'schedule': schedule,
      'description': description ?? 'Scrub task for pool $poolId',
      'enabled': enabled,
    });

    return getScrubTask(result['id']?.toString() ?? '');
  }

  @override
  Future<PoolScrubTask> updateScrubTask(
    String taskId,
    Map<String, dynamic> updates,
  ) async {
    await _call<dynamic>('pool.scrub.update', {'id': taskId, ...updates});
    return getScrubTask(taskId);
  }

  @override
  Future<bool> deleteScrubTask(String taskId) async {
    await _call<dynamic>('pool.scrub.delete', {'id': taskId});
    return true;
  }

  @override
  Future<PoolScrub> runScrub(String poolId) async {
    final result = await _call<Map<String, dynamic>>('pool.scrub.scrub', {
      'pool': poolId,
    });

    return PoolScrub(
      id: result['id']?.toString() ?? '',
      pool: poolId,
      status: _parseScrubStatus(result['state']?.toString() ?? 'waiting'),
      startTime: result['start_time'] != null
          ? DateTime.tryParse(result['start_time'] as String)
          : null,
      endTime: result['end_time'] != null
          ? DateTime.tryParse(result['end_time'] as String)
          : null,
      duration: result['duration'] as int?,
      bytesProcessed: result['bytes_processed'] as int?,
      bytesPerSecond: result['bytes_per_second'] as int?,
      errorsFound: result['errors'] as int?,
      description: (result['description'] as String?) ?? 'Manual scrub',
    );
  }

  @override
  Future<List<PoolScrub>> getScrubHistory(String poolId, {int? limit}) async {
    final result = await _call<List<dynamic>>('pool.scrub.query', {
      'filters': [
        ['pool', '=', poolId],
      ],
      if (limit != null) 'limit': limit,
      'order_by': ['-start_time'],
    });

    return result.map((scrubData) {
      final scrub = scrubData as Map<String, dynamic>;
      return PoolScrub(
        id: scrub['id']?.toString() ?? '',
        pool: poolId,
        status: _parseScrubStatus(scrub['state']?.toString() ?? 'finished'),
        startTime: scrub['start_time'] != null
            ? DateTime.tryParse(scrub['start_time'] as String)
            : null,
        endTime: scrub['end_time'] != null
            ? DateTime.tryParse(scrub['end_time'] as String)
            : null,
        duration: scrub['duration'] as int?,
        bytesProcessed: scrub['bytes_processed'] as int?,
        bytesPerSecond: scrub['bytes_per_second'] as int?,
        errorsFound: scrub['errors'] as int?,
        description: (scrub['description'] as String?) ?? '',
      );
    }).toList();
  }

  ScrubStatus _parseScrubStatus(String status) {
    switch (status.toLowerCase()) {
      case 'running':
      case 'scanning':
        return ScrubStatus.running;
      case 'finished':
      case 'completed':
        return ScrubStatus.finished;
      case 'canceled':
      case 'cancelled':
        return ScrubStatus.canceled;
      case 'error':
        return ScrubStatus.error;
      default:
        return ScrubStatus.waiting;
    }
  }

  // Pool Resilver Management
  @override
  Future<PoolResilver?> getResilverStatus(String poolId) async {
    try {
      final result = await _call<Map<String, dynamic>>('pool.resilver.query', {
        'filters': [
          ['pool', '=', poolId],
        ],
        'limit': 1,
      });

      if ((result['results'] as List? ?? []).isEmpty) {
        return null;
      }

      final resilverData =
          (result['results'] as List).first as Map<String, dynamic>;
      return PoolResilver(
        pool: poolId,
        status: _parseResilverStatus(
          resilverData['state']?.toString() ?? 'idle',
        ),
        startTime: resilverData['start_time'] != null
            ? DateTime.tryParse(resilverData['start_time'] as String)
            : null,
        estimatedEndTime: resilverData['estimated_end_time'] != null
            ? DateTime.tryParse(resilverData['estimated_end_time'] as String)
            : null,
        bytesProcessed: resilverData['bytes_processed'] as int?,
        totalBytes: resilverData['total_bytes'] as int?,
        percentComplete: (resilverData['percent_complete'] as num?)?.toDouble(),
        bytesPerSecond: resilverData['bytes_per_second'] as int?,
        errorsFound: resilverData['errors'] as int?,
        description: resilverData['description'] as String?,
      );
    } catch (e) {
      return null; // No active resilver
    }
  }

  @override
  Future<bool> updateResilverConfig(
    String poolId,
    Map<String, dynamic> config,
  ) async {
    await _call<dynamic>('pool.resilver.update', {'pool': poolId, ...config});
    return true;
  }

  ResilverStatus _parseResilverStatus(String status) {
    switch (status.toLowerCase()) {
      case 'running':
      case 'resilvering':
        return ResilverStatus.running;
      case 'finished':
      case 'completed':
        return ResilverStatus.finished;
      case 'canceled':
      case 'cancelled':
        return ResilverStatus.canceled;
      case 'error':
        return ResilverStatus.error;
      default:
        return ResilverStatus.idle;
    }
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
            id: (dataset['id'] as String?) ?? '',
            name: (dataset['name'] as String?) ?? '',
            pool: (dataset['pool'] as String?) ?? '',
            type: (dataset['type'] as String?) ?? 'FILESYSTEM',
            used: (dataset['used']?['parsed'] as num?)?.toInt() ?? 0,
            available: (dataset['available']?['parsed'] as num?)?.toInt() ?? 0,
            referenced:
                (dataset['referenced']?['parsed'] as num?)?.toInt() ?? 0,
            mountpoint: (dataset['mountpoint'] as String?) ?? '',
            encrypted: (dataset['encrypted'] as bool?) ?? false,
            children:
                (dataset['children'] as List?)
                    ?.map(
                      (c) =>
                          (c as Map<String, dynamic>)['name']?.toString() ?? '',
                    )
                    .where((name) => name.isNotEmpty)
                    .toList() ??
                [],
            properties: dataset['properties'] as Map<String, dynamic>? ?? {},
          );
        })
        .toList();
  }

  @override
  Future<Dataset> getDataset(String id) async {
    final result = await _call<Map<String, dynamic>>(
      'pool.dataset.get_instance',
      {'id': id},
    );

    return Dataset(
      id: (result['id'] as String?) ?? '',
      name: (result['name'] as String?) ?? '',
      pool: (result['pool'] as String?) ?? '',
      type: (result['type'] as String?) ?? 'FILESYSTEM',
      used: (result['used']?['parsed'] as num?)?.toInt() ?? 0,
      available: (result['available']?['parsed'] as num?)?.toInt() ?? 0,
      referenced: (result['referenced']?['parsed'] as num?)?.toInt() ?? 0,
      mountpoint: (result['mountpoint'] as String?) ?? '',
      encrypted: (result['encrypted'] as bool?) ?? false,
      children:
          (result['children'] as List?)
              ?.map(
                (c) => (c as Map<String, dynamic>)['name']?.toString() ?? '',
              )
              .where((name) => name.isNotEmpty)
              .toList() ??
          [],
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

    final result = await _call<Map<String, dynamic>>(
      'pool.dataset.create',
      params,
    );
    return getDataset(result['id']?.toString() ?? '');
  }

  @override
  Future<Dataset> updateDataset(
    String id,
    Map<String, dynamic> properties,
  ) async {
    await _call<dynamic>('pool.dataset.update', {'id': id, ...properties});
    return getDataset(id);
  }

  @override
  Future<bool> deleteDataset(String id, {bool recursive = false}) async {
    await _call<dynamic>('pool.dataset.delete', {
      'id': id,
      'recursive': recursive,
    });
    return true;
  }

  @override
  Future<Map<String, dynamic>> getDatasetDetails(String id) async {
    return await _call<Map<String, dynamic>>('pool.dataset.details', {
      'id': id,
    });
  }

  // Dataset Snapshot Management
  @override
  Future<SnapshotCount> getDatasetSnapshotCount(String datasetId) async {
    final result = await _call<Map<String, dynamic>>(
      'pool.dataset.snapshot_count',
      {'id': datasetId},
    );

    return SnapshotCount(
      dataset: datasetId,
      totalSnapshots: (result['total'] as int?) ?? 0,
      manualSnapshots: (result['manual'] as int?) ?? 0,
      taskSnapshots: (result['task'] as int?) ?? 0,
      totalSize: (result['total_size'] as int?) ?? 0,
    );
  }

  @override
  Future<List<Snapshot>> listDatasetSnapshots(String datasetId) async {
    final result = await _call<List<dynamic>>('zfs.snapshot.query', {
      'filters': [
        ['dataset', '=', datasetId],
      ],
      'order_by': ['-created'],
    });

    return result.map((snapshotData) {
      final snapshot = snapshotData as Map<String, dynamic>;
      return Snapshot(
        id: (snapshot['id'] as String?) ?? '',
        name: (snapshot['name'] as String?) ?? '',
        dataset: datasetId,
        pool: (snapshot['pool'] as String?) ?? '',
        created:
            DateTime.tryParse((snapshot['created'] as String?) ?? '') ??
            DateTime.now(),
        used: (snapshot['used']?['parsed'] as num?)?.toInt() ?? 0,
        referenced: (snapshot['referenced']?['parsed'] as num?)?.toInt() ?? 0,
        description: snapshot['description'] as String?,
        properties: snapshot['properties'] as Map<String, dynamic>? ?? {},
      );
    }).toList();
  }

  // Snapshot Task Management
  @override
  Future<List<SnapshotTask>> listSnapshotTasks({String? datasetId}) async {
    final filters = datasetId != null
        ? [
            ['dataset', '=', datasetId],
          ]
        : <List<dynamic>>[];
    final result = await _call<List<dynamic>>('pool.snapshottask.query', {
      'filters': filters,
    });

    return result.map((taskData) {
      final task = taskData as Map<String, dynamic>;
      return SnapshotTask(
        id: task['id']?.toString() ?? '',
        dataset: (task['dataset'] as String?) ?? '',
        namingSchema: (task['naming_schema'] as String?) ?? '',
        schedule: (task['schedule'] as String?) ?? '',
        enabled: (task['enabled'] as bool?) ?? true,
        recursive: (task['recursive'] as bool?) ?? false,
        excludeEmpty: (task['exclude_empty'] as bool?) ?? false,
        lifetimeValue: (task['lifetime_value'] as int?) ?? 0,
        lifetimeUnit: (task['lifetime_unit'] as String?) ?? 'WEEK',
        nextRun: task['next_run'] != null
            ? DateTime.tryParse(task['next_run'] as String)
            : null,
        lastRun: task['last_run'] != null
            ? DateTime.tryParse(task['last_run'] as String)
            : null,
        keepCount: (task['keep_count'] as int?) ?? 0,
        options: task,
      );
    }).toList();
  }

  @override
  Future<SnapshotTask> getSnapshotTask(String taskId) async {
    final result = await _call<Map<String, dynamic>>(
      'pool.snapshottask.get_instance',
      {'id': taskId},
    );

    return SnapshotTask(
      id: result['id']?.toString() ?? '',
      dataset: (result['dataset'] as String?) ?? '',
      namingSchema: (result['naming_schema'] as String?) ?? '',
      schedule: (result['schedule'] as String?) ?? '',
      enabled: (result['enabled'] as bool?) ?? true,
      recursive: (result['recursive'] as bool?) ?? false,
      excludeEmpty: (result['exclude_empty'] as bool?) ?? false,
      lifetimeValue: (result['lifetime_value'] as int?) ?? 0,
      lifetimeUnit: (result['lifetime_unit'] as String?) ?? 'WEEK',
      nextRun: result['next_run'] != null
          ? DateTime.tryParse(result['next_run'] as String)
          : null,
      lastRun: result['last_run'] != null
          ? DateTime.tryParse(result['last_run'] as String)
          : null,
      keepCount: (result['keep_count'] as int?) ?? 0,
      options: result,
    );
  }

  @override
  Future<SnapshotTask> createSnapshotTask({
    required String dataset,
    required String schedule,
    required String namingSchema,
    required int lifetimeValue,
    required String lifetimeUnit,
    bool enabled = true,
    bool recursive = false,
    bool excludeEmpty = false,
  }) async {
    final result =
        await _call<Map<String, dynamic>>('pool.snapshottask.create', {
          'dataset': dataset,
          'schedule': schedule,
          'naming_schema': namingSchema,
          'lifetime_value': lifetimeValue,
          'lifetime_unit': lifetimeUnit,
          'enabled': enabled,
          'recursive': recursive,
          'exclude_empty': excludeEmpty,
        });

    return getSnapshotTask(result['id']?.toString() ?? '');
  }

  @override
  Future<SnapshotTask> updateSnapshotTask(
    String taskId,
    Map<String, dynamic> updates,
  ) async {
    await _call<dynamic>('pool.snapshottask.update', {
      'id': taskId,
      ...updates,
    });
    return getSnapshotTask(taskId);
  }

  @override
  Future<bool> deleteSnapshotTask(String taskId) async {
    await _call<dynamic>('pool.snapshottask.delete', {'id': taskId});
    return true;
  }

  @override
  Future<Snapshot> runSnapshotTask(String taskId) async {
    final result = await _call<Map<String, dynamic>>('pool.snapshottask.run', {
      'id': taskId,
    });

    // Get the created snapshot details
    final snapshotId =
        (result['snapshot_id'] as String?) ?? (result['id'] as String?);
    final snapshotResult = await _call<Map<String, dynamic>>(
      'zfs.snapshot.get_instance',
      {'id': snapshotId},
    );

    return Snapshot(
      id: (snapshotResult['id'] as String?) ?? '',
      name: (snapshotResult['name'] as String?) ?? '',
      dataset: (snapshotResult['dataset'] as String?) ?? '',
      pool: (snapshotResult['pool'] as String?) ?? '',
      created:
          DateTime.tryParse((snapshotResult['created'] as String?) ?? '') ??
          DateTime.now(),
      used: (snapshotResult['used']?['parsed'] as num?)?.toInt() ?? 0,
      referenced:
          (snapshotResult['referenced']?['parsed'] as num?)?.toInt() ?? 0,
      description: snapshotResult['description'] as String?,
      properties: snapshotResult['properties'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  Future<Snapshot> createSnapshot({
    required String dataset,
    required String name,
    bool recursive = false,
  }) async {
    final result = await _call<Map<String, dynamic>>('zfs.snapshot.create', {
      'dataset': dataset,
      'name': name,
      'recursive': recursive,
    });

    return Snapshot(
      id: (result['id'] as String?) ?? '',
      name: name,
      dataset: dataset,
      pool: (result['pool'] as String?) ?? '',
      created: DateTime.now(),
      used: 0,
      referenced: 0,
      description: 'Manual snapshot',
      properties: {},
    );
  }

  @override
  Future<bool> deleteSnapshots(
    String dataset,
    List<String> snapshotNames,
  ) async {
    await _call<dynamic>('pool.dataset.destroy_snapshots', {
      'dataset': dataset,
      'snapshots': snapshotNames,
    });
    return true;
  }

  // Share Management
  @override
  Future<List<Share>> listShares({ShareType? type}) async {
    final shares = <Share>[];

    if (type == null || type == ShareType.smb) {
      final smbShares = await _call<List<dynamic>>('sharing.smb.query');
      shares.addAll(
        smbShares.map((share) => _parseSmbShare(share as Map<String, dynamic>)),
      );
    }

    if (type == null || type == ShareType.nfs) {
      final nfsShares = await _call<List<dynamic>>('sharing.nfs.query');
      shares.addAll(
        nfsShares.map((share) => _parseNfsShare(share as Map<String, dynamic>)),
      );
    }

    return shares;
  }

  Share _parseSmbShare(Map<String, dynamic> data) {
    return Share(
      id: data['id']?.toString() ?? '',
      name: (data['name'] as String?) ?? '',
      path: (data['path'] as String?) ?? '',
      type: ShareType.smb,
      enabled: (data['enabled'] as bool?) ?? false,
      comment: data['comment'] as String?,
      config: data,
    );
  }

  Share _parseNfsShare(Map<String, dynamic> data) {
    return Share(
      id: data['id']?.toString() ?? '',
      name: (data['comment'] as String?) ?? 'NFS Share ${data['id']}',
      path: (data['path'] as String?) ?? '',
      type: ShareType.nfs,
      enabled: (data['enabled'] as bool?) ?? false,
      comment: data['comment'] as String?,
      config: data,
    );
  }

  @override
  Future<Share> getShare(String id) async {
    // Try SMB first, then NFS
    try {
      final result = await _call<Map<String, dynamic>>(
        'sharing.smb.get_instance',
        {'id': id},
      );
      return _parseSmbShare(result);
    } catch (e) {
      final result = await _call<Map<String, dynamic>>(
        'sharing.nfs.get_instance',
        {'id': id},
      );
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
        await _call<dynamic>('sharing.smb.update', {
          'id': shareData.id,
          'name': shareData.name,
          'path': shareData.path,
          'enabled': shareData.enabled,
          'comment': shareData.comment,
          ...?shareData.config,
        });
        break;
      case ShareType.nfs:
        await _call<dynamic>('sharing.nfs.update', {
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
      await _call<dynamic>('sharing.smb.delete', {'id': id});
      return true;
    } catch (e) {
      await _call<dynamic>('sharing.nfs.delete', {'id': id});
      return true;
    }
  }

  // Stub implementations for remaining methods (to be expanded as needed)
  @override
  Future<List<Map<String, dynamic>>> listUsers() async {
    return await _call<List<dynamic>>(
      'user.query',
    ).then((result) => result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getUser(String username) async {
    return await _call<Map<String, dynamic>>('user.get_instance', {
      'username': username,
    });
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    return await _call<Map<String, dynamic>>('user.create', userData);
  }

  @override
  Future<Map<String, dynamic>> updateUser(
    String username,
    Map<String, dynamic> userData,
  ) async {
    return await _call<Map<String, dynamic>>('user.update', {
      'username': username,
      ...userData,
    });
  }

  @override
  Future<bool> deleteUser(String username) async {
    await _call<dynamic>('user.delete', {'username': username});
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> listGroups() async {
    return await _call<List<dynamic>>(
      'group.query',
    ).then((result) => result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getGroup(String groupname) async {
    return await _call<Map<String, dynamic>>('group.get_instance', {
      'groupname': groupname,
    });
  }

  @override
  Future<Map<String, dynamic>> createGroup(
    Map<String, dynamic> groupData,
  ) async {
    return await _call<Map<String, dynamic>>('group.create', groupData);
  }

  @override
  Future<Map<String, dynamic>> updateGroup(
    String groupname,
    Map<String, dynamic> groupData,
  ) async {
    return await _call<Map<String, dynamic>>('group.update', {
      'groupname': groupname,
      ...groupData,
    });
  }

  @override
  Future<bool> deleteGroup(String groupname) async {
    await _call<dynamic>('group.delete', {'groupname': groupname});
    return true;
  }

  @override
  Future<Map<String, dynamic>> getNetworkConfig() async {
    return await _call<Map<String, dynamic>>('network.configuration.config');
  }

  @override
  Future<Map<String, dynamic>> updateNetworkConfig(
    Map<String, dynamic> config,
  ) async {
    return await _call<Map<String, dynamic>>(
      'network.configuration.update',
      config,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> listNetworkInterfaces() async {
    return await _call<List<dynamic>>(
      'interface.query',
    ).then((result) => result.cast<Map<String, dynamic>>());
  }

  @override
  Future<List<Map<String, dynamic>>> listServices() async {
    return await _call<List<dynamic>>(
      'service.query',
    ).then((result) => result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getService(String serviceName) async {
    return await _call<Map<String, dynamic>>('service.get_instance', {
      'service': serviceName,
    });
  }

  @override
  Future<bool> startService(String serviceName) async {
    await _call<dynamic>('service.start', {'service': serviceName});
    return true;
  }

  @override
  Future<bool> stopService(String serviceName) async {
    await _call<dynamic>('service.stop', {'service': serviceName});
    return true;
  }

  @override
  Future<bool> restartService(String serviceName) async {
    await _call<dynamic>('service.restart', {'service': serviceName});
    return true;
  }

  @override
  Future<Map<String, dynamic>> updateService(
    String serviceName,
    Map<String, dynamic> config,
  ) async {
    return await _call<Map<String, dynamic>>('service.update', {
      'service': serviceName,
      ...config,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> listVMs() async {
    return await _call<List<dynamic>>(
      'vm.query',
    ).then((result) => result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getVM(String vmId) async {
    return await _call<Map<String, dynamic>>('vm.get_instance', {'id': vmId});
  }

  @override
  Future<bool> startVM(String vmId) async {
    await _call<dynamic>('vm.start', {'id': vmId});
    return true;
  }

  @override
  Future<bool> stopVM(String vmId) async {
    await _call<dynamic>('vm.stop', {'id': vmId});
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> listApps() async {
    return await _call<List<dynamic>>(
      'app.query',
    ).then((result) => result.cast<Map<String, dynamic>>());
  }

  @override
  Future<Map<String, dynamic>> getApp(String appId) async {
    return await _call<Map<String, dynamic>>('app.get_instance', {'id': appId});
  }

  @override
  Future<Map<String, dynamic>> installApp(
    String appName,
    Map<String, dynamic> config,
  ) async {
    return await _call<Map<String, dynamic>>('app.create', {
      'name': appName,
      ...config,
    });
  }

  @override
  Future<Map<String, dynamic>> updateApp(
    String appId,
    Map<String, dynamic> config,
  ) async {
    return await _call<Map<String, dynamic>>('app.update', {
      'id': appId,
      ...config,
    });
  }

  @override
  Future<bool> deleteApp(String appId) async {
    await _call<dynamic>('app.delete', {'id': appId});
    return true;
  }

  @override
  Future<bool> reboot({int delay = 0}) async {
    await _call<dynamic>('system.reboot', {'delay': delay});
    return true;
  }

  @override
  Future<bool> shutdown({int delay = 0}) async {
    await _call<dynamic>('system.shutdown', {'delay': delay});
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

    return await _call<List<dynamic>>(
      'system.logs',
      params,
    ).then((result) => result.cast<Map<String, dynamic>>());
  }

  // Disk Management
  @override
  Future<List<Disk>> listDisks({bool includePools = true}) async {
    final result = await _call<List<dynamic>>('disk.query', {
      'filters': <dynamic>[],
      'options': {
        'extra': {'pools': includePools},
      },
    });

    return result.map((diskData) {
      final disk = diskData as Map<String, dynamic>;
      return Disk(
        identifier: (disk['identifier'] as String?) ?? '',
        name: (disk['name'] as String?) ?? '',
        serial: disk['serial'] as String?,
        lunid: disk['lunid'] as String?,
        size: (disk['size'] as int?) ?? 0,
        description: disk['description'] as String?,
        model: (disk['model'] as String?) ?? 'Unknown',
        type: _parseDiskType(disk['type'] as String?),
        bus: (disk['bus'] as String?) ?? 'Unknown',
        devname: (disk['devname'] as String?) ?? '',
        rotationrate: disk['rotationrate'] as int?,
        zfsGuid: disk['zfs_guid']?.toString(),
        pool: disk['pool'] as String?,
        number: (disk['number'] as int?) ?? 0,
        subsystem: (disk['subsystem'] as String?) ?? '',
        transfermode: (disk['transfermode'] as String?) ?? 'Auto',
        hddstandby: (disk['hddstandby'] as String?) ?? 'ALWAYS ON',
        advpowermgmt: (disk['advpowermgmt'] as String?) ?? 'DISABLED',
        togglesmart: (disk['togglesmart'] as bool?) ?? true,
        smartoptions: (disk['smartoptions'] as String?) ?? '',
        temperature: disk['temperature'] as int?,
        supportsSmart: disk['supports_smart'] as bool?,
        enclosure: disk['enclosure'] as String?,
        health: _evaluateDiskHealth(disk),
      );
    }).toList();
  }

  @override
  Future<Disk> getDisk(String identifier) async {
    final disks = await listDisks();
    return disks.firstWhere(
      (disk) => disk.identifier == identifier,
      orElse: () => throw TrueNasNotFoundException(
        'Disk with identifier $identifier not found',
        resourceType: 'Disk',
        resourceId: identifier,
      ),
    );
  }

  @override
  Future<List<DiskTemperature>> getDiskTemperatures(
    List<String> diskNames,
  ) async {
    final result = await _call<Map<String, dynamic>>('disk.temperatures', {
      'names': diskNames,
    });

    final temperatures = <DiskTemperature>[];
    final now = DateTime.now();

    result.forEach((diskName, temp) {
      temperatures.add(
        DiskTemperature(
          diskName: diskName,
          temperature: temp as int?,
          timestamp: now,
        ),
      );
    });

    return temperatures;
  }

  @override
  Future<Map<String, dynamic>> getDiskTemperatureAlerts(
    List<String> diskNames,
  ) async {
    return await _call<Map<String, dynamic>>('disk.temperature_alerts', {
      'names': diskNames,
    });
  }

  @override
  Future<Map<String, dynamic>> getDiskTemperatureHistory({
    required List<String> diskNames,
    required int days,
  }) async {
    return await _call<Map<String, dynamic>>('disk.temperature_agg', {
      'names': diskNames,
      'days': days,
    });
  }

  @override
  Future<List<Disk>> getPoolDisks(String poolId) async {
    final disks = await listDisks(includePools: true);
    return disks.where((disk) => disk.pool == poolId).toList();
  }

  @override
  Future<PoolTopology> getPoolTopology(String poolId) async {
    // Get pool configuration to extract topology
    final poolConfig = await _call<Map<String, dynamic>>('pool.query', {
      'filters': [
        ['id', '=', poolId],
      ],
      'options': {'get': true},
    });

    final topology = poolConfig['topology'] as Map<String, dynamic>? ?? {};
    final allDisks = await listDisks(includePools: true);

    // Helper to convert disk references to Disk objects
    List<Disk> getDisksFromVdev(List<dynamic> vdevDisks) {
      return vdevDisks.map((diskRef) {
        final diskName = diskRef is Map ? diskRef['disk'] : diskRef;
        return allDisks.firstWhere(
          (disk) => disk.name == diskName || disk.devname == diskName,
          orElse: () => throw TrueNasNotFoundException(
            'Disk $diskName not found',
            resourceType: 'Disk',
            resourceId: diskName.toString(),
          ),
        );
      }).toList();
    }

    // Parse vdev groups
    final vdevGroups = <VdevGroup>[];

    // Data vdevs
    final dataVdevs = topology['data'] as List<dynamic>? ?? [];
    for (final vdev in dataVdevs) {
      vdevGroups.add(
        VdevGroup(
          type: (vdev['type'] as String?) ?? 'stripe',
          status: (vdev['status'] as String?) ?? 'ONLINE',
          disks: getDisksFromVdev((vdev['children'] as List<dynamic>?) ?? []),
          name: vdev['name'] as String?,
          guid: vdev['guid']?.toString(),
        ),
      );
    }

    // Parse special vdevs (spares, cache, log)
    final spares = getDisksFromVdev(
      (topology['spare'] as List<dynamic>?) ?? [],
    );
    final cache = getDisksFromVdev((topology['cache'] as List<dynamic>?) ?? []);
    final log = getDisksFromVdev((topology['log'] as List<dynamic>?) ?? []);

    return PoolTopology(
      poolId: poolId,
      poolName: (poolConfig['name'] as String?) ?? poolId,
      vdevGroups: vdevGroups,
      spares: spares,
      cache: cache,
      log: log,
    );
  }

  @override
  Future<Map<String, dynamic>> getDiskSmartData(String diskName) async {
    return await _call<Map<String, dynamic>>('smart.test.results', {
      'disk': diskName,
    });
  }

  @override
  Future<bool> runSmartTest({
    required String diskName,
    required String testType,
  }) async {
    await _call<dynamic>('smart.test.manual_test', {
      'disk': diskName,
      'type': testType,
    });
    return true;
  }

  // Helper methods
  DiskType _parseDiskType(String? type) {
    switch (type?.toUpperCase()) {
      case 'SSD':
        return DiskType.ssd;
      case 'HDD':
        return DiskType.hdd;
      default:
        return DiskType.unknown;
    }
  }

  DiskHealth _evaluateDiskHealth(Map<String, dynamic> diskData) {
    // Basic health evaluation based on SMART status and temperature
    final smartStatus = diskData['smart_status'];
    final temperature = diskData['temperature'] as int?;

    if (smartStatus == 'FAIL' || smartStatus == 'FAILED') {
      return DiskHealth.critical;
    }

    if (temperature != null) {
      if (temperature > 50) {
        return DiskHealth.critical;
      } else if (temperature > 45) {
        return DiskHealth.warning;
      }
    }

    if (smartStatus == 'PASS' || smartStatus == 'PASSED') {
      return DiskHealth.healthy;
    }

    return DiskHealth.unknown;
  }
}
