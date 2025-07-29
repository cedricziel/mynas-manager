import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import '../interfaces/json_rpc_client.dart';
import '../interfaces/connection_manager.dart';

/// JSON-RPC 2.0 client over WebSocket
class JsonRpcWebSocketClient implements IJsonRpcClient {
  final _logger = Logger('JsonRpcWebSocketClient');
  final IConnectionManager _connectionManager;
  final StreamController<JsonRpcNotification> _notificationController =
      StreamController<JsonRpcNotification>.broadcast();

  final Map<String, Completer<dynamic>> _pendingRequests = {};
  StreamSubscription<dynamic>? _messageSubscription;
  int _requestId = 1;
  bool _isReady = false;

  JsonRpcWebSocketClient({required IConnectionManager connectionManager})
    : _connectionManager = connectionManager {
    _initialize();
  }

  void _initialize() {
    // Listen to connection state changes
    _connectionManager.stateStream.listen((state) {
      _isReady = state == ConnectionState.connected;
      if (state == ConnectionState.disconnected ||
          state == ConnectionState.error) {
        _handleDisconnection();
      }
    });

    // Listen to incoming messages
    _messageSubscription = _connectionManager.messageStream.listen(
      _handleMessage,
      onError: (Object error) {
        _logger.severe('Message stream error: $error');
      },
    );
  }

  @override
  bool get isReady => _isReady && _connectionManager.isConnected;

  @override
  Stream<JsonRpcNotification> get notifications =>
      _notificationController.stream;

  @override
  Future<T> call<T>(String method, [Map<String, dynamic>? params]) async {
    if (!isReady) {
      throw StateError('JSON-RPC client not ready');
    }

    final id = (_requestId++).toString();
    final request = _buildRequest(method, params, id);
    final completer = Completer<T>();

    _pendingRequests[id] = completer;

    try {
      final requestJson = jsonEncode(request);
      _logger.fine('Sending JSON-RPC request: $method (id: $id)');

      await _connectionManager.send(requestJson);

      // Set timeout for the request
      Timer(const Duration(seconds: 30), () {
        if (_pendingRequests.containsKey(id)) {
          _pendingRequests.remove(id);
          if (!completer.isCompleted) {
            completer.completeError(
              TimeoutException(
                'JSON-RPC request timeout',
                const Duration(seconds: 30),
              ),
            );
          }
        }
      });

      return await completer.future;
    } catch (e) {
      _pendingRequests.remove(id);
      _logger.severe('Failed to send JSON-RPC request: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _buildRequest(
    String method,
    Map<String, dynamic>? params,
    String id,
  ) {
    final request = <String, dynamic>{
      'jsonrpc': '2.0',
      'method': method,
      'id': id,
    };

    if (params != null && params.isNotEmpty) {
      // TrueNAS expects parameters in different formats depending on the method
      if (_shouldUseArrayParams(method)) {
        // Convert to array format for methods that require it
        request['params'] = _convertToArrayParams(method, params);
      } else {
        // Use object format for methods that support it
        request['params'] = params;
      }
    } else if (_requiresEmptyParams(method)) {
      // Some methods require an empty array even when no parameters
      request['params'] = <dynamic>[];
    }

    return request;
  }

  bool _requiresEmptyParams(String method) {
    // TrueNAS methods that require empty array [] even when no parameters
    const emptyParamMethods = {
      'pool.query',
      'dataset.query',
      'share.query',
      'auth.me',
      'system.info',
      'alert.list',
    };
    return emptyParamMethods.contains(method);
  }

  bool _shouldUseArrayParams(String method) {
    // Methods that require array-style parameters
    const arrayParamMethods = {
      'auth.login',
      'auth.login_with_api_key',
      'auth.token',
      'auth.logout',
      'auth.me',
    };
    return arrayParamMethods.contains(method);
  }

  List<dynamic> _convertToArrayParams(
    String method,
    Map<String, dynamic> params,
  ) {
    switch (method) {
      case 'auth.login':
        return [params['username'], params['password']];
      case 'auth.login_with_api_key':
      case 'auth.token':
        return [params['api_key'] ?? params['token']];
      default:
        // Default: convert to array of values
        return params.values.toList();
    }
  }

  void _handleMessage(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      _logger.fine(
        'Received JSON-RPC message: ${data['method'] ?? data['id'] ?? 'unknown'}',
      );

      if (_isResponse(data)) {
        _handleResponse(data);
      } else if (_isNotification(data)) {
        _handleNotification(data);
      } else {
        _logger.warning('Unknown JSON-RPC message format: $data');
      }
    } catch (e) {
      _logger.severe('Failed to parse JSON-RPC message: $e');
    }
  }

  bool _isResponse(Map<String, dynamic> data) {
    return data.containsKey('id') &&
        (data.containsKey('result') || data.containsKey('error'));
  }

  bool _isNotification(Map<String, dynamic> data) {
    return data.containsKey('method') && !data.containsKey('id');
  }

  void _handleResponse(Map<String, dynamic> data) {
    final id = data['id']?.toString();
    if (id == null) {
      _logger.warning('Response missing ID: $data');
      return;
    }

    final completer = _pendingRequests.remove(id);
    if (completer == null) {
      _logger.warning('No pending request for ID: $id');
      return;
    }

    if (data.containsKey('error')) {
      final error = JsonRpcError.fromJson(
        data['error'] as Map<String, dynamic>,
      );
      _logger.warning('JSON-RPC error response: $error');
      completer.completeError(error);
    } else if (data.containsKey('result')) {
      _logger.fine('JSON-RPC success response for ID: $id');
      completer.complete(data['result']);
    } else {
      _logger.warning('Response missing result and error: $data');
      completer.completeError(
        const JsonRpcError(
          code: -32603,
          message: 'Invalid response: missing result and error',
        ),
      );
    }
  }

  void _handleNotification(Map<String, dynamic> data) {
    try {
      final notification = JsonRpcNotification.fromJson(data);
      _logger.fine('Received notification: ${notification.method}');
      _notificationController.add(notification);
    } catch (e) {
      _logger.severe('Failed to parse notification: $e');
    }
  }

  void _handleDisconnection() {
    _logger.info(
      'Handling disconnection - completing pending requests with error',
    );

    const error = JsonRpcError(code: -32000, message: 'Connection lost');

    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    }

    _pendingRequests.clear();
    _isReady = false;
  }

  @override
  Future<void> close() async {
    _logger.info('Closing JSON-RPC client');

    await _messageSubscription?.cancel();

    // Complete any pending requests with error
    const error = JsonRpcError(code: -32000, message: 'Client closed');

    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    }

    _pendingRequests.clear();
    await _notificationController.close();
  }
}
