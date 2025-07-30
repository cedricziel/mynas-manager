import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';

enum AuthMode { none, apiKey, jwt, basic }

class AuthMiddleware {
  final _logger = Logger('AuthMiddleware');
  final AuthMode mode;
  final String? apiKey;
  final String? jwtSecret;
  final String? jwtIssuer;
  final String? basicUsername;
  final String? basicPassword;

  AuthMiddleware({
    required this.mode,
    this.apiKey,
    this.jwtSecret,
    this.jwtIssuer,
    this.basicUsername,
    this.basicPassword,
  }) {
    _validateConfiguration();
  }

  factory AuthMiddleware.fromEnvironment() {
    final authModeStr = Platform.environment['AUTH_MODE'] ?? 'none';
    final authMode = AuthMode.values.firstWhere(
      (mode) => mode.name == authModeStr,
      orElse: () => AuthMode.none,
    );

    return AuthMiddleware(
      mode: authMode,
      apiKey: Platform.environment['API_KEY'],
      jwtSecret: Platform.environment['JWT_SECRET'],
      jwtIssuer: Platform.environment['JWT_ISSUER'],
      basicUsername: Platform.environment['BASIC_AUTH_USERNAME'],
      basicPassword: Platform.environment['BASIC_AUTH_PASSWORD'],
    );
  }

  void _validateConfiguration() {
    switch (mode) {
      case AuthMode.apiKey:
        if (apiKey == null || apiKey!.isEmpty) {
          throw ArgumentError(
            'API_KEY must be set when using api_key auth mode',
          );
        }
        break;
      case AuthMode.jwt:
        if (jwtSecret == null || jwtSecret!.isEmpty) {
          throw ArgumentError(
            'JWT_SECRET must be set when using jwt auth mode',
          );
        }
        break;
      case AuthMode.basic:
        if (basicUsername == null ||
            basicUsername!.isEmpty ||
            basicPassword == null ||
            basicPassword!.isEmpty) {
          throw ArgumentError(
            'BASIC_AUTH_USERNAME and BASIC_AUTH_PASSWORD must be set when using basic auth mode',
          );
        }
        break;
      case AuthMode.none:
        _logger.warning(
          'Authentication is disabled. This is not recommended for production.',
        );
        break;
    }
  }

  Middleware get middleware {
    return (Handler innerHandler) {
      return (Request request) {
        if (mode == AuthMode.none) {
          return innerHandler(request);
        }

        final authorized = _validateRequest(request);
        if (!authorized) {
          final remoteIp =
              request.headers['x-forwarded-for'] ??
              request.context['shelf.io.connection_info'].toString();
          _logger.warning('Unauthorized request from $remoteIp');
          return Response(
            401,
            body: jsonEncode({'error': 'Unauthorized'}),
            headers: {
              'content-type': 'application/json',
              'www-authenticate': _getWwwAuthenticateHeader(),
            },
          );
        }

        return innerHandler(request);
      };
    };
  }

  bool _validateRequest(Request request) {
    switch (mode) {
      case AuthMode.apiKey:
        return _validateApiKey(request);
      case AuthMode.jwt:
        return _validateJwt(request);
      case AuthMode.basic:
        return _validateBasicAuth(request);
      case AuthMode.none:
        return true;
    }
  }

  bool _validateApiKey(Request request) {
    final authHeader = request.headers['authorization'];
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      final token = authHeader.substring(7);
      return token == apiKey;
    }

    final apiKeyHeader = request.headers['x-api-key'];
    if (apiKeyHeader != null) {
      return apiKeyHeader == apiKey;
    }

    return false;
  }

  bool _validateJwt(Request request) {
    // JWT validation would require a proper JWT library
    // For now, this is a placeholder
    _logger.warning('JWT authentication not yet implemented');
    return false;
  }

  bool _validateBasicAuth(Request request) {
    final authHeader = request.headers['authorization'];
    if (authHeader == null || !authHeader.startsWith('Basic ')) {
      return false;
    }

    try {
      final credentials = authHeader.substring(6);
      final decoded = utf8.decode(base64.decode(credentials));
      final parts = decoded.split(':');

      if (parts.length != 2) {
        return false;
      }

      return parts[0] == basicUsername && parts[1] == basicPassword;
    } catch (e) {
      _logger.warning('Invalid basic auth header: $e');
      return false;
    }
  }

  String _getWwwAuthenticateHeader() {
    switch (mode) {
      case AuthMode.apiKey:
        return 'Bearer realm="MyNAS Manager"';
      case AuthMode.jwt:
        return 'Bearer realm="MyNAS Manager"';
      case AuthMode.basic:
        return 'Basic realm="MyNAS Manager"';
      case AuthMode.none:
        return '';
    }
  }

  bool validateWebSocketRequest(Map<String, String> headers) {
    // Create a minimal request object for validation
    final request = _MockRequest(headers);
    return _validateRequest(request);
  }
}

// Helper class for WebSocket validation
class _MockRequest implements Request {
  @override
  final Map<String, String> headers;

  _MockRequest(this.headers);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
