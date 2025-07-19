import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:web_socket_channel/io.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';

/// Mock TrueNAS server for testing
void main(List<String> args) async {
  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('[${record.time}] ${record.level.name}: ${record.message}');
  });

  final logger = Logger('MockTrueNAS');

  // Parse port from args or use default
  final port = args.isNotEmpty ? int.tryParse(args[0]) ?? 8081 : 8081;

  // Start WebSocket server
  final server = await HttpServer.bind('localhost', port);
  logger.info(
    'Mock TrueNAS server listening on ws://localhost:$port/api/current',
  );

  server.transform(WebSocketTransformer()).listen((WebSocket webSocket) {
    logger.info('Client connected');
    handleConnection(webSocket, logger);
  });
}

void handleConnection(WebSocket webSocket, Logger logger) {
  final channel = IOWebSocketChannel(webSocket);
  final peer = json_rpc.Peer(channel.cast<String>());

  // Register mock methods
  registerMockMethods(peer, logger);

  // Start listening
  peer
      .listen()
      .then((_) {
        logger.info('Client disconnected');
      })
      .catchError((error) {
        logger.severe('WebSocket error: $error');
      });

  // Send initial real-time updates like TrueNAS does
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (webSocket.readyState != WebSocket.open) {
      timer.cancel();
      return;
    }

    try {
      // Send reporting.realtime updates like in the fixture
      peer.sendNotification('collection_update', {
        'msg': 'added',
        'collection': 'reporting.realtime',
        'fields': getMockRealtimeData(),
      });
    } catch (e) {
      logger.warning('Failed to send realtime update: $e');
      timer.cancel();
    }
  });
}

