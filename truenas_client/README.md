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
final client = TrueNasClientFactory.create(
  baseUrl: 'ws://your-truenas-ip/api/current',
  apiKey: 'your-api-key',
);

// Connect and use
await client.connect();
final pools = await client.listPools();
```

## Authentication

The client supports API key authentication using the `auth.login_with_api_key` method.

## API Coverage

- **Pools**: List, get details, topology
- **Datasets**: List, create, update, delete
- **Shares**: SMB, NFS share management
- **Disks**: List, monitor, SMART data
- **System**: Info, stats, updates