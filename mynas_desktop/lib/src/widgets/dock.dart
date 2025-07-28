import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_desktop/src/providers/window_manager_provider.dart';
import 'package:mynas_desktop/src/models/window_state.dart';

/// A launcher item for the dock
class DockLauncher {
  final String id;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DockLauncher({
    required this.id,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// A generic dock widget that displays app launchers and open windows
class Dock extends ConsumerWidget {
  final List<DockLauncher> launchers;

  const Dock({super.key, this.launchers = const []});

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
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App launchers
                    ...launchers.map(
                      (launcher) => _DockItem(
                        icon: launcher.icon,
                        label: launcher.label,
                        onTap: launcher.onTap,
                      ),
                    ),

                    if (openApps.isNotEmpty && launchers.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 40,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Open windows
                    ...openApps.values.map(
                      (window) => _DockItem(
                        icon: window.icon ?? Icons.window,
                        label: window.title,
                        isActive: !window.isMinimized,
                        onTap: () {
                          if (window.isMinimized) {
                            ref
                                .read(windowManagerProvider.notifier)
                                .restoreWindow(window.id);
                          } else {
                            ref
                                .read(windowManagerProvider.notifier)
                                .focusWindow(window.id);
                          }
                        },
                      ),
                    ),
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
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
                        ? theme.colorScheme.primary.withValues(alpha: 0.2)
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