void registerMockMethods(json_rpc.Peer peer, Logger logger) {
  // System methods
  peer.registerMethod('system.info', (params) {
    logger.fine('Called system.info');
    return {
      'version': 'TrueNAS-SCALE-24.04.0',
      'buildtime': '2024-04-15T12:00:00+00:00',
      'hostname': 'mock-truenas',
      'physmem': 8589934592,
      'model': 'Mock CPU',
      'cores': 4,
      'physical_cores': 4,
      'loadavg': [0.5, 0.6, 0.7],
      'uptime': '1 day, 2:30:45',
      'uptime_seconds': 95445.0,
      'system_serial': 'MOCK-001',
      'system_product': 'Mock TrueNAS',
      'system_product_version': '1.0',
      'license': null,
      'boottime': '2024-04-14T09:30:00+00:00',
      'datetime': DateTime.now().toIso8601String(),
      'birthday': null,
      'timezone': 'UTC',
      'system_manufacturer': 'Mock Systems',
      'ecc_memory': true,
    };
  });

  peer.registerMethod('system.general.config', (params) {
    logger.fine('Called system.general.config');
    return {
      'ui_hostname': 'mock-truenas.local',
      'ui_port': 443,
      'ui_certificate': 1,
      'ui_httpsprotocols': ['TLSv1.2', 'TLSv1.3'],
    };
  });

  peer.registerMethod('system.advanced.config', (params) {
    logger.fine('Called system.advanced.config');
    return {
      'consolemsg': true,
      'cpu_in_percentage': false,
      'debugkernel': false,
    };
  });

  peer.registerMethod('system.product_type', (params) {
    logger.fine('Called system.product_type');
    return 'SCALE';
  });

  peer.registerMethod('truenas.is_ix_hardware', (params) {
    logger.fine('Called truenas.is_ix_hardware');
    return false;
  });

  // Pool methods
  peer.registerMethod('pool.query', (params) {
    logger.fine('Called pool.query with params: $params');
    return [
      {
        'id': 1,
        'name': 'tank',
        'guid': '12345678901234567890',
        'is_upgraded': true,
        'path': '/mnt/tank',
        'status': 'ONLINE',
        'scan': {
          'function': 'SCRUB',
          'state': 'FINISHED',
          'start_time': {
            '\$date': DateTime.now()
                .subtract(Duration(hours: 2))
                .millisecondsSinceEpoch,
          },
          'end_time': {
            '\$date': DateTime.now()
                .subtract(Duration(hours: 1))
                .millisecondsSinceEpoch,
          },
          'percentage': 100.0,
          'bytes_to_process': 1000000000,
          'bytes_processed': 1000000000,
          'bytes_issued': 1000000000,
          'pause': null,
          'errors': 0,
          'total_secs_left': null,
        },
        'topology': {
          'data': [
            {
              'name': 'mirror-0',
              'type': 'MIRROR',
              'path': null,
              'guid': '98765432109876543210',
              'status': 'ONLINE',
              'stats': {
                'timestamp': DateTime.now().microsecondsSinceEpoch,
                'read_errors': 0,
                'write_errors': 0,
                'checksum_errors': 0,
                'ops': [0, 100, 200, 0, 0, 50, 0],
                'bytes': [0, 1048576, 2097152, 0, 0, 524288, 0],
                'size': 2000000000000,
                'allocated': 1000000000000,
                'fragmentation': 10,
                'self_healed': 0,
                'configured_ashift': 12,
                'logical_ashift': 9,
                'physical_ashift': 12,
              },
              'children': [
                {
                  'name': 'sda1',
                  'type': 'DISK',
                  'path': '/dev/sda1',
                  'guid': '11111111111111111111',
                  'status': 'ONLINE',
                  'device': 'sda1',
                  'disk': 'sda',
                },
                {
                  'name': 'sdb1',
                  'type': 'DISK',
                  'path': '/dev/sdb1',
                  'guid': '22222222222222222222',
                  'status': 'ONLINE',
                  'device': 'sdb1',
                  'disk': 'sdb',
                },
              ],
            },
          ],
          'log': [],
          'cache': [],
          'spare': [],
          'special': [],
          'dedup': [],
        },
        'healthy': true,
        'warning': false,
        'status_code': 'OK',
        'status_detail': null,
        'size': 2000000000000,
        'allocated': 1000000000000,
        'free': 1000000000000,
        'freeing': 0,
        'fragmentation': '10',
        'size_str': '2000000000000',
        'allocated_str': '1000000000000',
        'free_str': '1000000000000',
        'freeing_str': '0',
        'autotrim': {
          'value': 'on',
          'rawvalue': 'on',
          'parsed': 'on',
          'source': 'LOCAL',
        },
      },
    ];
  });

  peer.registerMethod('pool.dataset.query', (params) {
    logger.fine('Called pool.dataset.query');
    return [
      {
        'id': 'tank',
        'type': 'FILESYSTEM',
        'name': 'tank',
        'pool': 'tank',
        'encrypted': false,
        'encryption_root': null,
        'key_loaded': false,
        'mountpoint': '/mnt/tank',
        'used': {
          'parsed': 500000000000,
          'rawvalue': '500000000000',
          'value': '500G',
        },
        'available': {
          'parsed': 500000000000,
          'rawvalue': '500000000000',
          'value': '500G',
        },
        'compression': {'parsed': 'lz4', 'rawvalue': 'lz4', 'value': 'LZ4'},
        'compressratio': {
          'parsed': '1.20',
          'rawvalue': '1.20',
          'value': '1.20x',
        },
        'children': [],
      },
    ];
  });

  // Disk methods
  peer.registerMethod('disk.query', (params) {
    logger.fine('Called disk.query');
    return [
      {
        'identifier': '{serial}VMware_Virtual_disk_00000000000000000001',
        'name': 'sda',
        'subsystem': 'scsi',
        'number': 2048,
        'serial': '00000000000000000001',
        'size': 1000204886016,
        'mediasize': 1000204886016,
        'sectorsize': 512,
        'stripesize': 0,
        'model': 'VMware Virtual disk',
        'rotationrate': null,
        'type': 'HDD',
        'zfs_guid': '11111111111111111111',
        'bus': 'SCSI',
        'devname': 'sda',
        'enclosure': null,
        'pool': 'tank',
      },
      {
        'identifier': '{serial}VMware_Virtual_disk_00000000000000000002',
        'name': 'sdb',
        'subsystem': 'scsi',
        'number': 2064,
        'serial': '00000000000000000002',
        'size': 1000204886016,
        'mediasize': 1000204886016,
        'sectorsize': 512,
        'stripesize': 0,
        'model': 'VMware Virtual disk',
        'rotationrate': null,
        'type': 'HDD',
        'zfs_guid': '22222222222222222222',
        'bus': 'SCSI',
        'devname': 'sdb',
        'enclosure': null,
        'pool': 'tank',
      },
    ];
  });

  peer.registerMethod('disk.details', (params) {
    logger.fine('Called disk.details');
    return {};
  });

  // Other methods
  peer.registerMethod('alert.list', (params) {
    logger.fine('Called alert.list');
    return [];
  });

  peer.registerMethod('auth.me', (params) {
    logger.fine('Called auth.me');
    return {'id': 1, 'username': 'root', 'group': 'wheel', 'attributes': {}};
  });

  peer.registerMethod('core.ping', (params) {
    logger.fine('Called core.ping');
    return 'pong';
  });

  peer.registerMethod('core.subscribe', (params) {
    logger.fine('Called core.subscribe with params: $params');
    // Just acknowledge the subscription
    return true;
  });

  peer.registerMethod('tn_connect.config', (params) {
    logger.fine('Called tn_connect.config');
    return {'enabled': false, 'api_key': null};
  });

  // Share methods
  peer.registerMethod('sharing.smb.query', (params) {
    logger.fine('Called sharing.smb.query');
    return [];
  });

  peer.registerMethod('sharing.nfs.query', (params) {
    logger.fine('Called sharing.nfs.query');
    return [];
  });

  // Version detection methods (for backwards compatibility)
  peer.registerMethod('system.version', (params) {
    logger.fine('Called system.version');
    return 'TrueNAS-SCALE-24.04.0';
  });
}

