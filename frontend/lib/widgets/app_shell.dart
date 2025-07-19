import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;

        if (isWideScreen) {
          return _DesktopLayout(child: child);
        } else {
          return _MobileLayout(child: child);
        }
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final Widget child;

  const _DesktopLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.storage_outlined),
                selectedIcon: Icon(Icons.storage),
                label: Text('Storage'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder_shared_outlined),
                selectedIcon: Icon(Icons.folder_shared),
                label: Text('Shares'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
            selectedIndex: _getSelectedIndex(currentLocation),
            onDestinationSelected: (index) {
              _navigateToIndex(context, index);
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final Widget child;

  const _MobileLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage),
            label: 'Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_shared_outlined),
            selectedIcon: Icon(Icons.folder_shared),
            label: 'Shares',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedIndex: _getSelectedIndex(currentLocation),
        onDestinationSelected: (index) {
          _navigateToIndex(context, index);
        },
      ),
    );
  }
}

int _getSelectedIndex(String location) {
  switch (location) {
    case '/dashboard':
      return 0;
    case '/storage':
      return 1;
    case '/shares':
      return 2;
    case '/settings':
      return 3;
    default:
      return 0;
  }
}

void _navigateToIndex(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go('/dashboard');
      break;
    case 1:
      context.go('/storage');
      break;
    case 2:
      context.go('/shares');
      break;
    case 3:
      context.go('/settings');
      break;
  }
}
