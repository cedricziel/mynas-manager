import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mynas_backend/server.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080')
    ..addOption('host', abbr: 'h', defaultsTo: '0.0.0.0')
    ..addFlag('verbose', abbr: 'v', defaultsTo: false);

  final results = parser.parse(args);
  final port = int.parse(results['port'] as String);
  final host = results['host'] as String;
  final verbose = results['verbose'] as bool;

  // Setup logging first
  _setupLogging(verbose);

  // Load environment variables from .env file
  final env = DotEnv(includePlatformEnvironment: true);
  try {
    env.load(['.env']);
    Logger.root.info('Loaded .env file successfully');
    Logger.root.info('TrueNAS URL: ${env['TRUENAS_URL'] ?? 'not set'}');
  } catch (e) {
    Logger.root.warning(
      'No .env file found, using system environment variables only: $e',
    );
  }

  // Check if session auth mode is enabled
  final useSessionAuth =
      env['USE_SESSION_AUTH'] == 'true' || env['AUTH_MODE'] == 'truenas';

  // Pass environment to server if available
  final server = Server(
    trueNasUrl: env['TRUENAS_URL'],
    trueNasApiKey: env['TRUENAS_API_KEY'],
    useSessionAuth: useSessionAuth,
  );

  if (useSessionAuth) {
    print('Running in session-based authentication mode');
    print('Users will authenticate with their TrueNAS credentials');
  }

  try {
    await server.start(host: host, port: port);
    print('Server listening on $host:$port');
    print('Press Ctrl+C to stop');
  } catch (e) {
    Logger.root.severe('Failed to start server: $e');
    exit(1);
  }
}

void _setupLogging(bool verbose) {
  Logger.root.level = verbose ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String();
    print('[$time] ${record.level.name}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
      if (record.stackTrace != null) {
        print('Stack trace:\n${record.stackTrace}');
      }
    }
  });
}
