# MyNAS Manager Backend

Backend server for MyNAS Manager that provides a bridge between the TrueNAS SCALE API and the web frontend.

## Features

- JSON-RPC 2.0 over WebSocket communication
- TrueNAS SCALE API integration
- Real-time updates and notifications
- Authentication and session management
- Rate limiting and error handling

## Development

### Setup

1. Install dependencies:
```bash
dart pub get
```

2. Configure environment:
```bash
cp .env.example .env
# Edit .env with your TrueNAS credentials
```

3. Run the server:
```bash
dart run bin/server.dart
```

### Testing

Run tests:
```bash
dart test
```

Run with mock TrueNAS server:
```bash
dart run bin/test_with_mock.dart
```

## Architecture

- `bin/` - Server entry points
- `lib/` - Core library code
  - `interfaces/` - Abstract interfaces
  - `services/` - Service implementations
  - `rpc/` - JSON-RPC handlers
  - `exceptions/` - Custom exceptions
  - `utils/` - Utility functions
- `test/` - Unit and integration tests

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0).