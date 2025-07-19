import 'dart:async';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mynas_shared/mynas_shared.dart';

class TrueNasClient {
  final _logger = Logger('TrueNasClient');
  late final Dio _dio;
  final String baseUrl;
  final String? apiKey;

  TrueNasClient({this.baseUrl = 'http://localhost/api/v2.0', this.apiKey}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          if (apiKey != null) 'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  Future<SystemInfo> getSystemInfo() async {
    try {
      final response = await _dio.get('/system/info');
      final uptimeResponse = await _dio.get('/system/uptime');
      await _dio.get(
        '/reporting/get_data',
        data: {
          'graphs': [
            {'name': 'cpu'},
          ],
          'reporting_query': {'start': '-1h', 'end': 'now'},
        },
      );

      // Mock data for now - replace with actual TrueNAS API parsing
      return SystemInfo(
        hostname: response.data['hostname'] ?? 'truenas',
        version: response.data['version'] ?? 'TrueNAS-SCALE-24.04',
        uptime: uptimeResponse.data ?? '1 day, 2:30:45',
        cpuUsage: 25.5,
        memory: MemoryInfo(
          total: 16 * 1024 * 1024 * 1024,
          used: 8 * 1024 * 1024 * 1024,
          free: 8 * 1024 * 1024 * 1024,
          cached: 2 * 1024 * 1024 * 1024,
        ),
        cpuTemperature: 45.2,
        alerts: [],
      );
    } catch (e) {
      _logger.severe('Failed to get system info: $e');
      rethrow;
    }
  }

