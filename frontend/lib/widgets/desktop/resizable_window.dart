import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/models/window_state.dart';
import 'package:mynas_frontend/providers/window_manager_provider.dart';

class ResizableWindow extends ConsumerWidget {
  final WindowState windowState;
  final Widget child;

  const ResizableWindow({
    super.key,
    required this.windowState,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final window = windowState;
    
    if (!window.canResize || window.isMaximized) {
      return Positioned(
        left: window.position.dx,
        top: window.position.dy,
        width: window.size.width,
        height: window.size.height,
        child: child,
      );
    }

    return TransformableBox(
      rect: Rect.fromLTWH(
        window.position.dx,
        window.position.dy,
        window.size.width,
        window.size.height,
      ),
      clampingRect: Rect.fromLTWH(
        0,
        0,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      constraints: BoxConstraints(
        minWidth: window.minSize?.width ?? 400,
        minHeight: window.minSize?.height ?? 300,
        maxWidth: window.maxSize?.width ?? double.infinity,
        maxHeight: window.maxSize?.height ?? double.infinity,
      ),
      resizable: true,
      draggable: false, // We handle dragging in the title bar
      visibleHandles: const {
        HandlePosition.topLeft,
        HandlePosition.topRight,
        HandlePosition.bottomLeft,
        HandlePosition.bottomRight,
        HandlePosition.left,
        HandlePosition.right,
        HandlePosition.top,
        HandlePosition.bottom,
      },
      enabledHandles: const {
        HandlePosition.topLeft,
        HandlePosition.topRight,
        HandlePosition.bottomLeft,
        HandlePosition.bottomRight,
        HandlePosition.left,
        HandlePosition.right,
        HandlePosition.top,
        HandlePosition.bottom,
      },
      onResizeStart: (handle, details) {
        ref.read(windowManagerProvider.notifier).focusWindow(window.id);
      },
      onResizeUpdate: (result, details) {
        ref.read(windowManagerProvider.notifier).updateWindowPosition(
          window.id,
          Offset(result.rect.left, result.rect.top),
        );
        ref.read(windowManagerProvider.notifier).updateWindowSize(
          window.id,
          Size(result.rect.width, result.rect.height),
        );
      },
      contentBuilder: (context, rect, flip) {
        return child;
      },
    );
  }
}