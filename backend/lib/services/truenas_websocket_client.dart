import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';
import 'package:mynas_shared/mynas_shared.dart';

class TrueNasWebSocketClient {
  final _logger = Logger('TrueNasWebSocketClient');
  final String wsUrl;
  final String? apiKey;
  
  WebSocketChannel? _channel;
  json_rpc.Peer? _peer;
  final _connectionCompleter = Completer<void>();
  
  TrueNasWebSocketClient({
    required this.wsUrl,
    this.apiKey,
  });

  Future<void> connect() async {
    try {
      _logger.info('Connecting to TrueNAS WebSocket at $wsUrl');
      
      // Create WebSocket connection
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Create JSON-RPC peer
      _peer = json_rpc.Peer(_channel!.cast<String>());
      
      // Register method handlers if needed
      _registerHandlers();
      
      // Start listening
      unawaited(_peer!.listen().then((_) {
        _logger.info('WebSocket connection closed');
      }).catchError((error) {
        _logger.severe('WebSocket error: $error');
      }));
      
      // Authenticate if API key is provided
      if (apiKey != null) {
        await authenticate();
      }
      
      _connectionCompleter.complete();
      _logger.info('Connected to TrueNAS WebSocket');
    } catch (e) {
      _logger.severe('Failed to connect to TrueNAS: $e');
      rethrow;
    }
  }

  void _registerHandlers() {
    // Register handlers for server-initiated methods
    _peer?.registerMethod('event', (params) {
      _logger.info('Received event: $params');
      // Handle TrueNAS events
    });
  }

