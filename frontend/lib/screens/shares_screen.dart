import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharesScreen extends ConsumerWidget {
  const SharesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shares'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Share',
            onPressed: () {
              // TODO: Implement create share
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Network shares will be displayed here'),
      ),
    );
  }
}