# MyNAS Shared

Shared models and utilities for MyNAS Manager used by both frontend and backend.

## Features

- Common data models using Freezed
- JSON serialization with json_serializable  
- Shared constants and utilities
- Type-safe communication between frontend and backend

## Usage

This package is used internally by the MyNAS Manager frontend and backend. It contains:

### Models
- `Pool` - Storage pool information
- `Dataset` - Dataset configuration
- `Share` - Network share details
- `SystemInfo` - System information
- And many more...

### Utilities
- Storage formatting helpers
- Common constants
- Shared enums and types

## Development

### Setup

1. Install dependencies:
```bash
dart pub get
```

2. Generate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Testing

Run tests:
```bash
dart test
```

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0).