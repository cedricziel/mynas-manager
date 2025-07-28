import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynas_frontend/models/window_state.dart';

void main() {
  group('WindowState', () {
    test('creates instance with required parameters', () {
      const testWidget = Text('Test Content');
      const windowState = WindowState(
        id: 'test-window',
        title: 'Test Window',
        content: testWidget,
      );

      expect(windowState.id, equals('test-window'));
      expect(windowState.title, equals('Test Window'));
      expect(windowState.content, equals(testWidget));
    });

    test('creates instance with default values', () {
      const testWidget = Text('Test Content');
      const windowState = WindowState(
        id: 'test-window',
        title: 'Test Window',
        content: testWidget,
      );

      expect(windowState.position, equals(const Offset(100, 100)));
      expect(windowState.size, equals(const Size(800, 600)));
      expect(windowState.isMinimized, isFalse);
      expect(windowState.isMaximized, isFalse);
      expect(windowState.isFocused, isFalse);
      expect(windowState.zIndex, equals(0));
      expect(windowState.icon, isNull);
      expect(windowState.canResize, isTrue);
      expect(windowState.canClose, isTrue);
      expect(windowState.minSize, equals(const Size(400, 300)));
      expect(windowState.maxSize, isNull);
    });

    test('creates instance with custom values', () {
      const testWidget = Text('Test Content');
      const windowState = WindowState(
        id: 'test-window',
        title: 'Test Window',
        content: testWidget,
        position: Offset(200, 200),
        size: Size(1024, 768),
        isMinimized: true,
        isMaximized: false,
        isFocused: true,
        zIndex: 5,
        icon: Icons.folder,
        canResize: false,
        canClose: false,
        minSize: Size(300, 200),
        maxSize: Size(1920, 1080),
      );

      expect(windowState.position, equals(const Offset(200, 200)));
      expect(windowState.size, equals(const Size(1024, 768)));
      expect(windowState.isMinimized, isTrue);
      expect(windowState.isMaximized, isFalse);
      expect(windowState.isFocused, isTrue);
      expect(windowState.zIndex, equals(5));
      expect(windowState.icon, equals(Icons.folder));
      expect(windowState.canResize, isFalse);
      expect(windowState.canClose, isFalse);
      expect(windowState.minSize, equals(const Size(300, 200)));
      expect(windowState.maxSize, equals(const Size(1920, 1080)));
    });

    group('copyWith', () {
      late WindowState originalState;

      setUp(() {
        originalState = const WindowState(
          id: 'original-window',
          title: 'Original Window',
          content: Text('Original Content'),
          position: Offset(150, 150),
          size: Size(900, 700),
          isMinimized: false,
          isMaximized: false,
          isFocused: true,
          zIndex: 3,
          icon: Icons.home,
          canResize: true,
          canClose: true,
          minSize: Size(500, 400),
          maxSize: Size(1600, 900),
        );
      });

      test('copies with no changes', () {
        final copiedState = originalState.copyWith();

        expect(copiedState.id, equals(originalState.id));
        expect(copiedState.title, equals(originalState.title));
        expect(copiedState.content, equals(originalState.content));
        expect(copiedState.position, equals(originalState.position));
        expect(copiedState.size, equals(originalState.size));
        expect(copiedState.isMinimized, equals(originalState.isMinimized));
        expect(copiedState.isMaximized, equals(originalState.isMaximized));
        expect(copiedState.isFocused, equals(originalState.isFocused));
        expect(copiedState.zIndex, equals(originalState.zIndex));
        expect(copiedState.icon, equals(originalState.icon));
        expect(copiedState.canResize, equals(originalState.canResize));
        expect(copiedState.canClose, equals(originalState.canClose));
        expect(copiedState.minSize, equals(originalState.minSize));
        expect(copiedState.maxSize, equals(originalState.maxSize));
      });

      test('copies with specific changes', () {
        const newContent = Text('New Content');
        final copiedState = originalState.copyWith(
          title: 'Updated Window',
          content: newContent,
          position: const Offset(300, 300),
          isFocused: false,
          zIndex: 10,
        );

        expect(copiedState.id, equals(originalState.id));
        expect(copiedState.title, equals('Updated Window'));
        expect(copiedState.content, equals(newContent));
        expect(copiedState.position, equals(const Offset(300, 300)));
        expect(copiedState.size, equals(originalState.size));
        expect(copiedState.isMinimized, equals(originalState.isMinimized));
        expect(copiedState.isMaximized, equals(originalState.isMaximized));
        expect(copiedState.isFocused, isFalse);
        expect(copiedState.zIndex, equals(10));
        expect(copiedState.icon, equals(originalState.icon));
        expect(copiedState.canResize, equals(originalState.canResize));
        expect(copiedState.canClose, equals(originalState.canClose));
        expect(copiedState.minSize, equals(originalState.minSize));
        expect(copiedState.maxSize, equals(originalState.maxSize));
      });

      test('copies with window state changes', () {
        final minimizedState = originalState.copyWith(
          isMinimized: true,
          isFocused: false,
        );

        expect(minimizedState.isMinimized, isTrue);
        expect(minimizedState.isFocused, isFalse);
        expect(minimizedState.isMaximized, equals(originalState.isMaximized));
      });

      test('copies with size constraints changes', () {
        final resizedState = originalState.copyWith(
          size: const Size(1200, 800),
          minSize: const Size(600, 500),
          maxSize: Size(1920, 1080),
          canResize: false,
        );

        expect(resizedState.size, equals(const Size(1200, 800)));
        expect(resizedState.minSize, equals(const Size(600, 500)));
        expect(resizedState.maxSize, equals(const Size(1920, 1080)));
        expect(resizedState.canResize, isFalse);
      });
    });
  });
}
