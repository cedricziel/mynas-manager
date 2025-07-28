import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_desktop/mynas_desktop.dart';
import 'package:mynas_frontend/widgets/desktop/mynas_desktop_area.dart';
import 'package:mynas_frontend/widgets/desktop/mynas_dock.dart';

class DesktopScreen extends ConsumerWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: WindowManager(
        child: Stack(
          children: [
            // Desktop background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),

            // Desktop area with icons
            const MyNASDesktopArea(),

            // Dock at the bottom
            const Positioned(left: 0, right: 0, bottom: 0, child: MyNASDock()),
          ],
        ),
      ),
    );
  }
}