  Future<void> authenticate() async {
    try {
      await _peer!.sendRequest('auth.login', {
        'username': 'root',
        'password': apiKey,
      });
      _logger.info('Authenticated with TrueNAS');
    } catch (e) {
      _logger.severe('Authentication failed: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _peer?.close();
    await _channel?.sink.close();
    _logger.info('Disconnected from TrueNAS');
  }

  // System methods
  Future<SystemInfo> getSystemInfo() async {
    await _ensureConnected();
    
    try {
      final info = await _peer!.sendRequest('system.info');
      final uptime = await _peer!.sendRequest('system.uptime');
      final stats = await _peer!.sendRequest('reporting.netdata_get_data', {
        'graphs': [
          {'name': 'cpu', 'identifier': 'system.cpu'},
          {'name': 'memory', 'identifier': 'system.ram'},
          {'name': 'temperature', 'identifier': 'cputemp-0.temperature'},
        ],
        'params': {'start': '-60', 'end': '0'}
      });
      
      // Parse the response
      final cpuData = _parseLatestValue(stats, 'cpu');
      final memoryData = stats['memory'] ?? {};
      final tempData = _parseLatestValue(stats, 'temperature');
      
      return SystemInfo(
        hostname: info['hostname'] ?? 'truenas',
        version: info['version'] ?? 'Unknown',
        uptime: _formatUptime(uptime),
        cpuUsage: cpuData ?? 0.0,
        memory: MemoryInfo(
          total: memoryData['total'] ?? 0,
          used: memoryData['used'] ?? 0,
          free: memoryData['free'] ?? 0,
          cached: memoryData['cached'] ?? 0,
        ),
        cpuTemperature: tempData ?? 0.0,
        alerts: await getAlerts(),
      );
    } catch (e) {
      _logger.severe('Failed to get system info: $e');
      rethrow;
    }
  }

  Future<List<Alert>> getAlerts() async {
    await _ensureConnected();
    
    try {
      final alerts = await _peer!.sendRequest('alert.list');
      return (alerts as List).map((alert) => Alert(
        id: alert['id'].toString(),
        level: _parseAlertLevel(alert['level']),
        message: alert['formatted'] ?? alert['text'] ?? '',
        timestamp: DateTime.parse(alert['datetime'] ?? DateTime.now().toIso8601String()),
        dismissed: alert['dismissed'] ?? false,
      )).toList();
    } catch (e) {
      _logger.severe('Failed to get alerts: $e');
      return [];
    }
  }

  // Pool methods
  Future<List<Pool>> listPools() async {
    await _ensureConnected();
    
    try {
      final pools = await _peer!.sendRequest('pool.query');
      return (pools as List).map((pool) => Pool(
        id: pool['id'].toString(),
        name: pool['name'],
        status: pool['status'] ?? 'UNKNOWN',
        size: pool['size'] ?? 0,
        allocated: pool['allocated'] ?? 0,
        free: pool['free'] ?? 0,
        fragmentation: (pool['fragmentation'] ?? 0).toDouble(),
        isHealthy: pool['healthy'] ?? false,
        path: pool['path'],
        vdevs: _parseVdevs(pool['topology']),
      )).toList();
    } catch (e) {
      _logger.severe('Failed to list pools: $e');
      return [];
    }
  }

  // Dataset methods
  Future<List<Dataset>> listDatasets({String? poolId}) async {
    await _ensureConnected();
    
    try {
      final datasets = await _peer!.sendRequest('pool.dataset.query');
      return (datasets as List)
          .where((ds) => poolId == null || ds['pool'] == poolId)
          .map((ds) => Dataset(
            id: ds['id'],
            name: ds['name'],
            pool: ds['pool'] ?? '',
            type: ds['type'] ?? 'FILESYSTEM',
            used: ds['used']?['parsed'] ?? 0,
            available: ds['available']?['parsed'] ?? 0,
            referenced: ds['referenced']?['parsed'] ?? 0,
            mountpoint: ds['mountpoint'] ?? '',
            encrypted: ds['encrypted'] ?? false,
            children: (ds['children'] as List?)?.map((c) => c.toString()).toList() ?? [],
            properties: ds['properties'] ?? {},
          ))
          .toList();
    } catch (e) {
      _logger.severe('Failed to list datasets: $e');
      return [];
    }
  }

  Future<Dataset> createDataset({
    required String pool,
    required String name,
    Map<String, dynamic>? properties,
  }) async {
    await _ensureConnected();
    
    try {
      final result = await _peer!.sendRequest('pool.dataset.create', {
        'name': '$pool/$name',
        'type': 'FILESYSTEM',
        ...?properties,
      });
      
      // Query the created dataset
      final datasets = await listDatasets();
      return datasets.firstWhere((ds) => ds.id == result['id']);
    } catch (e) {
      _logger.severe('Failed to create dataset: $e');
      rethrow;
    }
  }

  // Share methods
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
    await _ensureConnected();
    
    try {
      final shares = await _peer!.sendRequest('sharing.smb.query');
      return (shares as List).map((share) => Share(
        id: share['id'].toString(),
        name: share['name'],
        path: share['path'],
        type: ShareType.smb,
        enabled: share['enabled'] ?? false,
        comment: share['comment'],
        config: share,
      )).toList();
    } catch (e) {
      _logger.severe('Failed to list SMB shares: $e');
      return [];
    }
  }

  Future<List<Share>> _listNfsShares() async {
    await _ensureConnected();
    
    try {
      final shares = await _peer!.sendRequest('sharing.nfs.query');
      return (shares as List).map((share) => Share(
        id: share['id'].toString(),
        name: share['comment'] ?? 'NFS Share ${share['id']}',
        path: share['path'] ?? '',
        type: ShareType.nfs,
        enabled: share['enabled'] ?? false,
        comment: share['comment'],
        config: share,
      )).toList();
    } catch (e) {
      _logger.severe('Failed to list NFS shares: $e');
      return [];
    }
  }

  // Helper methods
  Future<void> _ensureConnected() async {
    if (_peer == null || _peer!.isClosed) {
      await connect();
    }
    await _connectionCompleter.future;
  }

  String _formatUptime(dynamic uptimeSeconds) {
    if (uptimeSeconds is! num) return 'Unknown';
    
    final duration = Duration(seconds: uptimeSeconds.toInt());
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (days > 0) {
      return '$days days, $hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  double? _parseLatestValue(Map<String, dynamic> stats, String key) {
    final data = stats[key];
    if (data is Map && data['data'] is List && (data['data'] as List).isNotEmpty) {
      final latestPoint = (data['data'] as List).last;
      if (latestPoint is List && latestPoint.length > 1) {
        return (latestPoint[1] as num?)?.toDouble();
      }
    }
    return null;
  }

  AlertLevel _parseAlertLevel(String? level) {
    switch (level?.toLowerCase()) {
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

  List<PoolVdev> _parseVdevs(Map<String, dynamic>? topology) {
    if (topology == null) return [];
    
    final vdevs = <PoolVdev>[];
    for (final type in ['data', 'cache', 'log', 'spare', 'special', 'dedup']) {
      final vdevList = topology[type] as List?;
      if (vdevList != null && vdevList.isNotEmpty) {
        for (final vdev in vdevList) {
          vdevs.add(PoolVdev(
            type: vdev['type'] ?? type,
            status: vdev['status'] ?? 'ONLINE',
            disks: _extractDisks(vdev),
          ));
        }
      }
    }
    return vdevs;
  }

  List<String> _extractDisks(Map<String, dynamic> vdev) {
    final disks = <String>[];
    
    if (vdev['disk'] != null) {
      disks.add(vdev['disk']);
    }
    
    if (vdev['children'] is List) {
      for (final child in vdev['children']) {
        if (child['disk'] != null) {
          disks.add(child['disk']);
        }
      }
    }
    
    return disks;
  }
}