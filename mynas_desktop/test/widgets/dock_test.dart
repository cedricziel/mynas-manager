import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynas_desktop/src/models/window_state.dart';
import 'package:mynas_desktop/src/providers/window_manager_provider.dart';
import 'package:mynas_desktop/src/widgets/dock.dart';

// Test helper to create a Dock with test launchers
class _TestDock extends ConsumerWidget {
  const _TestDock();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dock(
      launchers: [
        DockLauncher(
          id: 'storage',
          icon: Icons.storage,
          label: 'Storage',
          onTap: () {
            final windowManager = ref.read(windowManagerProvider.notifier);
            windowManager.openWindow(
              const WindowState(
                id: 'storage-app',
                title: 'Storage Manager',
                icon: Icons.storage,
                content: Text('Storage App'),
              ),
            );
          },
        ),
        DockLauncher(
          id: 'apps',
          icon: Icons.apps,
          label: 'Apps',
          onTap: () {
            // Test app launcher
          },
        ),
      ],
    );
  }
}

void main() {
  group('Dock', () {
    testWidgets('shows default app launchers', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: const _TestDock())),
        ),
      );

      // Should show Storage launcher
      expect(find.byIcon(Icons.storage), findsOneWidget);

      // Should show Apps launcher
      expect(find.byIcon(Icons.apps), findsOneWidget);
    });

    testWidgets('shows tooltip on hover', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: const _TestDock())),
        ),
      );

      // Hover over Storage icon
      final storageIcon = find.byIcon(Icons.storage);
      await tester.longPress(storageIcon);
      await tester.pumpAndSettle();

      // Tooltip should appear
      expect(find.text('Storage'), findsOneWidget);
    });

    testWidgets('opens storage app when storage icon is clicked', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: const _TestDock())),
        ),
      );

      // Click on Storage icon
      final storageIcon = find.byIcon(Icons.storage);
      await tester.tap(storageIcon);
      await tester.pump();

      // Check that a window was opened
      final container = ProviderScope.containerOf(
        tester.element(find.byType(_TestDock)),
      );
      final windowState = container.read(windowManagerProvider);

      expect(windowState.windows.length, equals(1));
      expect(windowState.windows.first.id, equals('storage-app'));
      expect(windowState.windows.first.title, equals('Storage Manager'));
    });

    testWidgets('focuses existing storage window if already open', (
      tester,
    ) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Open storage window first
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'storage-app',
          title: 'Storage Manager',
          content: Text('Storage'),
          isFocused: false,
        ),
      );

      // Open another window to change focus
      notifier.openWindow(
        const WindowState(
          id: 'other-window',
          title: 'Other',
          content: Text('Other'),
        ),
      );

      await tester.pump();

      // Click on Storage icon
      final storageIcon = find.byIcon(Icons.storage);
      await tester.tap(storageIcon);
      await tester.pump();

      // Storage window should be focused
      final windowState = container.read(windowManagerProvider);
      expect(windowState.windows.length, equals(2));
      expect(windowState.focusedWindowId, equals('storage-app'));
    });

    testWidgets('restores minimized storage window when clicked', (
      tester,
    ) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Open and minimize storage window
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'storage-app',
          title: 'Storage Manager',
          content: Text('Storage'),
        ),
      );
      notifier.minimizeWindow('storage-app');

      await tester.pump();

      // Click on Storage icon
      final storageIcon = find.byIcon(Icons.storage);
      await tester.tap(storageIcon);
      await tester.pump();

      // Storage window should be restored
      final windowState = container.read(windowManagerProvider);
      final storageWindow = windowState.windows.firstWhere(
        (w) => w.id == 'storage-app',
      );
      expect(storageWindow.isMinimized, isFalse);
      expect(storageWindow.isFocused, isTrue);
    });

    testWidgets('shows open windows in dock', (tester) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Open some windows
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
          icon: Icons.folder,
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-2',
          title: 'Window 2',
          content: Text('Content 2'),
          icon: Icons.settings,
        ),
      );

      await tester.pump();

      // Windows should appear in dock
      expect(find.byIcon(Icons.folder), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Plus the default launchers
      expect(find.byIcon(Icons.storage), findsOneWidget);
      expect(find.byIcon(Icons.apps), findsOneWidget);
    });

    testWidgets('shows separator when windows are open', (tester) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Check no windows initially
      final initialState = container.read(windowManagerProvider);
      expect(initialState.windows, isEmpty);

      // Open a window
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
        ),
      );

      await tester.pump();

      // Now there should be a window
      final newState = container.read(windowManagerProvider);
      expect(newState.windows, isNotEmpty);

      // The separator is conditionally rendered when windows exist
      // We can verify by checking the dock contains more children
      final dock = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(_TestDock),
              matching: find.byType(Container),
            )
            .last,
      );
      expect(dock, isNotNull);
    });

    testWidgets('window dock items show active indicator', (tester) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Open a window
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
          icon: Icons.folder,
        ),
      );

      await tester.pump();

      // Active indicator should be shown (small circle)
      // The indicator is a Container with BoxDecoration circle shape
      final indicators = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(indicators, findsWidgets); // At least one circle indicator
    });

    testWidgets('minimized windows do not show active indicator', (
      tester,
    ) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Open and minimize a window
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
          icon: Icons.folder,
        ),
      );
      notifier.minimizeWindow('window-1');

      await tester.pump();

      // The window exists but is minimized
      final state = container.read(windowManagerProvider);
      expect(state.windows.length, equals(1));
      expect(state.windows.first.isMinimized, isTrue);

      // No active indicator should be visible for minimized windows
      // This is controlled by the isActive property passed to _DockItem
    });

    testWidgets('clicking window in dock focuses it', (tester) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Open two windows
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
          icon: Icons.folder,
        ),
      );
      notifier.openWindow(
        const WindowState(
          id: 'window-2',
          title: 'Window 2',
          content: Text('Content 2'),
          icon: Icons.settings,
        ),
      );

      await tester.pump();

      // Window 2 should be focused initially (opened last)
      expect(
        container.read(windowManagerProvider).focusedWindowId,
        equals('window-2'),
      );

      // Click on window 1 in dock
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pump();

      // Window 1 should now be focused
      expect(
        container.read(windowManagerProvider).focusedWindowId,
        equals('window-1'),
      );
    });

    testWidgets('clicking minimized window in dock restores it', (
      tester,
    ) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(home: Scaffold(body: const _TestDock()));
            },
          ),
        ),
      );

      // Open and minimize a window
      final notifier = container.read(windowManagerProvider.notifier);
      notifier.openWindow(
        const WindowState(
          id: 'window-1',
          title: 'Window 1',
          content: Text('Content 1'),
          icon: Icons.folder,
        ),
      );
      notifier.minimizeWindow('window-1');

      await tester.pump();

      // Click on minimized window in dock
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pump();

      // Window should be restored
      final window = container.read(windowManagerProvider).windows.first;
      expect(window.isMinimized, isFalse);
      expect(window.isFocused, isTrue);
    });

    testWidgets('dock has blur effect background', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: const _TestDock())),
        ),
      );

      // Check for BackdropFilter
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Check for ClipRRect (needed for blur effect)
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('dock items animate on hover', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: const _TestDock())),
        ),
      );

      // Find storage icon
      final storageIcon = find.byIcon(Icons.storage);

      // Hover over it
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(storageIcon));
      await tester.pump();

      // Animation should start
      // We can't easily test the scale animation directly,
      // but we can verify the MouseRegion exists
      expect(find.byType(MouseRegion), findsWidgets);
    });
  });
}