  Future<List<Alert>> getAlerts() async {
    try {
      final response = await _dio.get('/alert/list');
      return (response.data as List)
          .map(
            (alert) => Alert(
              id: alert['id'],
              level: _parseAlertLevel(alert['level']),
              message: alert['formatted'] ?? alert['text'],
              timestamp: DateTime.parse(alert['datetime']),
              dismissed: alert['dismissed'] ?? false,
            ),
          )
          .toList();
    } catch (e) {
      _logger.severe('Failed to get alerts: $e');
      return [];
    }
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

  Future<List<Pool>> listPools() async {
    try {
      final response = await _dio.get('/pool');
      return (response.data as List)
          .map(
            (pool) => Pool(
              id: pool['id'].toString(),
              name: pool['name'],
              status: pool['status'],
              size: pool['size'] ?? 0,
              allocated: pool['allocated'] ?? 0,
              free: pool['free'] ?? 0,
              fragmentation: (pool['fragmentation'] ?? 0).toDouble(),
              isHealthy: pool['healthy'] ?? false,
              path: pool['path'],
              vdevs: _parseVdevs(pool['topology']),
            ),
          )
          .toList();
    } catch (e) {
      _logger.severe('Failed to list pools: $e');
      return [];
    }
  }

  List<PoolVdev> _parseVdevs(Map<String, dynamic>? topology) {
    if (topology == null) return [];

    final vdevs = <PoolVdev>[];
    for (final type in ['data', 'cache', 'log', 'spare']) {
      final vdevList = topology[type] as List?;
      if (vdevList != null) {
        for (final vdev in vdevList) {
          vdevs.add(
            PoolVdev(
              type: vdev['type'] ?? type,
              status: vdev['status'] ?? 'ONLINE',
              disks:
                  (vdev['children'] as List?)
                      ?.map((child) => child['disk'] as String)
                      .toList() ??
                  [],
            ),
          );
        }
      }
    }
    return vdevs;
  }

  Future<Pool> getPool(String id) async {
    final pools = await listPools();
    return pools.firstWhere((p) => p.id == id);
  }

  Future<List<Dataset>> listDatasets({String? poolId}) async {
    try {
      final response = await _dio.get('/pool/dataset');
      return (response.data as List)
          .where((ds) => poolId == null || ds['pool'] == poolId)
          .map(
            (ds) => Dataset(
              id: ds['id'],
              name: ds['name'],
              pool: ds['pool'],
              type: ds['type'] ?? 'FILESYSTEM',
              used: ds['used']['parsed'] ?? 0,
              available: ds['available']['parsed'] ?? 0,
              referenced: ds['referenced']['parsed'] ?? 0,
              mountpoint: ds['mountpoint'] ?? '',
              encrypted: ds['encrypted'] ?? false,
              children:
                  (ds['children'] as List?)
                      ?.map((c) => c['name'] as String)
                      .toList() ??
                  [],
              properties: ds['properties'],
            ),
          )
          .toList();
    } catch (e) {
      _logger.severe('Failed to list datasets: $e');
      return [];
    }
  }

  Future<Dataset> getDataset(String id) async {
    final datasets = await listDatasets();
    return datasets.firstWhere((d) => d.id == id);
  }

  Future<Dataset> createDataset({
    required String pool,
    required String name,
    Map<String, dynamic>? properties,
  }) async {
    try {
      final response = await _dio.post(
        '/pool/dataset',
        data: {'name': '$pool/$name', 'type': 'FILESYSTEM', ...?properties},
      );

      return getDataset(response.data['id']);
    } catch (e) {
      _logger.severe('Failed to create dataset: $e');
      rethrow;
    }
  }

  Future<List<Share>> listShares({ShareType? type}) async {
    final shares = <Share>[];

    if (type == null || type == ShareType.smb) {
      shares.addAll(await _listSmbShares());
    }
    if (type == null || type == ShareType.nfs) {
      shares.addAll(await _listNfsShares());
    }

    return shares;
  }

  Future<List<Share>> _listSmbShares() async {
    try {
      final response = await _dio.get('/sharing/smb');
      return (response.data as List)
          .map(
            (share) => Share(
              id: share['id'].toString(),
              name: share['name'],
              path: share['path'],
              type: ShareType.smb,
              enabled: share['enabled'] ?? false,
              comment: share['comment'],
              config: share,
            ),
          )
          .toList();
    } catch (e) {
      _logger.severe('Failed to list SMB shares: $e');
      return [];
    }
  }

  Future<List<Share>> _listNfsShares() async {
    try {
      final response = await _dio.get('/sharing/nfs');
      return (response.data as List)
          .map(
            (share) => Share(
              id: share['id'].toString(),
              name: share['comment'] ?? 'NFS Share ${share['id']}',
              path: share['path'],
              type: ShareType.nfs,
              enabled: share['enabled'] ?? false,
              comment: share['comment'],
              config: share,
            ),
          )
          .toList();
    } catch (e) {
      _logger.severe('Failed to list NFS shares: $e');
      return [];
    }
  }

  Future<Share> getShare(String id) async {
    final shares = await listShares();
    return shares.firstWhere((s) => s.id == id);
  }

  Future<Share> createShare(Share shareData) async {
    switch (shareData.type) {
      case ShareType.smb:
        return _createSmbShare(shareData);
      case ShareType.nfs:
        return _createNfsShare(shareData);
      default:
        throw UnsupportedError('Share type ${shareData.type} not implemented');
    }
  }

  Future<Share> _createSmbShare(Share shareData) async {
    try {
      final response = await _dio.post(
        '/sharing/smb',
        data: {
          'name': shareData.name,
          'path': shareData.path,
          'enabled': shareData.enabled,
          'comment': shareData.comment,
          ...?shareData.config,
        },
      );

      return getShare(response.data['id'].toString());
    } catch (e) {
      _logger.severe('Failed to create SMB share: $e');
      rethrow;
    }
  }

  Future<Share> _createNfsShare(Share shareData) async {
    try {
      final response = await _dio.post(
        '/sharing/nfs',
        data: {
          'path': shareData.path,
          'enabled': shareData.enabled,
          'comment': shareData.comment ?? shareData.name,
          ...?shareData.config,
        },
      );

      return getShare(response.data['id'].toString());
    } catch (e) {
      _logger.severe('Failed to create NFS share: $e');
      rethrow;
    }
  }

  Future<Share> updateShare(Share shareData) async {
    switch (shareData.type) {
      case ShareType.smb:
        await _dio.put(
          '/sharing/smb/id/${shareData.id}',
          data: {
            'name': shareData.name,
            'path': shareData.path,
            'enabled': shareData.enabled,
            'comment': shareData.comment,
            ...?shareData.config,
          },
        );
        break;
      case ShareType.nfs:
        await _dio.put(
          '/sharing/nfs/id/${shareData.id}',
          data: {
            'path': shareData.path,
            'enabled': shareData.enabled,
            'comment': shareData.comment,
            ...?shareData.config,
          },
        );
        break;
      default:
        throw UnsupportedError('Share type ${shareData.type} not implemented');
    }

    return getShare(shareData.id);
  }

  Future<bool> deleteShare(String id) async {
    try {
      final share = await getShare(id);

      switch (share.type) {
        case ShareType.smb:
          await _dio.delete('/sharing/smb/id/$id');
          break;
        case ShareType.nfs:
          await _dio.delete('/sharing/nfs/id/$id');
          break;
        default:
          throw UnsupportedError('Share type ${share.type} not implemented');
      }

      return true;
    } catch (e) {
      _logger.severe('Failed to delete share: $e');
      return false;
    }
  }
}
