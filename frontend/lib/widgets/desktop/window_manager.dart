import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/providers/window_manager_provider.dart';
import 'package:mynas_frontend/widgets/desktop/window_widget.dart';

class WindowManager extends ConsumerWidget {
  final Widget child;

  const WindowManager({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowManagerState = ref.watch(windowManagerProvider);
    
    // Sort windows by z-index to ensure proper stacking order
    final sortedWindows = List.from(windowManagerState.windows)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return Stack(
      children: [
        // Background content (desktop, etc.)
        child,
        
        // Windows
        ...sortedWindows.map((window) => 
          WindowWidget(
            key: ValueKey(window.id),
            windowState: window,
          ),
        ),
      ],
    );
  }
}