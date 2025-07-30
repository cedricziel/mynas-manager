import 'dart:io';
import 'package:truenas_client/truenas_client.dart';
import 'package:logging/logging.dart';

/// Simple test to debug authentication
Future<void> main() async {
  // Enable detailed logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '${record.time} [${record.level.name}] ${record.loggerName}: ${record.message}',
    );
    if (record.error != null) {
      print('  Error: ${record.error}');
      if (record.stackTrace != null) {
        print('  Stack: ${record.stackTrace}');
      }
    }
  });

  // Read configuration from environment variables
  final trueNasUrl =
      Platform.environment['TRUENAS_URL'] ?? 'ws://192.168.178.6/api/current';
  final apiKey =
      Platform.environment['TRUENAS_API_KEY'] ??
      '8-hYklnPVCrDEb3B6BqTi14BFe3AJcB8kcQsAbF8HinbyHvBNEQu27vUDE86hzBWQu';

  print('Testing TrueNAS authentication');
  print('URL: $trueNasUrl');
  print('');

  try {
    // Create client
    print('Creating client...');
    final client = TrueNasClient.withApiKey(uri: trueNasUrl, apiKey: apiKey);

    // Connect (authentication happens automatically)
    print('Connecting and authenticating...');
    await client.connect();
    print('Connected and authenticated!');

    // Try a simple API call
    print('Testing API call...');
    try {
      final systemInfo = await client.getSystemInfo();
      print('System info retrieved successfully!');
      print('Hostname: ${systemInfo.hostname}');
    } catch (e) {
      print('Failed to get system info: $e');
    }

    // Clean up
    await client.disconnect();
    print('Done!');

    // Exit successfully
    exit(0);
  } catch (e, stack) {
    print('Error: $e');
    print('Stack: $stack');
    exit(1);
  }
}
