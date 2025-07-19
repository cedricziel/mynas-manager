import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/providers/window_manager_provider.dart';
import 'package:mynas_frontend/models/window_state.dart';
import 'package:mynas_frontend/widgets/apps/storage_app.dart';

class Dock extends ConsumerWidget {
  const Dock({super.key});

  void _openStorageApp(WidgetRef ref) {
    final windowManager = ref.read(windowManagerProvider.notifier);
    
    // Check if storage window is already open
    final existingWindows = ref.read(windowManagerProvider).windows
        .where((w) => w.id == 'storage-app');
    final existingWindow = existingWindows.isNotEmpty ? existingWindows.first : null;
    
    if (existingWindow != null) {
      // Focus existing window
      windowManager.focusWindow('storage-app');
      if (existingWindow.isMinimized) {
        windowManager.restoreWindow('storage-app');
      }
      return;
    }
    
    // Create new storage window
    final window = WindowState(
      id: 'storage-app',
      title: 'Storage Manager',
      icon: Icons.storage,
      content: const StorageApp(),
      position: const Offset(100, 100),
      size: const Size(1200, 800),
      minSize: const Size(800, 600),
      canResize: true,
      canClose: true,
      isFocused: true,
    );
    
    windowManager.openWindow(window);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final windowManagerState = ref.watch(windowManagerProvider);
    
    // Get unique apps from open windows
    final openApps = <String, WindowState>{};
    for (final window in windowManagerState.windows) {
      openApps[window.id] = window;
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Storage app launcher
                    _DockItem(
                      icon: Icons.storage,
                      label: 'Storage',
                      onTap: () => _openStorageApp(ref),
                    ),
                    
                    // Static app launcher
                    _DockItem(
                      icon: Icons.apps,
                      label: 'Apps',
                      onTap: () {
                        // TODO: Show app launcher
                      },
                    ),
                    
                    if (openApps.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 40,
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                      const SizedBox(width: 8),
                    ],
                    
                    // Open windows
                    ...openApps.values.map((window) => _DockItem(
                      icon: window.icon ?? Icons.window,
                      label: window.title,
                      isActive: !window.isMinimized,
                      onTap: () {
                        if (window.isMinimized) {
                          ref.read(windowManagerProvider.notifier).restoreWindow(window.id);
                        } else {
                          ref.read(windowManagerProvider.notifier).focusWindow(window.id);
                        }
                      },
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem> 
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: Tooltip(
        message: widget.label,
        preferBelow: false,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _isHovered 
                      ? theme.colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: 24,
                        color: theme.colorScheme.onSurface,
                      ),
                      if (widget.isActive)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}