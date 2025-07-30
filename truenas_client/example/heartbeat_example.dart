import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';

/// Example demonstrating heartbeat monitoring
void main() async {
  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '${record.time}: ${record.level.name}: ${record.loggerName}: '
      '${record.message}',
    );
  });

  // Read configuration from environment variables
  final apiKey = Platform.environment['TRUENAS_API_KEY'];
  final username = Platform.environment['TRUENAS_USERNAME'];
  final url =
      Platform.environment['TRUENAS_URL'] ?? 'ws://localhost/api/current';

  if (url.isEmpty) {
    print('Error: TRUENAS_URL not set in environment');
    exit(1);
  }

  // Create client based on provided credentials
  late final TrueNasClient client;
  if (username != null && apiKey != null) {
    // Username + API key authentication
    print('Using username/API key authentication');
    client = TrueNasClient.withUsernameApiKey(
      uri: url,
      username: username,
      apiKey: apiKey,
    );
  } else if (apiKey != null) {
    // API key only authentication
    print('Using API key authentication');
    client = TrueNasClient.withApiKey(uri: url, apiKey: apiKey);
  } else {
    print(
      'Error: Either TRUENAS_API_KEY or TRUENAS_USERNAME+TRUENAS_API_KEY must be set',
    );
    exit(1);
  }

  StreamSubscription<ConnectionStatus>? subscription;

  try {
    // Connect to TrueNAS
    print('Connecting to TrueNAS...');
    await client.connect();
    print('Connected successfully!\n');

    // Start heartbeat monitoring
    print('Starting heartbeat monitoring (interval: 5 seconds)...');
    final heartbeatStream = client.heartbeat(
      interval: const Duration(seconds: 5),
    );

    // Subscribe to heartbeat updates
    subscription = heartbeatStream.listen(
      (status) {
        final timestamp = DateTime.now().toIso8601String();
        print('[$timestamp] Connection status: ${status.name}');

        // React to connection changes
        switch (status) {
          case ConnectionStatus.connected:
            // Connection is healthy
            break;
          case ConnectionStatus.disconnected:
            print('  ⚠️  Connection lost!');
            break;
          case ConnectionStatus.error:
            print('  ❌ Connection error detected');
            break;
          case ConnectionStatus.reconnecting:
            print('  🔄 Attempting to reconnect...');
            break;
        }
      },
      onError: (Object error) {
        print('Heartbeat stream error: $error');
      },
      onDone: () {
        print('Heartbeat monitoring stopped');
      },
    );

    // Keep monitoring for 30 seconds
    print('\nMonitoring connection for 30 seconds...');
    print('(Try disconnecting your network to see status changes)\n');

    await Future<void>.delayed(const Duration(seconds: 30));

    // Stop heartbeat
    print('\nStopping heartbeat monitoring...');
    await client.stopHeartbeat();

    // Disconnect
    print('Disconnecting from TrueNAS...');
    await client.disconnect();
    print('Disconnected successfully!');
  } catch (e, stack) {
    print('Error: $e');
    print('Stack trace:\n$stack');
  } finally {
    // Cleanup
    await subscription?.cancel();
  }
}
