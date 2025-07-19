import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageScreen extends ConsumerWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Pool',
            onPressed: () {
              // TODO: Implement create pool
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Storage pools and datasets will be displayed here'),
      ),
    );
  }
}