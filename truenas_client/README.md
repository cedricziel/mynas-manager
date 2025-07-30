# TrueNAS Client

A Dart client library for TrueNAS SCALE API integration using WebSocket connections and JSON-RPC 2.0 protocol.

## Features

- WebSocket-based communication with TrueNAS SCALE
- JSON-RPC 2.0 protocol support
- API key authentication
- Connection management with automatic reconnection
- Heartbeat monitoring for connection health
- Comprehensive coverage of TrueNAS API endpoints:
  - Pool management
  - Dataset operations
  - Share configuration
  - Disk monitoring
  - System information

## Usage

```dart
import 'package:truenas_client/truenas_client.dart';

// Option 1: API key authentication
final client = TrueNasClient.withApiKey(
  uri: 'wss://your-truenas-ip/api/current',
  apiKey: 'your-api-key',
);

// Option 2: Username + API key authentication
final client = TrueNasClient.withUsernameApiKey(
  uri: 'wss://your-truenas-ip/api/current',
  username: 'your-username',
  apiKey: 'your-api-key',
);

// Option 3: Username + password authentication
final client = TrueNasClient.withCredentials(
  uri: 'ws://your-truenas-ip/api/current',
  username: 'your-username',
  password: 'your-password',
);

// Connect (authentication happens automatically)
await client.connect();

// Start heartbeat monitoring (optional)
final heartbeatStream = client.heartbeat(
  interval: Duration(seconds: 30),
);
heartbeatStream.listen((status) {
  print('Connection status: ${status.name}');
});

// Use the client
final pools = await client.listPools();

// Clean up
await client.disconnect();
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
# Option 1: API key authentication
export TRUENAS_URL="wss://your-truenas-ip/api/current"
export TRUENAS_API_KEY="your-api-key-here"

# Option 2: Username + API key authentication
export TRUENAS_URL="wss://your-truenas-ip/api/current"
export TRUENAS_USERNAME="your-username"
export TRUENAS_API_KEY="your-api-key-here"

# Option 3: Username + password authentication
export TRUENAS_URL="ws://your-truenas-ip/api/current"
export TRUENAS_USERNAME="your-username"
export TRUENAS_PASSWORD="your-password"

dart run example/main.dart
```

## Authentication

The client supports multiple authentication methods:

1. **API Key Authentication**: Uses `auth.login_with_api_key` method
2. **Username + API Key**: Uses `auth.login_ex` with API_KEY mechanism (TrueNAS 25.10+)
3. **Username + Password**: Uses `auth.login_ex` with PASSWORD_PLAIN mechanism

**IMPORTANT:** TrueNAS SCALE requires HTTPS/TLS (wss://) for API key authentication. Using ws:// (insecure WebSocket) will cause TrueNAS to automatically revoke your API key for security reasons. Always use wss:// in production environments when using API key authentication.

### Authentication Response Handling

The `auth.login_ex` method returns different response types:
- `SUCCESS`: Authentication successful
- `OTP_REQUIRED`: Two-factor authentication required
- `AUTH_ERR`: Invalid credentials
- `EXPIRED`: Credentials have expired
- `REDIRECT`: Authentication requires redirect

## API Coverage

- **Pools**: List, get details, topology
- **Datasets**: List, create, update, delete
- **Shares**: SMB, NFS share management
- **Disks**: List, monitor, SMART data
- **System**: Info, stats, updates