import 'dart:io';

/// Test script that runs the backend server against the mock TrueNAS
void main() async {
  print('Starting mock TrueNAS server...');
  
  // Start mock server
  final mockProcess = await Process.start(
    'dart',
    ['run', 'bin/mock_truenas_server.dart', '8082'],
  );
  
  // Forward mock server output
  mockProcess.stdout.transform(SystemEncoding().decoder).listen((data) {
    print('[MOCK] $data');
  });
  mockProcess.stderr.transform(SystemEncoding().decoder).listen((data) {
    print('[MOCK ERROR] $data');
  });
  
  // Wait a bit for mock server to start
  await Future.delayed(Duration(seconds: 2));
  
  print('\nStarting backend server...');
  
  // Copy .env to .env.backup and create mock .env
  final envFile = File('.env');
  final envBackup = File('.env.backup');
  if (await envFile.exists()) {
    await envFile.copy(envBackup.path);
  }
  
  // Write mock .env
  await File('.env').writeAsString('''
TRUENAS_URL=ws://localhost:8082/api/current
TRUENAS_API_KEY=mock-api-key
''');

  // Start backend server with mock URL on different port
  final backendProcess = await Process.start(
    'dart',
    ['run', 'bin/server.dart', '--port', '8083'],
  );
  
  // Forward backend server output
  backendProcess.stdout.transform(SystemEncoding().decoder).listen((data) {
    print('[BACKEND] $data');
  });
  backendProcess.stderr.transform(SystemEncoding().decoder).listen((data) {
    print('[BACKEND ERROR] $data');
  });
  
  // Handle Ctrl+C
  ProcessSignal.sigint.watch().listen((_) async {
    print('\nShutting down...');
    mockProcess.kill();
    backendProcess.kill();
    
    // Restore original .env
    if (await envBackup.exists()) {
      await envBackup.copy(envFile.path);
      await envBackup.delete();
    }
    
    exit(0);
  });
  
  // Wait for processes
  await Future.wait([
    mockProcess.exitCode,
    backendProcess.exitCode,
  ]);
}