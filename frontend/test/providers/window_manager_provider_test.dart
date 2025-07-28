import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynas_frontend/models/window_state.dart';
import 'package:mynas_frontend/providers/window_manager_provider.dart';

void main() {
  group('WindowManagerProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has no windows', () {
      final state = container.read(windowManagerProvider);

      expect(state.windows, isEmpty);
      expect(state.nextZIndex, equals(1));
      expect(state.focusedWindowId, isNull);
    });

    test('openWindow adds new window with correct z-index and focus', () {
      final notifier = container.read(windowManagerProvider.notifier);
      const testWindow = WindowState(
        id: 'test-window-1',
        title: 'Test Window 1',
        content: Text('Test Content 1'),
      );

      notifier.openWindow(testWindow);
      final state = container.read(windowManagerProvider);

      expect(state.windows.length, equals(1));
      expect(state.windows.first.id, equals('test-window-1'));
      expect(state.windows.first.zIndex, equals(1));
      expect(state.windows.first.isFocused, isTrue);
      expect(state.focusedWindowId, equals('test-window-1'));
      expect(state.nextZIndex, equals(2));
    });

    test(
      'openWindow focuses existing window instead of creating duplicate',
      () {
        final notifier = container.read(windowManagerProvider.notifier);
        const testWindow = WindowState(
          id: 'test-window-1',
          title: 'Test Window 1',
          content: Text('Test Content 1'),
        );

        // Open first window
        notifier.openWindow(testWindow);

        // Open second window to change focus
        const secondWindow = WindowState(
          id: 'test-window-2',
          title: 'Test Window 2',
          content: Text('Test Content 2'),
        );
        notifier.openWindow(secondWindow);

        // Try to open first window again
        notifier.openWindow(testWindow);
        final state = container.read(windowManagerProvider);

        // Should still have only 2 windows
        expect(state.windows.length, equals(2));

        // First window should be focused now
        final firstWindow = state.windows.firstWhere(
          (w) => w.id == 'test-window-1',
        );
        expect(firstWindow.isFocused, isTrue);
        expect(state.focusedWindowId, equals('test-window-1'));

        // First window should have higher z-index after being refocused
        final secondWindowState = state.windows.firstWhere(
          (w) => w.id == 'test-window-2',
        );
        expect(firstWindow.zIndex > secondWindowState.zIndex, isTrue);
      },
    );

    test('closeWindow removes window from state', () {
      final notifier = container.read(windowManagerProvider.notifier);

      // Add two windows
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-2',
          title: 'Window 2',
          content: Text('Content 2'),
        ),
      );

      // Close first window
      notifier.closeWindow('window-1');
      final state = container.read(windowManagerProvider);

      expect(state.windows.length, equals(1));
      expect(state.windows.first.id, equals('window-2'));
      expect(state.focusedWindowId, equals('window-2'));
    });

    test('closeWindow handles non-existent window gracefully', () {
      final notifier = container.read(windowManagerProvider.notifier);

      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
        ),
      );

      // Try to close non-existent window
      notifier.closeWindow('non-existent');
      final state = container.read(windowManagerProvider);

      expect(state.windows.length, equals(1));
    });

    test('focusWindow updates z-index and focus state correctly', () {
      final notifier = container.read(windowManagerProvider.notifier);

      // Add three windows
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-2',
          title: 'Window 2',
          content: Text('Content 2'),
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-3',
          title: 'Window 3',
          content: Text('Content 3'),
        ),
      );

      // Focus the first window
      notifier.focusWindow('window-1');
      final state = container.read(windowManagerProvider);

      final window1 = state.windows.firstWhere((w) => w.id == 'window-1');
      final window2 = state.windows.firstWhere((w) => w.id == 'window-2');
      final window3 = state.windows.firstWhere((w) => w.id == 'window-3');

      expect(window1.isFocused, isTrue);
      expect(window2.isFocused, isFalse);
      expect(window3.isFocused, isFalse);
      expect(state.focusedWindowId, equals('window-1'));

      // Window 1 should have the highest z-index
      expect(window1.zIndex > window2.zIndex, isTrue);
      expect(window1.zIndex > window3.zIndex, isTrue);
    });

    test(
      'updateWindowPosition and updateWindowSize modify window properties',
      () {
        final notifier = container.read(windowManagerProvider.notifier);

        notifier.openWindow(
          const WindowState(
            id: 'window-1',
            title: 'Original Title',
            content: Text('Content'),
            position: Offset(100, 100),
            size: Size(800, 600),
          ),
        );

        // Update window position
        notifier.updateWindowPosition('window-1', const Offset(200, 200));
        // Update window size
        notifier.updateWindowSize('window-1', const Size(1024, 768));

        final state = container.read(windowManagerProvider);
        final window = state.windows.first;

        expect(window.position, equals(const Offset(200, 200)));
        expect(window.size, equals(const Size(1024, 768)));
        expect(window.title, equals('Original Title')); // Unchanged
      },
    );

    test('minimizeWindow sets isMinimized to true', () {
      final notifier = container.read(windowManagerProvider.notifier);

      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content'),
        ),
      );

      // Verify window is focused before minimize
      var state = container.read(windowManagerProvider);
      expect(state.focusedWindowId, equals('window-1'));
      expect(state.windows.first.isFocused, isTrue);

      notifier.minimizeWindow('window-1');
      state = container.read(windowManagerProvider);
      final window = state.windows.first;

      expect(window.isMinimized, isTrue);
      expect(window.isFocused, isFalse);
      expect(state.focusedWindowId, isNull);
    });

    test('maximizeWindow toggles maximize state', () {
      final notifier = container.read(windowManagerProvider.notifier);

      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content'),
          isMaximized: false,
        ),
      );

      // Maximize
      notifier.maximizeWindow('window-1');
      var state = container.read(windowManagerProvider);
      expect(state.windows.first.isMaximized, isTrue);

      // Toggle back
      notifier.maximizeWindow('window-1');
      state = container.read(windowManagerProvider);
      expect(state.windows.first.isMaximized, isFalse);
    });

    test('restoreWindow restores minimized window', () {
      final notifier = container.read(windowManagerProvider.notifier);

      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content'),
        ),
      );

      // Minimize then restore
      notifier.minimizeWindow('window-1');
      notifier.restoreWindow('window-1');

      final state = container.read(windowManagerProvider);
      final window = state.windows.first;

      expect(window.isMinimized, isFalse);
      expect(window.isFocused, isTrue);
      expect(state.focusedWindowId, equals('window-1'));
    });

    test('closeAll removes all windows', () {
      final notifier = container.read(windowManagerProvider.notifier);

      // Add multiple windows
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-2',
          title: 'Window 2',
          content: Text('Content 2'),
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-3',
          title: 'Window 3',
          content: Text('Content 3'),
        ),
      );

      notifier.closeAllWindows();
      final state = container.read(windowManagerProvider);

      expect(state.windows, isEmpty);
      expect(state.focusedWindowId, isNull);
      expect(state.nextZIndex, equals(1)); // Reset
    });

    test('z-index ordering is maintained correctly', () {
      final notifier = container.read(windowManagerProvider.notifier);

      // Open windows in order
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-2',
          title: 'Window 2',
          content: Text('Content 2'),
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-3',
          title: 'Window 3',
          content: Text('Content 3'),
        ),
      );

      // Focus windows in different order
      notifier.focusWindow('window-1');
      notifier.focusWindow('window-3');
      notifier.focusWindow('window-2');

      final state = container.read(windowManagerProvider);
      final windows = state.windows;

      // Window 2 should have the highest z-index (focused last)
      final window2 = windows.firstWhere((w) => w.id == 'window-2');
      expect(
        windows.every((w) => w.id == 'window-2' || w.zIndex < window2.zIndex),
        isTrue,
      );
    });
  });
}
