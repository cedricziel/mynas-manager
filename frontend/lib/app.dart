import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mynas_frontend/screens/dashboard_screen.dart';
import 'package:mynas_frontend/screens/storage_screen.dart';
import 'package:mynas_frontend/screens/shares_screen.dart';
import 'package:mynas_frontend/screens/settings_screen.dart';
import 'package:mynas_frontend/widgets/app_shell.dart';

class MyNasApp extends StatelessWidget {
  const MyNasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyNAS Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }

  static final _router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/storage',
            builder: (context, state) => const StorageScreen(),
          ),
          GoRoute(
            path: '/shares',
            builder: (context, state) => const SharesScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}