import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../services/rpc_client.dart';

final _logger = Logger('DiskProvider');

// Disk state management
class DiskState {
  final List<Disk> disks;
  final Map<String, DiskTemperature> temperatures;
  final Map<String, PoolTopology> poolTopologies;
  final Map<String, Map<String, dynamic>> smartData;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const DiskState({
    this.disks = const [],
    this.temperatures = const {},
    this.poolTopologies = const {},
    this.smartData = const {},
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  DiskState copyWith({
    List<Disk>? disks,
    Map<String, DiskTemperature>? temperatures,
    Map<String, PoolTopology>? poolTopologies,
    Map<String, Map<String, dynamic>>? smartData,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return DiskState(
      disks: disks ?? this.disks,
      temperatures: temperatures ?? this.temperatures,
      poolTopologies: poolTopologies ?? this.poolTopologies,
      smartData: smartData ?? this.smartData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Helper getters
  List<Disk> get ssdDisks =>
      disks.where((d) => d.type == DiskType.ssd).toList();
  List<Disk> get hddDisks =>
      disks.where((d) => d.type == DiskType.hdd).toList();

  List<Disk> getDisksForPool(String poolId) {
    return disks.where((disk) => disk.pool == poolId).toList();
  }

  Disk? getDisk(String identifier) {
    try {
      return disks.firstWhere((disk) => disk.identifier == identifier);
    } catch (e) {
      return null;
    }
  }

  DiskTemperature? getDiskTemperature(String diskName) {
    return temperatures[diskName];
  }

  PoolTopology? getPoolTopology(String poolId) {
    return poolTopologies[poolId];
  }

  Map<String, dynamic>? getDiskSmartData(String diskName) {
    return smartData[diskName];
  }

  // Aggregate statistics
  int get totalDisks => disks.length;

  int get healthyDisks =>
      disks.where((d) => d.health == DiskHealth.healthy).length;

  int get warningDisks =>
      disks.where((d) => d.health == DiskHealth.warning).length;

  int get criticalDisks =>
      disks.where((d) => d.health == DiskHealth.critical).length;

  int get totalCapacity => disks.fold(0, (sum, disk) => sum + disk.size);

  List<Disk> get unhealthyDisks => disks
      .where(
        (d) =>
            d.health == DiskHealth.warning || d.health == DiskHealth.critical,
      )
      .toList();

  bool get hasUnhealthyDisks => unhealthyDisks.isNotEmpty;
}

// Disk notifier
class DiskNotifier extends StateNotifier<DiskState> {
  final RpcClient _rpcClient;

  DiskNotifier(this._rpcClient) : super(const DiskState()) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await refresh();
  }

  // Refresh all disk data
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      _logger.info('Refreshing disk data');

      // Load disks
      final disksData = await _rpcClient.sendRequest<List<dynamic>>(
        'disk.list',
        {'includePools': true},
      );
      final disks = disksData
          .map<Disk>((data) => Disk.fromJson(data as Map<String, dynamic>))
          .toList();

      // Load temperatures for all disks
      final diskNames = disks.map((d) => d.name).toList();
      Map<String, DiskTemperature> temperatures = {};

      if (diskNames.isNotEmpty) {
        try {
          final tempData = await _rpcClient.sendRequest<List<dynamic>>(
            'disk.temperatures',
            {'diskNames': diskNames},
          );

          for (final temp in tempData) {
            final diskTemp = DiskTemperature.fromJson(
              temp as Map<String, dynamic>,
            );
            temperatures[diskTemp.diskName] = diskTemp;
          }
        } catch (e) {
          _logger.warning('Failed to load disk temperatures: $e');
        }
      }

      state = state.copyWith(
        disks: disks,
        temperatures: temperatures,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );

      _logger.info('Disk data refreshed successfully: ${disks.length} disks');
    } catch (e, stackTrace) {
      _logger.severe('Failed to refresh disk data: $e', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load disk data: $e',
      );
    }
  }

  // Load pool topology
  Future<void> loadPoolTopology(String poolId) async {
    try {
      _logger.info('Loading topology for pool $poolId');

      final topologyData = await _rpcClient.sendRequest<Map<String, dynamic>>(
        'pool.topology',
        {'poolId': poolId},
      );

      final topology = PoolTopology.fromJson(topologyData);

      final newTopologies = Map<String, PoolTopology>.from(
        state.poolTopologies,
      );
      newTopologies[poolId] = topology;

      state = state.copyWith(poolTopologies: newTopologies);
    } catch (e) {
      _logger.warning('Failed to load topology for pool $poolId: $e');
    }
  }

  // Load SMART data for a disk
  Future<void> loadSmartData(String diskName) async {
    try {
      _logger.info('Loading SMART data for disk $diskName');

      final smartData = await _rpcClient.sendRequest<Map<String, dynamic>>(
        'disk.smart_data',
        {'diskName': diskName},
      );

      final newSmartData = Map<String, Map<String, dynamic>>.from(
        state.smartData,
      );
      newSmartData[diskName] = smartData;

      state = state.copyWith(smartData: newSmartData);
    } catch (e) {
      _logger.warning('Failed to load SMART data for disk $diskName: $e');
    }
  }

  // Run SMART test
  Future<void> runSmartTest({
    required String diskName,
    required String testType,
  }) async {
    try {
      _logger.info('Running $testType SMART test on disk $diskName');

      await _rpcClient.sendRequest<bool>('disk.run_smart_test', {
        'diskName': diskName,
        'testType': testType,
      });

      // Reload SMART data after test
      await loadSmartData(diskName);
    } catch (e) {
      _logger.severe('Failed to run SMART test on disk $diskName: $e');
      rethrow;
    }
  }

  // Update temperature data
  Future<void> updateTemperatures() async {
    try {
      final diskNames = state.disks.map((d) => d.name).toList();

      if (diskNames.isEmpty) return;

      final tempData = await _rpcClient.sendRequest<List<dynamic>>(
        'disk.temperatures',
        {'diskNames': diskNames},
      );

      final temperatures = <String, DiskTemperature>{};
      for (final temp in tempData) {
        final diskTemp = DiskTemperature.fromJson(temp as Map<String, dynamic>);
        temperatures[diskTemp.diskName] = diskTemp;
      }

      state = state.copyWith(temperatures: temperatures);
    } catch (e) {
      _logger.warning('Failed to update disk temperatures: $e');
    }
  }
}

// Provider instances
final diskProvider = StateNotifierProvider<DiskNotifier, DiskState>((ref) {
  final rpcClient = ref.watch(rpcClientProvider);
  return DiskNotifier(rpcClient);
});

// Convenience providers
final allDisksProvider = Provider<List<Disk>>((ref) {
  return ref.watch(diskProvider).disks;
});

final ssdDisksProvider = Provider<List<Disk>>((ref) {
  return ref.watch(diskProvider).ssdDisks;
});

final hddDisksProvider = Provider<List<Disk>>((ref) {
  return ref.watch(diskProvider).hddDisks;
});

final unhealthyDisksProvider = Provider<List<Disk>>((ref) {
  return ref.watch(diskProvider).unhealthyDisks;
});

final diskByIdProvider = Provider.family<Disk?, String>((ref, identifier) {
  return ref.watch(diskProvider).getDisk(identifier);
});

final disksByPoolProvider = Provider.family<List<Disk>, String>((ref, poolId) {
  return ref.watch(diskProvider).getDisksForPool(poolId);
});

final diskTemperatureProvider = Provider.family<DiskTemperature?, String>((
  ref,
  diskName,
) {
  return ref.watch(diskProvider).getDiskTemperature(diskName);
});

final poolTopologyProvider = Provider.family<PoolTopology?, String>((
  ref,
  poolId,
) {
  return ref.watch(diskProvider).getPoolTopology(poolId);
});

final diskSmartDataProvider = Provider.family<Map<String, dynamic>?, String>((
  ref,
  diskName,
) {
  return ref.watch(diskProvider).getDiskSmartData(diskName);
});

// Aggregate statistics providers
final totalDiskCapacityProvider = Provider<int>((ref) {
  return ref.watch(diskProvider).totalCapacity;
});

final diskHealthStatsProvider = Provider<Map<String, int>>((ref) {
  final state = ref.watch(diskProvider);
  return {
    'healthy': state.healthyDisks,
    'warning': state.warningDisks,
    'critical': state.criticalDisks,
    'total': state.totalDisks,
  };
});

final hasUnhealthyDisksProvider = Provider<bool>((ref) {
  return ref.watch(diskProvider).hasUnhealthyDisks;
});
