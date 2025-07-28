# MyNAS Manager

This is a brief guide to the MyNAS Manager codebase to help you understand and work with the project efficiently.

## Commands

### Installation
```bash
# Install all dependencies
cd shared && dart pub get && cd ..
cd backend && dart pub get && cd ..
cd frontend && flutter pub get && cd ..
```

### Development
```bash
# Run backend server
cd backend && dart run bin/server.dart

# Run frontend (web)
cd frontend && flutter run -d chrome --web-port 3000

# Run both using VS Code
# Open mynas-manager.code-workspace and use "Full Stack" launch configuration
```

### Code Generation
```bash
# Generate Freezed models (shared)
cd shared && dart run build_runner build --delete-conflicting-outputs

# Generate Riverpod providers (frontend)
cd frontend && dart run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
cd shared && dart test && cd ..
cd backend && dart test && cd ..
cd frontend && flutter test && cd ..
```

### Linting
```bash
# Analyze code
dart analyze
flutter analyze
```

## Architecture

### Project Structure
```
mynas-manager/
├── backend/          # Dart server connecting to TrueNAS
├── frontend/         # Flutter web application
├── shared/           # Shared models and utilities
└── mynas-manager.code-workspace  # VS Code workspace
```

### Technology Stack

**Backend**
- Dart server using Shelf HTTP framework
- JSON-RPC2 protocol over WebSocket
- Connects to TrueNAS SCALE API
- Environment-based configuration (.env file)

**Frontend**
- Flutter web application
- Desktop-like UI with window management system
- Riverpod for state management
- Go Router for navigation
- Custom window manager with draggable/resizable windows

**Shared**
- Freezed for immutable data models
- JSON serialization
- Common models: Dataset, Pool, Share, SystemInfo

### Key Components

**Backend Services**
- `TrueNasWebSocketClient` (backend/lib/services/truenas_websocket_client.dart): Handles TrueNAS API communication
- `WebSocketHandler` (backend/lib/rpc/websocket_handler.dart): JSON-RPC2 WebSocket implementation

**Frontend Features**
- `WindowManagerProvider` (frontend/lib/providers/window_manager_provider.dart): Window state management
- `DesktopScreen` (frontend/lib/screens/desktop_screen.dart): Main desktop interface
- `LoginScreen` (frontend/lib/screens/login_screen.dart): macOS-style login screen
- `WindowWidget` (frontend/lib/widgets/desktop/window_widget.dart): Draggable window implementation
- `ResizableWindow` (frontend/lib/widgets/desktop/resizable_window.dart): Window resizing functionality
- `Dock` (frontend/lib/widgets/desktop/dock.dart): Taskbar/dock component

### Configuration

**Backend Configuration**
Create `.env` file in backend directory:
```env
# TrueNAS WebSocket URL (new JSON-RPC API)
TRUENAS_URL=ws://your-truenas-ip/api/current

# Authentication (API key required)
TRUENAS_API_KEY=your-api-key-here
```

**Frontend Configuration**
- Uses environment variables through Flutter
- WebSocket connects to backend at ws://localhost:8080/ws

### Development Tips

1. **VS Code Workspace**: Use the provided workspace file for multi-root development
2. **Code Generation**: Run build_runner after modifying Freezed models
3. **Hot Reload**: Frontend supports Flutter hot reload, backend requires restart
4. **WebSocket Communication**: Frontend and backend communicate via JSON-RPC2 over WebSocket

### Current Status

- ✅ Basic architecture setup
- ✅ WebSocket communication working
- ✅ Desktop UI with window management
- ✅ macOS-style login screen
- ✅ Comprehensive TrueNAS SCALE API client with dependency injection
- ✅ Modern JSON-RPC 2.0 over WebSocket support
- ✅ TrueNAS 25.04+ compatibility with version detection
- ✅ Rate limiting and authentication management
- 🔄 App launcher pending implementation
- 🔄 Migration of existing screens to window apps pending

### Important Notes

- Organization: com.cedricziel.mynas
- Platform: Web only (not desktop)
- TrueNAS uses bidirectional WebSocket "Peer" connections
- Custom window management system (no suitable packages for web)

---

## AI Development Team Configuration

*Updated by team-configurator on 2025-07-28*

Your project uses: Dart (Shelf HTTP), Flutter Web, Riverpod, WebSocket (JSON-RPC2), TrueNAS SCALE API

### Specialist Assignments

- **Backend Development** → @dart-engineer
  - Dart server implementation with Shelf framework
  - WebSocket handling and JSON-RPC2 protocol
  - TrueNAS API integration and client implementation
  - Async programming patterns, isolates, and streams
  - Code generation with Freezed and build_runner

- **Frontend Development** → @flutter-app-developer
  - Flutter web application development
  - Desktop-like UI with window management system
  - Riverpod state management implementation
  - Custom widget development (WindowWidget, ResizableWindow, Dock)
  - Go Router navigation and deep linking
  - Performance optimization for web platform

- **Architecture & System Design** → @api-architect
  - WebSocket communication architecture
  - JSON-RPC2 protocol design and implementation
  - Service layer design and dependency injection
  - Shared model architecture across packages
  - Package structure (backend/frontend/shared/mynas_desktop)

- **Code Quality & Performance** → @code-reviewer + @performance-optimizer
  - Code review for Dart/Flutter best practices
  - Performance profiling and optimization
  - Memory management and resource cleanup
  - Widget rebuild optimization
  - WebSocket connection efficiency

- **Documentation** → @documentation-specialist
  - API documentation for TrueNAS integration
  - Flutter widget documentation
  - Architecture decision records
  - Development guides and setup instructions

### How to Use Your Team

**Backend Tasks:**

- "Implement new TrueNAS API endpoint for disk management"
- "Add WebSocket reconnection logic with exponential backoff"
- "Create Freezed models for new API responses"

**Frontend Tasks:**

- "Build a file browser window for the desktop interface"
- "Implement drag-and-drop between windows"
- "Create Riverpod providers for system monitoring"

**Architecture Tasks:**

- "Design state synchronization between multiple windows"
- "Plan migration of screens to window apps"
- "Optimize WebSocket message batching"

**Quality Tasks:**

- "Review the window management implementation"
- "Profile and optimize app startup time"
- "Analyze memory usage during long sessions"

### Project-Specific Expertise

Your AI team understands:

- TrueNAS SCALE 25.04+ JSON-RPC 2.0 API
- Bidirectional WebSocket "Peer" connections
- Desktop-like UI patterns for web applications
- Dart/Flutter monorepo structure with shared packages
- Custom window management without third-party packages

Your specialized AI development team is configured and ready to help with MyNAS Manager!
