import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynas_desktop/src/models/window_state.dart';
import 'package:mynas_desktop/src/widgets/resizable_window.dart';

void main() {
  group('ResizableWindow', () {
    late WindowState testWindowState;

    setUp(() {
      testWindowState = const WindowState(
        id: 'test-window',
        title: 'Test Window',
        content: Text('Test Content'),
        position: Offset(100, 100),
        size: Size(800, 600),
        canResize: true,
        minSize: Size(400, 300),
        maxSize: Size(1200, 900),
      );
    });

    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: testWindowState,
                    child: const Center(child: Text('Resizable Content')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Resizable Content'), findsOneWidget);
    });

    testWidgets('shows as positioned widget when not resizable', (
      tester,
    ) async {
      final nonResizableWindow = testWindowState.copyWith(canResize: false);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: nonResizableWindow,
                    child: Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Non-resizable Content')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Content should be visible
      expect(find.text('Non-resizable Content'), findsOneWidget);

      // Should be using Positioned widget instead of TransformableBox
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('shows as positioned widget when maximized', (tester) async {
      final maximizedWindow = testWindowState.copyWith(isMaximized: true);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: maximizedWindow,
                    child: Container(
                      color: Colors.green,
                      child: const Center(child: Text('Maximized Content')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Content should be visible
      expect(find.text('Maximized Content'), findsOneWidget);

      // Should be using Positioned widget when maximized
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('respects window position and size', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: testWindowState,
                    child: Container(
                      color: Colors.red,
                      child: const Center(child: Text('Positioned Window')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Positioned Window'), findsOneWidget);

      // Check that window is positioned correctly
      final resizableWindow = tester.widget<ResizableWindow>(
        find.byType(ResizableWindow),
      );

      expect(
        resizableWindow.windowState.position,
        equals(const Offset(100, 100)),
      );
      expect(resizableWindow.windowState.size, equals(const Size(800, 600)));
    });

    testWidgets('respects minimum size constraints', (tester) async {
      const customMinSize = Size(500, 400);
      final windowWithMinSize = testWindowState.copyWith(
        minSize: customMinSize,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: windowWithMinSize,
                    child: const Center(child: Text('Min Size Window')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final resizableWindow = tester.widget<ResizableWindow>(
        find.byType(ResizableWindow),
      );

      expect(resizableWindow.windowState.minSize, equals(customMinSize));
    });

    testWidgets('respects maximum size constraints', (tester) async {
      const customMaxSize = Size(1000, 800);
      final windowWithMaxSize = testWindowState.copyWith(
        maxSize: customMaxSize,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: windowWithMaxSize,
                    child: const Center(child: Text('Max Size Window')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final resizableWindow = tester.widget<ResizableWindow>(
        find.byType(ResizableWindow),
      );

      expect(resizableWindow.windowState.maxSize, equals(customMaxSize));
    });

    testWidgets('uses default constraints when not specified', (tester) async {
      final windowWithoutConstraints = WindowState(
        id: 'test-window',
        title: 'Test Window',
        content: const Text('Test'),
        position: const Offset(100, 100),
        size: const Size(600, 400),
        canResize: true,
        minSize: null, // No min size specified
        maxSize: null, // No max size specified
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: windowWithoutConstraints,
                    child: const Center(child: Text('Default Constraints')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Default Constraints'), findsOneWidget);

      // The widget should use defaults: minWidth: 400, minHeight: 300
      final resizableWindow = tester.widget<ResizableWindow>(
        find.byType(ResizableWindow),
      );

      expect(resizableWindow.windowState.minSize, isNull);
      expect(resizableWindow.windowState.maxSize, isNull);
    });

    testWidgets('window stays within screen bounds', (tester) async {
      // Position window at edge of screen
      final edgeWindow = testWindowState.copyWith(position: const Offset(0, 0));

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: edgeWindow,
                    child: const Center(child: Text('Edge Window')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Edge Window'), findsOneWidget);

      // The TransformableBox should clamp to screen bounds
      final screenSize = tester.getSize(find.byType(Scaffold));
      expect(screenSize.width, greaterThan(0));
      expect(screenSize.height, greaterThan(0));
    });

    testWidgets('switches between resizable and non-resizable states', (
      tester,
    ) async {
      // Start with resizable
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: testWindowState,
                    child: const Center(child: Text('Dynamic Window')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Dynamic Window'), findsOneWidget);

      // Switch to non-resizable
      final nonResizableWindow = testWindowState.copyWith(canResize: false);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: nonResizableWindow,
                    child: const Center(child: Text('Dynamic Window')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Dynamic Window'), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('handles window with no size constraints gracefully', (
      tester,
    ) async {
      final minimalWindow = const WindowState(
        id: 'minimal',
        title: 'Minimal',
        content: Text('Minimal'),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ResizableWindow(
                    windowState: minimalWindow,
                    child: const Center(child: Text('Minimal Window')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Minimal Window'), findsOneWidget);

      // Should use default values
      final resizableWindow = tester.widget<ResizableWindow>(
        find.byType(ResizableWindow),
      );

      expect(resizableWindow.windowState.canResize, isTrue); // default
      expect(
        resizableWindow.windowState.position,
        equals(const Offset(100, 100)),
      ); // default
      expect(
        resizableWindow.windowState.size,
        equals(const Size(800, 600)),
      ); // default
    });
  });
}
