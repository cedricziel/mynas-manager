import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.computer),
            title: const Text('TrueNAS Connection'),
            subtitle: const Text('Configure server connection'),
            onTap: () {
              // TODO: Implement connection settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Appearance'),
            subtitle: const Text('Theme and display settings'),
            onTap: () {
              // TODO: Implement appearance settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Version and information'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'MyNAS Manager',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 MyNAS Manager',
              );
            },
          ),
        ],
      ),
    );
  }
}