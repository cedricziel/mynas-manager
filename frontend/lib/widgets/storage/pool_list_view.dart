import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../../providers/pool_provider.dart';
import '../../utils/storage_utils.dart';

enum PoolSortField {
  name,
  status,
  capacity,
  used,
  health,
  lastScrub,
}

class PoolListView extends ConsumerStatefulWidget {
  final void Function(Pool pool)? onPoolSelected;
  final void Function(Pool pool)? onPoolAction;

  const PoolListView({
    super.key,
    this.onPoolSelected,
    this.onPoolAction,
  });

  @override
  ConsumerState<PoolListView> createState() => _PoolListViewState();
}

class _PoolListViewState extends ConsumerState<PoolListView> {
  PoolSortField _sortField = PoolSortField.name;
  bool _sortAscending = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Pool> _getSortedAndFilteredPools(List<Pool> pools) {
    // Filter pools based on search query
    List<Pool> filteredPools = pools;
    if (_searchQuery.isNotEmpty) {
      filteredPools = pools.where((pool) {
        return pool.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               pool.status.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort pools
    filteredPools.sort((a, b) {
      int comparison;
      switch (_sortField) {
        case PoolSortField.name:
          comparison = a.name.compareTo(b.name);
          break;
        case PoolSortField.status:
          comparison = a.status.compareTo(b.status);
          break;
        case PoolSortField.capacity:
          comparison = a.size.compareTo(b.size);
          break;
        case PoolSortField.used:
          comparison = a.allocated.compareTo(b.allocated);
          break;
        case PoolSortField.health:
          comparison = a.isHealthy == b.isHealthy ? 0 : (a.isHealthy ? -1 : 1);
          break;
        case PoolSortField.lastScrub:
          // TODO: Implement last scrub comparison when we have the data
          comparison = a.name.compareTo(b.name);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filteredPools;
  }

  void _onSort(PoolSortField field) {
    setState(() {
      if (_sortField == field) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final poolState = ref.watch(poolProvider);
    final theme = Theme.of(context);

    if (poolState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading storage pools...'),
          ],
        ),
      );
    }

    if (poolState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load pools',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              poolState.error!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.read(poolProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (poolState.pools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storage_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No storage pools found',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first storage pool to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to create pool wizard
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Pool'),
            ),
          ],
        ),
      );
    }

    final pools = _getSortedAndFilteredPools(poolState.pools);

    return Column(
      children: [
        // Search and filters toolbar
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search pools...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => ref.read(poolProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh pools',
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Show pool filters
                  },
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter pools',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Pool table
        Expanded(
          child: Card(
            child: Column(
              children: [
                // Table header
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: _buildTableHeader(theme),
                ),
                
                // Table content
                Expanded(
                  child: ListView.builder(
                    itemCount: pools.length,
                    itemBuilder: (context, index) {
                      final pool = pools[index];
                      return _buildPoolRow(pool, theme, index.isEven);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildSortableHeader('Pool Name', PoolSortField.name, flex: 3),
          _buildSortableHeader('Status', PoolSortField.status, flex: 2),
          _buildSortableHeader('Capacity', PoolSortField.capacity, flex: 2),
          _buildSortableHeader('Used', PoolSortField.used, flex: 2),
          _buildSortableHeader('Health', PoolSortField.health, flex: 2),
          const Expanded(flex: 1, child: Text('Actions')),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(String title, PoolSortField field, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => _onSort(field),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_sortField == field) ...[
              const SizedBox(width: 4),
              Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPoolRow(Pool pool, ThemeData theme, bool isEven) {
    final usagePercentage = StorageUtils.calculatePercentage(pool.allocated, pool.size);
    
    return Container(
      decoration: BoxDecoration(
        color: isEven ? theme.colorScheme.surfaceContainerLowest : null,
      ),
      child: InkWell(
        onTap: () => widget.onPoolSelected?.call(pool),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Pool name and path
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pool.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (pool.path != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        pool.path!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Status
              Expanded(
                flex: 2,
                child: _buildStatusChip(pool.status, pool.isHealthy, theme),
              ),
              
              // Capacity
              Expanded(
                flex: 2,
                child: Text(
                  StorageUtils.formatBytes(pool.size),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              
              // Used space with progress bar
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${StorageUtils.formatBytes(pool.allocated)} (${usagePercentage.toStringAsFixed(1)}%)',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: usagePercentage / 100,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getUsageColor(usagePercentage, theme),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Health
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      pool.isHealthy ? Icons.check_circle : Icons.warning,
                      size: 16,
                      color: pool.isHealthy ? Colors.green : theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pool.isHealthy ? 'Healthy' : 'Needs Attention',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: pool.isHealthy ? Colors.green : theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions
              Expanded(
                flex: 1,
                child: PopupMenuButton<String>(
                  onSelected: (action) => _handlePoolAction(pool, action),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'scrub',
                      child: Row(
                        children: [
                          Icon(Icons.cleaning_services, size: 16),
                          SizedBox(width: 8),
                          Text('Run Scrub'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.eject, size: 16),
                          SizedBox(width: 8),
                          Text('Export Pool'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 16),
                          SizedBox(width: 8),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isHealthy, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHealthy 
            ? Colors.green.withOpacity(0.1) 
            : theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHealthy 
              ? Colors.green.withOpacity(0.3) 
              : theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: isHealthy ? Colors.green : theme.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getUsageColor(double percentage, ThemeData theme) {
    if (percentage >= 90) {
      return theme.colorScheme.error;
    } else if (percentage >= 75) {
      return Colors.orange;
    } else {
      return theme.colorScheme.primary;
    }
  }

  void _handlePoolAction(Pool pool, String action) {
    switch (action) {
      case 'scrub':
        _runScrub(pool);
        break;
      case 'export':
        _exportPool(pool);
        break;
      case 'settings':
        widget.onPoolAction?.call(pool);
        break;
    }
  }

  void _runScrub(Pool pool) async {
    try {
      await ref.read(poolProvider.notifier).runScrub(pool.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scrub started for pool "${pool.name}"'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start scrub: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _exportPool(Pool pool) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Pool "${pool.name}"'),
        content: const Text(
          'Are you sure you want to export this pool? This will make it unavailable until it is imported again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement pool export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pool export not implemented yet'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}