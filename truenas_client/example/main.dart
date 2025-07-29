import 'dart:io';
import 'package:truenas_client/truenas_client.dart';

/// Example demonstrating how to authenticate with TrueNAS using an API key
/// and list all available pools.
///
/// Before running this example:
/// 1. Set TRUENAS_URL environment variable (e.g., ws://192.168.1.100/api/current)
/// 2. Set TRUENAS_API_KEY environment variable with your API key
/// 3. Generate an API key in TrueNAS: System Settings > API Keys > Add
///
/// Run with:
/// ```bash
/// export TRUENAS_URL="ws://your-truenas-ip/api/current"
/// export TRUENAS_API_KEY="your-api-key-here"
/// dart run example/main.dart
/// ```
Future<void> main() async {
  // Read configuration from environment variables
  final trueNasUrl = Platform.environment['TRUENAS_URL'];
  final apiKey = Platform.environment['TRUENAS_API_KEY'];

  if (trueNasUrl == null || apiKey == null) {
    print('❌ Missing required environment variables!');
    print('');
    print('Please set the following environment variables:');
    print(
      '  TRUENAS_URL     - WebSocket URL (e.g., ws://192.168.1.100/api/current)',
    );
    print('  TRUENAS_API_KEY  - Your TrueNAS API key');
    print('');
    print('Example:');
    print('  export TRUENAS_URL="ws://192.168.1.100/api/current"');
    print('  export TRUENAS_API_KEY="your-api-key-here"');
    print('  dart run example/main.dart');
    exit(1);
  }

  print('🔧 TrueNAS Client Example - Pool Listing');
  print('=========================================');
  print('Connecting to: $trueNasUrl');
  print('');

  try {
    // Step 1: Create the TrueNAS client
    print('📡 Creating TrueNAS client...');
    final client = TrueNasClientFactory.createClient(
      uri: trueNasUrl,
      apiKey: apiKey,
    );

    // Step 2: Connect to TrueNAS
    print('🔌 Connecting to TrueNAS server...');
    await client.connect(trueNasUrl);
    print('✅ Connected successfully!');

    // Step 3: Authenticate using API key
    print('🔐 Authenticating with API key...');
    await client.auth.authenticateWithApiKey(apiKey);
    print('✅ Authenticated successfully!');

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
    await client.dispose();
    print('✅ Disconnected successfully!');
  } on TrueNasAuthenticationException catch (e) {
    print('❌ Authentication failed: ${e.message}');
    print('💡 Check your API key and ensure it has sufficient permissions.');
  } on TrueNasConnectionException catch (e) {
    print('❌ Connection failed: ${e.message}');
    print('💡 Check your TrueNAS URL and network connectivity.');
  } on TrueNasException catch (e) {
    print('❌ TrueNAS error: ${e.message}');
  } catch (e) {
    print('❌ Unexpected error: $e');
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
