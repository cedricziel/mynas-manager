import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../providers/pool_provider.dart';
import '../widgets/storage/pool_health_cards.dart';
import '../widgets/storage/pool_list_view.dart';
import '../widgets/storage/pool_detail_panel.dart';

class StorageScreen extends ConsumerStatefulWidget {
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends ConsumerState<StorageScreen> {
  Pool? _selectedPool;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(poolProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Pool',
            onPressed: () {
              // TODO: Implement create pool wizard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pool creation wizard coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: _selectedPool != null ? _buildDetailView() : _buildOverviewLayout(),
    );
  }

  Widget _buildOverviewLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health cards section
          const PoolHealthCards(),

          const SizedBox(height: 32),

          // Pool list section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Storage Pools',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: PoolListView(
                    onPoolSelected: (pool) {
                      setState(() {
                        _selectedPool = pool;
                      });
                    },
                    onPoolAction: (pool) {
                      // Handle pool actions from context menu
                      setState(() {
                        _selectedPool = pool;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: PoolDetailPanel(
        pool: _selectedPool!,
        onClose: () {
          setState(() {
            _selectedPool = null;
          });
        },
      ),
    );
  }
}
