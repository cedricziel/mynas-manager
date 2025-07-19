import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/models/window_state.dart';

final windowManagerProvider = StateNotifierProvider<WindowManagerNotifier, WindowManagerState>((ref) {
  return WindowManagerNotifier();
});

class WindowManagerState {
  final List<WindowState> windows;
  final int nextZIndex;
  final String? focusedWindowId;

  const WindowManagerState({
    this.windows = const [],
    this.nextZIndex = 1,
    this.focusedWindowId,
  });

  WindowManagerState copyWith({
    List<WindowState>? windows,
    int? nextZIndex,
    String? focusedWindowId,
  }) {
    return WindowManagerState(
      windows: windows ?? this.windows,
      nextZIndex: nextZIndex ?? this.nextZIndex,
      focusedWindowId: focusedWindowId ?? this.focusedWindowId,
    );
  }
}

class WindowManagerNotifier extends StateNotifier<WindowManagerState> {
  WindowManagerNotifier() : super(const WindowManagerState());

  void openWindow({
    required String id,
    required String title,
    required Widget content,
    IconData? icon,
    Size? size,
    Offset? position,
    bool canResize = true,
    bool canClose = true,
  }) {
    // Check if window already exists
    final existingIndex = state.windows.indexWhere((w) => w.id == id);
    if (existingIndex != -1) {
      // Focus existing window
      focusWindow(id);
      return;
    }

    // Calculate center position if not provided
    final windowSize = size ?? const Size(800, 600);
    // Use a default screen size for now - in a real app, this would come from MediaQuery
    const screenSize = Size(1920, 1080);
    final centerPosition = position ?? Offset(
      (screenSize.width - windowSize.width) / 2,
      (screenSize.height - windowSize.height) / 2,
    );

    final newWindow = WindowState(
      id: id,
      title: title,
      content: content,
      icon: icon,
      size: windowSize,
      position: centerPosition,
      zIndex: state.nextZIndex,
      isFocused: true,
      canResize: canResize,
      canClose: canClose,
    );

    // Unfocus all other windows
    final updatedWindows = state.windows.map((w) => 
      w.copyWith(isFocused: false)
    ).toList();

    state = state.copyWith(
      windows: [...updatedWindows, newWindow],
      nextZIndex: state.nextZIndex + 1,
      focusedWindowId: id,
    );
  }

  void closeWindow(String id) {
    state = state.copyWith(
      windows: state.windows.where((w) => w.id != id).toList(),
      focusedWindowId: state.focusedWindowId == id ? null : state.focusedWindowId,
    );
  }

  void minimizeWindow(String id) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(isMinimized: true, isFocused: false);
      }
      return w;
    }).toList();

    state = state.copyWith(
      windows: updatedWindows,
      focusedWindowId: state.focusedWindowId == id ? null : state.focusedWindowId,
    );
  }

  void maximizeWindow(String id) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(isMaximized: !w.isMaximized);
      }
      return w;
    }).toList();

    state = state.copyWith(windows: updatedWindows);
  }

  void restoreWindow(String id) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(
          isMinimized: false,
          isMaximized: false,
          isFocused: true,
          zIndex: state.nextZIndex,
        );
      }
      return w.copyWith(isFocused: false);
    }).toList();

    state = state.copyWith(
      windows: updatedWindows,
      nextZIndex: state.nextZIndex + 1,
      focusedWindowId: id,
    );
  }

  void focusWindow(String id) {
    final windowIndex = state.windows.indexWhere((w) => w.id == id);
    if (windowIndex == -1) return;

    final window = state.windows[windowIndex];
    if (window.isMinimized) {
      restoreWindow(id);
      return;
    }

    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(isFocused: true, zIndex: state.nextZIndex);
      }
      return w.copyWith(isFocused: false);
    }).toList();

    state = state.copyWith(
      windows: updatedWindows,
      nextZIndex: state.nextZIndex + 1,
      focusedWindowId: id,
    );
  }

  void updateWindowPosition(String id, Offset position) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(position: position);
      }
      return w;
    }).toList();

    state = state.copyWith(windows: updatedWindows);
  }

  void updateWindowSize(String id, Size size) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        // Respect min/max size constraints
        var newSize = size;
        if (w.minSize != null) {
          newSize = Size(
            newSize.width < w.minSize!.width ? w.minSize!.width : newSize.width,
            newSize.height < w.minSize!.height ? w.minSize!.height : newSize.height,
          );
        }
        if (w.maxSize != null) {
          newSize = Size(
            newSize.width > w.maxSize!.width ? w.maxSize!.width : newSize.width,
            newSize.height > w.maxSize!.height ? w.maxSize!.height : newSize.height,
          );
        }
        return w.copyWith(size: newSize);
      }
      return w;
    }).toList();

    state = state.copyWith(windows: updatedWindows);
  }

  void closeAllWindows() {
    state = const WindowManagerState();
  }
}