import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_desktop/src/models/window_state.dart';
import 'package:mynas_desktop/src/providers/window_manager_provider.dart';
import 'package:mynas_desktop/src/widgets/resizable_window.dart';

class WindowWidget extends ConsumerStatefulWidget {
  final WindowState windowState;

  const WindowWidget({super.key, required this.windowState});

  @override
  ConsumerState<WindowWidget> createState() => _WindowWidgetState();
}

class _WindowWidgetState extends ConsumerState<WindowWidget> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final window = widget.windowState;

    if (window.isMinimized) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;
    final isMaximized = window.isMaximized;

    final windowContent = GestureDetector(
      onTapDown: (_) => _focusWindow(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: isMaximized
              ? BorderRadius.zero
              : BorderRadius.circular(12),
          boxShadow: isMaximized || !window.isFocused
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: isMaximized
              ? BorderRadius.zero
              : BorderRadius.circular(12),
          child: Column(
            children: [
              _WindowTitleBar(
                window: window,
                onDragStart: _onDragStart,
                onDragUpdate: _onDragUpdate,
                onDragEnd: _onDragEnd,
              ),
              Expanded(child: window.content),
            ],
          ),
        ),
      ),
    );

    if (isMaximized) {
      return Positioned(
        left: 0,
        top: 0,
        width: screenSize.width,
        height: screenSize.height,
        child: windowContent,
      );
    }

    return ResizableWindow(windowState: window, child: windowContent);
  }

  void _focusWindow() {
    ref.read(windowManagerProvider.notifier).focusWindow(widget.windowState.id);
  }

  void _onDragStart(DragStartDetails details) {
    if (widget.windowState.isMaximized) return;
    _isDragging = true;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || widget.windowState.isMaximized) return;

    final newPosition = Offset(
      widget.windowState.position.dx + details.delta.dx,
      widget.windowState.position.dy + details.delta.dy,
    );

    ref
        .read(windowManagerProvider.notifier)
        .updateWindowPosition(widget.windowState.id, newPosition);
  }

  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
  }
}

class _WindowTitleBar extends ConsumerWidget {
  final WindowState window;
  final Function(DragStartDetails) onDragStart;
  final Function(DragUpdateDetails) onDragUpdate;
  final Function(DragEndDetails) onDragEnd;

  const _WindowTitleBar({
    required this.window,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onPanStart: onDragStart,
      onPanUpdate: onDragUpdate,
      onPanEnd: onDragEnd,
      onDoubleTap: () {
        if (!window.canResize) return;
        ref.read(windowManagerProvider.notifier).maximizeWindow(window.id);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: window.isFocused
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            if (window.icon != null) ...[
              const SizedBox(width: 12),
              Icon(
                window.icon,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                window.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: window.isFocused
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _WindowButton(
              icon: Icons.remove,
              onPressed: () => ref
                  .read(windowManagerProvider.notifier)
                  .minimizeWindow(window.id),
              isEnabled: window.isFocused,
            ),
            if (window.canResize)
              _WindowButton(
                icon: window.isMaximized
                    ? Icons.filter_none
                    : Icons.crop_square,
                onPressed: () => ref
                    .read(windowManagerProvider.notifier)
                    .maximizeWindow(window.id),
                isEnabled: window.isFocused,
              ),
            if (window.canClose)
              _WindowButton(
                icon: Icons.close,
                onPressed: () => ref
                    .read(windowManagerProvider.notifier)
                    .closeWindow(window.id),
                isEnabled: window.isFocused,
                isClose: true,
              ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    required this.isEnabled,
    this.isClose = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: isEnabled ? onPressed : null,
        style: IconButton.styleFrom(
          foregroundColor: isClose
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.3),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}
