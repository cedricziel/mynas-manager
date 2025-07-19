import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../services/rpc_client.dart';

final _logger = Logger('PoolProvider');

// Pool state management
class PoolState {
  final List<Pool> pools;
  final Map<String, List<Dataset>> datasetsByPool;
  final Map<String, List<PoolScrubTask>> scrubTasksByPool;
  final Map<String, PoolResilver?> resilverByPool;
  final Map<String, List<PoolScrub>> scrubHistoryByPool;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const PoolState({
    this.pools = const [],
    this.datasetsByPool = const {},
    this.scrubTasksByPool = const {},
    this.resilverByPool = const {},
    this.scrubHistoryByPool = const {},
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  PoolState copyWith({
    List<Pool>? pools,
    Map<String, List<Dataset>>? datasetsByPool,
    Map<String, List<PoolScrubTask>>? scrubTasksByPool,
    Map<String, PoolResilver?>? resilverByPool,
    Map<String, List<PoolScrub>>? scrubHistoryByPool,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return PoolState(
      pools: pools ?? this.pools,
      datasetsByPool: datasetsByPool ?? this.datasetsByPool,
      scrubTasksByPool: scrubTasksByPool ?? this.scrubTasksByPool,
      resilverByPool: resilverByPool ?? this.resilverByPool,
      scrubHistoryByPool: scrubHistoryByPool ?? this.scrubHistoryByPool,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Helper getters
  Pool? getPool(String poolId) {
    try {
      return pools.firstWhere((pool) => pool.id == poolId);
    } catch (e) {
      return null;
    }
  }

  List<Dataset> getDatasetsForPool(String poolId) {
    return datasetsByPool[poolId] ?? [];
  }

  List<PoolScrubTask> getScrubTasksForPool(String poolId) {
    return scrubTasksByPool[poolId] ?? [];
  }

  PoolResilver? getResilverForPool(String poolId) {
    return resilverByPool[poolId];
  }

  List<PoolScrub> getScrubHistoryForPool(String poolId) {
    return scrubHistoryByPool[poolId] ?? [];
  }

  // Aggregate statistics
  int get totalPools => pools.length;
  
  int get healthyPools => pools.where((pool) => pool.isHealthy).length;
  
  int get totalCapacity => pools.fold(0, (sum, pool) => sum + pool.size);
  
  int get totalAllocated => pools.fold(0, (sum, pool) => sum + pool.allocated);
  
  double get overallUsagePercentage {
    if (totalCapacity == 0) return 0.0;
    return (totalAllocated / totalCapacity) * 100;
  }

  List<Pool> get unhealthyPools => pools.where((pool) => !pool.isHealthy).toList();
  
  bool get hasUnhealthyPools => unhealthyPools.isNotEmpty;
}

// Pool provider
class PoolNotifier extends StateNotifier<PoolState> {
  final RpcClient _rpcClient;

  PoolNotifier(this._rpcClient) : super(const PoolState()) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await refresh();
  }

  // Refresh all pool data
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      _logger.info('Refreshing pool data');
      
      // Load pools first
      final poolsData = await _rpcClient.listPools();
      final pools = poolsData.map<Pool>((data) => Pool.fromJson(data as Map<String, dynamic>)).toList();
      
      // Load related data for each pool in parallel
      final futures = pools.map((pool) => _loadPoolDetails(pool.id));
      await Future.wait(futures);
      
      state = state.copyWith(
        pools: pools,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
      
      _logger.info('Pool data refreshed successfully: ${pools.length} pools');
    } catch (e, stackTrace) {
      _logger.severe('Failed to refresh pool data: $e', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load pool data: $e',
      );
    }
  }

  // Load detailed information for a specific pool
  Future<void> _loadPoolDetails(String poolId) async {
    try {
      // Load datasets for this pool
      final datasetsData = await _rpcClient.sendRequest<List<dynamic>>('dataset.list', {'poolId': poolId});
      final datasets = datasetsData.map<Dataset>((data) => Dataset.fromJson(data as Map<String, dynamic>)).toList();
      
      // Load scrub tasks for this pool
      final scrubTasksData = await _rpcClient.sendRequest<List<dynamic>>('pool.scrub.list', {'poolId': poolId});
      final scrubTasks = scrubTasksData.map<PoolScrubTask>((data) => PoolScrubTask.fromJson(data as Map<String, dynamic>)).toList();
      
      // Load resilver status for this pool
      PoolResilver? resilver;
      try {
        final resilverData = await _rpcClient.sendRequest<Map<String, dynamic>?>('pool.resilver.status', {'poolId': poolId});
        if (resilverData != null) {
          resilver = PoolResilver.fromJson(resilverData);
        }
      } catch (e) {
        // Resilver might not exist, which is fine
        _logger.fine('No resilver active for pool $poolId: $e');
      }
      
      // Load recent scrub history
      final scrubHistoryData = await _rpcClient.sendRequest<List<dynamic>>('pool.scrub.history', {'poolId': poolId, 'limit': 10});
      final scrubHistory = scrubHistoryData.map<PoolScrub>((data) => PoolScrub.fromJson(data as Map<String, dynamic>)).toList();

      // Update state with loaded data
      final newDatasetsByPool = Map<String, List<Dataset>>.from(state.datasetsByPool);
      newDatasetsByPool[poolId] = datasets;
      
      final newScrubTasksByPool = Map<String, List<PoolScrubTask>>.from(state.scrubTasksByPool);
      newScrubTasksByPool[poolId] = scrubTasks;
      
      final newResilverByPool = Map<String, PoolResilver?>.from(state.resilverByPool);
      newResilverByPool[poolId] = resilver;
      
      final newScrubHistoryByPool = Map<String, List<PoolScrub>>.from(state.scrubHistoryByPool);
      newScrubHistoryByPool[poolId] = scrubHistory;

      state = state.copyWith(
        datasetsByPool: newDatasetsByPool,
        scrubTasksByPool: newScrubTasksByPool,
        resilverByPool: newResilverByPool,
        scrubHistoryByPool: newScrubHistoryByPool,
      );
    } catch (e) {
      _logger.warning('Failed to load details for pool $poolId: $e');
    }
  }

  // Run a manual scrub on a pool
  Future<void> runScrub(String poolId) async {
    try {
      _logger.info('Starting manual scrub for pool $poolId');
      await _rpcClient.sendRequest('pool.scrub.run', {'poolId': poolId});
      
      // Refresh pool details to show updated scrub status
      await _loadPoolDetails(poolId);
    } catch (e) {
      _logger.severe('Failed to start scrub for pool $poolId: $e');
      rethrow;
    }
  }

  // Create a new scrub task
  Future<void> createScrubTask({
    required String poolId,
    required String schedule,
    String? description,
    bool enabled = true,
  }) async {
    try {
      _logger.info('Creating scrub task for pool $poolId');
      await _rpcClient.sendRequest('pool.scrub.create', {
        'poolId': poolId,
        'schedule': schedule,
        'description': description ?? 'Automated scrub task',
        'enabled': enabled,
      });
      
      // Refresh pool details to show new task
      await _loadPoolDetails(poolId);
    } catch (e) {
      _logger.severe('Failed to create scrub task for pool $poolId: $e');
      rethrow;
    }
  }

  // Update an existing scrub task
  Future<void> updateScrubTask(String taskId, Map<String, dynamic> updates) async {
    try {
      _logger.info('Updating scrub task $taskId');
      await _rpcClient.sendRequest('pool.scrub.update', {'id': taskId, ...updates});
      
      // Refresh all pool data to update the task
      await refresh();
    } catch (e) {
      _logger.severe('Failed to update scrub task $taskId: $e');
      rethrow;
    }
  }

  // Delete a scrub task
  Future<void> deleteScrubTask(String taskId) async {
    try {
      _logger.info('Deleting scrub task $taskId');
      await _rpcClient.sendRequest('pool.scrub.delete', {'id': taskId});
      
      // Refresh all pool data to remove the task
      await refresh();
    } catch (e) {
      _logger.severe('Failed to delete scrub task $taskId: $e');
      rethrow;
    }
  }

  // Create a new dataset
  Future<void> createDataset({
    required String pool,
    required String name,
    Map<String, dynamic>? properties,
  }) async {
    try {
      _logger.info('Creating dataset $name in pool $pool');
      await _rpcClient.createDataset(
        pool: pool,
        name: name,
        properties: properties,
      );
      
      // Refresh pool details to show new dataset
      await _loadPoolDetails(pool);
    } catch (e) {
      _logger.severe('Failed to create dataset $name: $e');
      rethrow;
    }
  }

  // Get detailed pool status
  Future<Map<String, dynamic>> getPoolStatus(String poolId) async {
    try {
      return await _rpcClient.sendRequest('pool.status', {'poolId': poolId});
    } catch (e) {
      _logger.severe('Failed to get pool status for $poolId: $e');
      rethrow;
    }
  }

  // Get pool usage statistics
  Future<Map<String, dynamic>> getPoolUsage(String poolId) async {
    try {
      return await _rpcClient.sendRequest('pool.usage', {'poolId': poolId});
    } catch (e) {
      _logger.severe('Failed to get pool usage for $poolId: $e');
      rethrow;
    }
  }
}

// Provider instances
final poolProvider = StateNotifierProvider<PoolNotifier, PoolState>((ref) {
  final rpcClient = ref.watch(rpcClientProvider);
  return PoolNotifier(rpcClient);
});

// Convenience providers for specific data
final poolsListProvider = Provider<List<Pool>>((ref) {
  return ref.watch(poolProvider).pools;
});

final healthyPoolsProvider = Provider<List<Pool>>((ref) {
  return ref.watch(poolProvider).pools.where((pool) => pool.isHealthy).toList();
});

final unhealthyPoolsProvider = Provider<List<Pool>>((ref) {
  return ref.watch(poolProvider).unhealthyPools;
});

final poolByIdProvider = Provider.family<Pool?, String>((ref, poolId) {
  return ref.watch(poolProvider).getPool(poolId);
});

final datasetsByPoolProvider = Provider.family<List<Dataset>, String>((ref, poolId) {
  return ref.watch(poolProvider).getDatasetsForPool(poolId);
});

final scrubTasksByPoolProvider = Provider.family<List<PoolScrubTask>, String>((ref, poolId) {
  return ref.watch(poolProvider).getScrubTasksForPool(poolId);
});

final resilverByPoolProvider = Provider.family<PoolResilver?, String>((ref, poolId) {
  return ref.watch(poolProvider).getResilverForPool(poolId);
});

final scrubHistoryByPoolProvider = Provider.family<List<PoolScrub>, String>((ref, poolId) {
  return ref.watch(poolProvider).getScrubHistoryForPool(poolId);
});

// Aggregate statistics providers
final totalCapacityProvider = Provider<int>((ref) {
  return ref.watch(poolProvider).totalCapacity;
});

final totalAllocatedProvider = Provider<int>((ref) {
  return ref.watch(poolProvider).totalAllocated;
});

final overallUsagePercentageProvider = Provider<double>((ref) {
  return ref.watch(poolProvider).overallUsagePercentage;
});

final hasUnhealthyPoolsProvider = Provider<bool>((ref) {
  return ref.watch(poolProvider).hasUnhealthyPools;
});