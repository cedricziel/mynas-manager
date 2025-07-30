import 'dart:async';
import 'dart:io';
import 'package:truenas_client/truenas_client.dart';

/// Example demonstrating how to authenticate with TrueNAS using username/API key
/// and list all available pools.
///
/// IMPORTANT: TrueNAS SCALE requires HTTPS/TLS for API key authentication!
/// Using ws:// (insecure WebSocket) will cause your API key to be REVOKED.
/// Always use wss:// for production environments with API key authentication.
///
/// Before running this example:
/// 1. Set TRUENAS_URL environment variable (e.g., wss://192.168.1.100/api/current)
/// 2. Set TRUENAS_USERNAME environment variable with your username
/// 3. Set TRUENAS_API_KEY environment variable with your API key
/// 4. Generate an API key in TrueNAS: System Settings > API Keys > Add
///
/// Run with:
/// ```bash
/// export TRUENAS_URL="wss://your-truenas-ip/api/current"
/// export TRUENAS_USERNAME="your-username"
/// export TRUENAS_API_KEY="your-api-key-here"
/// dart run example/main.dart
/// ```
Future<void> main() async {
  // Read configuration from environment variables
  final trueNasUrl = Platform.environment['TRUENAS_URL'];
  final username = Platform.environment['TRUENAS_USERNAME'];
  final apiKey = Platform.environment['TRUENAS_API_KEY'];

  if (trueNasUrl == null || username == null || apiKey == null) {
    print('❌ Missing required environment variables!');
    print('');
    print('Please set the following environment variables:');
    print(
      '  TRUENAS_URL      - WebSocket URL (e.g., wss://192.168.1.100/api/current)',
    );
    print(
      '                     WARNING: Use wss:// for API key auth, not ws://!',
    );
    print('  TRUENAS_USERNAME - Your TrueNAS username');
    print('  TRUENAS_API_KEY  - Your TrueNAS API key');
    print('');
    print('Example:');
    print('  export TRUENAS_URL="wss://192.168.1.100/api/current"');
    print('  export TRUENAS_USERNAME="your-username"');
    print('  export TRUENAS_API_KEY="your-api-key-here"');
    print('  dart run example/main.dart');
    exit(1);
  }

  // Warn if using insecure WebSocket with API key
  if (trueNasUrl.startsWith('ws://') && !trueNasUrl.startsWith('wss://')) {
    print(
      '⚠️  WARNING: Using insecure WebSocket (ws://) with API key authentication!',
    );
    print(
      '   TrueNAS will REVOKE your API key when used over insecure connections.',
    );
    print('   Use wss:// for production environments.');
    print('');
  }

  print('🔧 TrueNAS Client Example - Pool Listing');
  print('=========================================');
  print('Connecting to: $trueNasUrl');
  print('Username: $username');
  print('');

  StreamSubscription<ConnectionStatus>? heartbeatSubscription;

  try {
    // Step 1: Create the TrueNAS client with username and API key
    print('📡 Creating TrueNAS client with username/API key authentication...');
    final client = TrueNasClient.withUsernameApiKey(
      uri: trueNasUrl,
      username: username,
      apiKey: apiKey,
    );

    // Step 2: Connect and authenticate (happens automatically)
    print('🔌 Connecting to TrueNAS server...');
    await client.connect();
    print('✅ Connected and authenticated successfully!');

    // Step 3: Start heartbeat monitoring
    print('💗 Starting connection heartbeat monitoring...');
    heartbeatSubscription = client
        .heartbeat(interval: const Duration(seconds: 5))
        .listen(
          (status) => print('   Connection status: ${status.name}'),
          onError: (Object error) => print('   ⚠️  Heartbeat error: $error'),
        );

    // Step 4: Get system information
    print('ℹ️  Fetching system information...');
    final systemInfo = await client.getSystemInfo();
    print('📋 System: ${systemInfo.hostname} (${systemInfo.version})');
    print('⏱️  Uptime: ${systemInfo.uptime}');
    print(
      '💾 Memory: ${_formatBytes(systemInfo.memory.used)}/${_formatBytes(systemInfo.memory.total)} used',
    );
    print('');

    // Step 5: List all pools
    print('🏊 Fetching storage pools...');
    final pools = await client.listPools();

    if (pools.isEmpty) {
      print('⚠️  No storage pools found.');
    } else {
      print('📦 Found ${pools.length} storage pool(s):');
      print('');

      for (final pool in pools) {
        final healthIcon = pool.isHealthy ? '✅' : '❌';
        final usedPercent = ((pool.allocated / pool.size) * 100)
            .toStringAsFixed(1);

        print('$healthIcon ${pool.name} (${pool.status})');
        print('   Size: ${_formatBytes(pool.size)}');
        print('   Used: ${_formatBytes(pool.allocated)} ($usedPercent%)');
        print('   Free: ${_formatBytes(pool.free)}');
        print('   Path: ${pool.path ?? 'N/A'}');

        if (pool.fragmentation > 0) {
          print('   Fragmentation: ${pool.fragmentation.toStringAsFixed(1)}%');
        }

        print('   VDevs: ${pool.vdevs.length}');
        print('');
      }
    }

    // Step 6: Demonstrate error handling with invalid pool
    print('🧪 Testing error handling...');
    try {
      await client.getPool('non-existent-pool');
    } on TrueNasNotFoundException catch (e) {
      print('✅ Error handling working: ${e.message}');
    }

    // Step 7: Clean up
    print('🧹 Cleaning up connection...');
    await heartbeatSubscription.cancel();
    await client.disconnect();
    print('✅ Disconnected successfully!');
  } on TrueNasAuthException catch (e) {
    print('❌ Authentication failed: ${e.message}');
    print('💡 Check your API key and ensure it has sufficient permissions.');
  } on TrueNasException catch (e) {
    print('❌ TrueNAS error: ${e.message}');
  } catch (e) {
    print('❌ Unexpected error: $e');
  } finally {
    // Ensure cleanup happens even on error
    await heartbeatSubscription?.cancel();
  }
}

/// Format bytes into human-readable format
String _formatBytes(int bytes) {
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  var size = bytes.toDouble();
  var suffixIndex = 0;

  while (size >= 1024 && suffixIndex < suffixes.length - 1) {
    size /= 1024;
    suffixIndex++;
  }

  return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${suffixes[suffixIndex]}';
}
