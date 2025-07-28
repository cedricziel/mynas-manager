# MyNAS Desktop

A reusable desktop window management system for Flutter web applications.

## Features

- **Window Management**: Create, minimize, maximize, restore, and close windows
- **Draggable Windows**: Move windows around the desktop by dragging the title bar
- **Resizable Windows**: Resize windows from any edge or corner
- **Window Stacking**: Proper z-index management for window focus
- **Dock/Taskbar**: Display app launchers and manage open windows
- **Desktop Icons**: Display clickable icons on the desktop

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  mynas_desktop:
    path: ../mynas_desktop  # or use git/pub.dev when published
```

## Usage

### Basic Setup

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_desktop/mynas_desktop.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DesktopScreen(),
    );
  }
}
```

### Creating a Desktop Screen

```dart
class DesktopScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: WindowManager(
        child: Stack(
          children: [
            // Desktop background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100]!, Colors.blue[300]!],
                ),
              ),
            ),
            
            // Desktop icons
            DesktopArea(
              icons: [
                DesktopIcon(
                  id: 'notepad',
                  icon: Icons.note,
                  label: 'Notepad',
                  onTap: () => _openNotepad(ref),
                ),
                DesktopIcon(
                  id: 'calculator',
                  icon: Icons.calculate,
                  label: 'Calculator',
                  onTap: () => _openCalculator(ref),
                ),
              ],
            ),
            
            // Dock at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Dock(
                launchers: [
                  DockLauncher(
                    id: 'notepad',
                    icon: Icons.note,
                    label: 'Notepad',
                    onTap: () => _openNotepad(ref),
                  ),
                  DockLauncher(
                    id: 'apps',
                    icon: Icons.apps,
                    label: 'All Apps',
                    onTap: () => _showAppLauncher(ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _openNotepad(WidgetRef ref) {
    ref.read(windowManagerProvider.notifier).openWindowWithParams(
      id: 'notepad-1',
      title: 'Notepad',
      icon: Icons.note,
      content: NotepadApp(),
    );
  }
  
  void _openCalculator(WidgetRef ref) {
    ref.read(windowManagerProvider.notifier).openWindowWithParams(
      id: 'calculator-1',
      title: 'Calculator',
      icon: Icons.calculate,
      content: CalculatorApp(),
      size: Size(400, 500),
      canResize: false,
    );
  }
}
```

### Window Management API

```dart
// Get the window manager
final windowManager = ref.read(windowManagerProvider.notifier);

// Open a new window
windowManager.openWindowWithParams(
  id: 'my-window',
  title: 'My Window',
  icon: Icons.window,
  content: MyContent(),
  size: Size(800, 600),
  position: Offset(100, 100),
  canResize: true,
  canClose: true,
);

// Focus a window
windowManager.focusWindow('my-window');

// Minimize a window
windowManager.minimizeWindow('my-window');

// Maximize a window
windowManager.maximizeWindow('my-window');

// Restore a window
windowManager.restoreWindow('my-window');

// Close a window
windowManager.closeWindow('my-window');

// Close all windows
windowManager.closeAllWindows();
```

### Custom Window Content

Any Flutter widget can be used as window content:

```dart
class MyCustomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Hello from a window!'),
          ElevatedButton(
            onPressed: () {},
            child: Text('Click me'),
          ),
        ],
      ),
    );
  }
}
```

## Customization

### Window Constraints

```dart
windowManager.openWindowWithParams(
  id: 'constrained-window',
  title: 'Fixed Size Window',
  content: MyContent(),
  size: Size(600, 400),
  minSize: Size(400, 300),
  maxSize: Size(800, 600),
  canResize: true,
);
```

### Styling

The package uses Material 3 theming. Windows automatically adapt to your app's theme.

## License

This package is part of the MyNAS Manager project.