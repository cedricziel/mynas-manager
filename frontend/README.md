# MyNAS Manager Frontend

Flutter web application providing a desktop-like interface for managing TrueNAS SCALE servers.

## Features

- Desktop-style window management system
- Real-time system monitoring dashboard
- Storage pool management interface
- Responsive design for various screen sizes
- macOS-inspired login screen

## Development

### Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. Run the application:
```bash
flutter run -d chrome --web-port 3000
```

### Testing

Run tests:
```bash
flutter test
```

## Architecture

- `lib/` - Application source code
  - `providers/` - Riverpod state management
  - `screens/` - Main application screens
  - `widgets/` - Reusable UI components
  - `models/` - Data models
  - `services/` - Backend communication
  - `utils/` - Utility functions
- `test/` - Unit and widget tests

## Technologies

- Flutter Web
- Riverpod for state management
- Go Router for navigation
- Material Design 3
- WebSocket for real-time updates

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0).