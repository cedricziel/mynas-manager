# TrueNAS Client

A Dart client library for TrueNAS SCALE API integration using WebSocket connections and JSON-RPC 2.0 protocol.

## Features

- WebSocket-based communication with TrueNAS SCALE
- JSON-RPC 2.0 protocol support
- API key authentication
- Connection management with automatic reconnection
- Comprehensive coverage of TrueNAS API endpoints:
  - Pool management
  - Dataset operations
  - Share configuration
  - Disk monitoring
  - System information

## Usage

```dart
import 'package:truenas_client/truenas_client.dart';

// Create client
final client = TrueNasClientFactory.createClient(
  uri: 'wss://your-truenas-ip/api/current',  // Use wss:// for API key auth!
  apiKey: 'your-api-key',
);

// Connect and authenticate
await client.connect(uri);
await client.auth.authenticateWithApiKey(apiKey);

// Use the client
final pools = await client.listPools();
```

## Example

See the [example/](example/) directory for a complete working example that demonstrates:

- Environment variable configuration
- Connection and authentication
- Fetching system information
- Listing storage pools
- Error handling
- Proper cleanup

Run the example:
```bash
export TRUENAS_URL="wss://your-truenas-ip/api/current"
export TRUENAS_API_KEY="your-api-key-here"
dart run example/main.dart
```

## Authentication

The client supports API key authentication using the `auth.login_with_api_key` method.

**IMPORTANT:** TrueNAS SCALE requires HTTPS/TLS (wss://) for API key authentication. Using ws:// (insecure WebSocket) will cause TrueNAS to automatically revoke your API key for security reasons. Always use wss:// in production environments when using API key authentication.

## API Coverage

- **Pools**: List, get details, topology
- **Datasets**: List, create, update, delete
- **Shares**: SMB, NFS share management
- **Disks**: List, monitor, SMART data
- **System**: Info, stats, updates