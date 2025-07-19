import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
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

  _setupLogging(verbose);

  final server = Server();
  
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