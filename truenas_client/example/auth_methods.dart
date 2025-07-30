import 'dart:io';
import 'package:truenas_client/truenas_client.dart';

/// Example demonstrating different authentication methods for TrueNAS
///
/// This example shows how to create clients with different authentication options:
/// 1. API key only
/// 2. Username + API key (recommended)
/// 3. Username + password
Future<void> main() async {
  final url = Platform.environment['TRUENAS_URL'];
  final username = Platform.environment['TRUENAS_USERNAME'];
  final apiKey = Platform.environment['TRUENAS_API_KEY'];
  final password = Platform.environment['TRUENAS_PASSWORD'];

  if (url == null) {
    print('❌ TRUENAS_URL environment variable is required!');
    exit(1);
  }

  print('🔐 TrueNAS Authentication Methods Example');
  print('=========================================\n');

  // Method 1: API Key Only
  if (apiKey != null && username == null) {
    print('Method 1: API Key Authentication');
    print('--------------------------------');
    try {
      final client = TrueNasClient.withApiKey(uri: url, apiKey: apiKey);
      await testConnection(client, 'API key');
    } catch (e) {
      print('❌ Failed: $e');
    }
    print('');
  }

  // Method 2: Username + API Key (Recommended)
  if (username != null && apiKey != null) {
    print('Method 2: Username + API Key Authentication (Recommended)');
    print('--------------------------------------------------------');
    try {
      final client = TrueNasClient.withUsernameApiKey(
        uri: url,
        username: username,
        apiKey: apiKey,
      );
      await testConnection(client, 'username/API key');
    } catch (e) {
      print('❌ Failed: $e');
    }
    print('');
  }

  // Method 3: Username + Password
  if (username != null && password != null) {
    print('Method 3: Username + Password Authentication');
    print('-------------------------------------------');
    print('⚠️  Warning: Consider using API key for better security');
    try {
      final client = TrueNasClient.withCredentials(
        uri: url,
        username: username,
        password: password,
      );
      await testConnection(client, 'username/password');
    } catch (e) {
      print('❌ Failed: $e');
    }
    print('');
  }

  // Show configuration help if no valid auth method available
  if ((apiKey == null || username == null) &&
      (username == null || password == null)) {
    print('ℹ️  Configuration Help');
    print('---------------------');
    print(
      'Set environment variables for your preferred authentication method:\n',
    );

    print('Option 1 - API Key Only:');
    print('  export TRUENAS_URL="wss://your-truenas-ip/api/current"');
    print('  export TRUENAS_API_KEY="your-api-key"\n');

    print('Option 2 - Username + API Key (Recommended):');
    print('  export TRUENAS_URL="wss://your-truenas-ip/api/current"');
    print('  export TRUENAS_USERNAME="your-username"');
    print('  export TRUENAS_API_KEY="your-api-key"\n');

    print('Option 3 - Username + Password:');
    print('  export TRUENAS_URL="ws://your-truenas-ip/api/current"');
    print('  export TRUENAS_USERNAME="your-username"');
    print('  export TRUENAS_PASSWORD="your-password"\n');

    print(
      'Note: Use wss:// for secure connections with API key authentication',
    );
  }
}

/// Test connection and basic API call
Future<void> testConnection(ITrueNasClient client, String authMethod) async {
  try {
    print('🔌 Connecting with $authMethod...');
    await client.connect();
    print('✅ Connected successfully!');

    // Try a simple API call
    final systemInfo = await client.getSystemInfo();
    print('📋 System: ${systemInfo.hostname} (${systemInfo.version})');

    await client.disconnect();
    print('✅ Test completed successfully!');
  } catch (e) {
    print('❌ Error: $e');
    rethrow;
  }
}