Map<String, dynamic> getMockRealtimeData() {
  final random = Random();
  return {
    'zfs': {
      'demand_accesses_per_second': random.nextInt(500),
      'demand_data_accesses_per_second': random.nextInt(400),
      'demand_metadata_accesses_per_second': random.nextInt(100),
      'l2arc_hits_per_second': 0,
      'l2arc_misses_per_second': 0,
    },
    'memory': {
      'arc_size': 4294967296,
      'arc_free_memory': 2147483648,
      'arc_available_memory': 1073741824,
      'physical_memory_total': 8589934592,
      'physical_memory_available': 4294967296,
    },
    'cpu': {
      'cpu': {'usage': random.nextInt(20) + 5.0, 'temp': null},
      'cpu0': {'usage': random.nextInt(30) + 5.0, 'temp': null},
      'cpu1': {'usage': random.nextInt(30) + 5.0, 'temp': null},
      'cpu2': {'usage': random.nextInt(30) + 5.0, 'temp': null},
      'cpu3': {'usage': random.nextInt(30) + 5.0, 'temp': null},
    },
    'disks': {
      'read_ops': random.nextDouble() * 100,
      'read_bytes': random.nextInt(1000000),
      'write_ops': random.nextInt(50),
      'write_bytes': random.nextInt(1000000),
      'busy': random.nextDouble() * 10,
    },
    'interfaces': {
      'eth0': {
        'link_state': 'LINK_STATE_UP',
        'speed': 1000,
        'received_bytes_rate': random.nextInt(100000),
        'sent_bytes_rate': random.nextInt(100000),
      },
    },
    'failed_to_connect': false,
  };
}
