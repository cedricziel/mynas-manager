import 'dart:async';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';
import '../interfaces/json_rpc_client.dart';
import '../interfaces/connection_manager.dart';

/// JSON-RPC 2.0 Peer client for TrueNAS WebSocket API
/// Uses json_rpc_2 package's Peer for bidirectional communication
class TrueNasPeerClient implements IJsonRpcClient {
  final _logger = Logger('TrueNasPeerClient');
  final IConnectionManager _connectionManager;
  final StreamController<JsonRpcNotification> _notificationController = 
      StreamController<JsonRpcNotification>.broadcast();
  
  json_rpc.Peer? _peer;
  StreamSubscription? _stateSubscription;
  Timer? _keepAliveTimer;
  bool _isReady = false;
  
  static const Duration _keepAliveInterval = Duration(seconds: 30);

  TrueNasPeerClient({
    required IConnectionManager connectionManager,
  }) : _connectionManager = connectionManager {
    _initialize();
  }

  void _initialize() {
    // Listen to connection state changes
    _stateSubscription = _connectionManager.stateStream.listen((state) {
      if (state == ConnectionState.connected) {
        _setupPeer();
      } else if (state == ConnectionState.disconnected || state == ConnectionState.error) {
        _handleDisconnection();
      }
    });

    // If already connected, setup peer immediately
    if (_connectionManager.isConnected) {
      _setupPeer();
    }
  }

  void _setupPeer() {
    try {
      // Get StreamChannel from the connection manager
      final channel = _connectionManager.getStreamChannel();

      // Create the peer
      _peer = json_rpc.Peer(channel);

      // Register notification handlers for TrueNAS events
      _registerNotificationHandlers();

      // Start listening
      _peer!.listen().then((_) {
        _logger.info('TrueNAS Peer connection closed');
        _handleDisconnection();
      }).catchError((error) {
        _logger.severe('TrueNAS Peer error: $error');
        _handleDisconnection();
      });

      _isReady = true;
      _logger.info('TrueNAS Peer client ready');
      
      // Start keepalive timer
      _startKeepAlive();
    } catch (e) {
      _logger.severe('Failed to setup peer: $e');
      _isReady = false;
    }
  }

  void _registerNotificationHandlers() {
    if (_peer == null) return;

    // Register handlers for TrueNAS notifications
    // These allow TrueNAS to push updates to us
    
    // Pool events
    _peer!.registerMethod('pool.changed', (params) {
      _handleNotification('pool.changed', params.asMap);
    });

    // Dataset events
    _peer!.registerMethod('dataset.changed', (params) {
      _handleNotification('dataset.changed', params.asMap);
    });

    // Alert events
    _peer!.registerMethod('alert.added', (params) {
      _handleNotification('alert.added', params.asMap);
    });

    _peer!.registerMethod('alert.removed', (params) {
      _handleNotification('alert.removed', params.asMap);
    });

    // System events
    _peer!.registerMethod('system.general.updated', (params) {
      _handleNotification('system.general.updated', params.asMap);
    });

    // Share events
    _peer!.registerMethod('sharing.smb.changed', (params) {
      _handleNotification('sharing.smb.changed', params.asMap);
    });

    _peer!.registerMethod('sharing.nfs.changed', (params) {
      _handleNotification('sharing.nfs.changed', params.asMap);
    });

    _logger.fine('Registered TrueNAS notification handlers');
  }

  void _handleNotification(String method, Map<String, dynamic> params) {
    _logger.fine('Received TrueNAS notification: $method');
    _notificationController.add(JsonRpcNotification(
      method: method,
      params: params,
    ));
  }

  @override
  bool get isReady => _isReady && _peer != null && _connectionManager.isConnected;

  @override
  Stream<JsonRpcNotification> get notifications => _notificationController.stream;

  @override
  Future<T> call<T>(String method, [Map<String, dynamic>? params]) async {
    if (!isReady) {
      throw StateError('TrueNAS Peer client not ready');
    }

    try {
      _logger.fine('Calling TrueNAS method: $method');
      
      // Transform parameters for TrueNAS compatibility
      final transformedParams = _transformParameters(method, params);
      
      // Make the call using the peer
      final result = await _peer!.sendRequest(method, transformedParams);
      
      _logger.fine('TrueNAS method $method completed successfully');
      return result as T;
    } catch (e) {
      if (e is json_rpc.RpcException) {
        _logger.warning('TrueNAS RPC error for $method: ${e.code} - ${e.message}');
        throw JsonRpcError(
          code: e.code,
          message: e.message,
          data: e.data,
        );
      }
      _logger.severe('Failed to call TrueNAS method $method: $e');
      rethrow;
    }
  }

  /// Transform parameters to match TrueNAS expectations
  dynamic _transformParameters(String method, Map<String, dynamic>? params) {
    // For TrueNAS, most methods require at least an empty array
    // rather than null/undefined params
    
    // Special handling for methods that take complex array parameters
    if (_requiresComplexArrayParams(method)) {
      return _buildComplexArrayParams(method, params);
    }

    // Methods that require array-style parameters
    if (_requiresArrayParams(method) && params != null) {
      return _convertToArrayParams(method, params);
    }

    // Methods that use named parameters
    if (params != null && params.isNotEmpty) {
      // Some methods still use object parameters
      if (_usesObjectParams(method)) {
        return params;
      }
      // Default to empty array for safety
      return [];
    }

    // Default: empty array for TrueNAS compatibility
    return [];
  }

  bool _usesObjectParams(String method) {
    // Methods that actually use object/named parameters
    // Most TrueNAS methods use array params, but some do use objects
    const objectParamMethods = {
      'pool.create',
      'pool.update',
      'dataset.create',
      'dataset.update',
      'share.create',
      'share.update',
    };
    return objectParamMethods.contains(method);
  }

  bool _requiresComplexArrayParams(String method) {
    const complexArrayMethods = {
      'pool.query',
      'pool.dataset.query',
      'disk.query',
      'core.subscribe',
    };
    return complexArrayMethods.contains(method);
  }

  dynamic _buildComplexArrayParams(String method, Map<String, dynamic>? params) {
    switch (method) {
      case 'pool.query':
      case 'pool.dataset.query':
      case 'disk.query':
        // These methods take [filters, options]
        // Default: empty filters array and options object
        final filters = params?['filters'] ?? [];
        final options = params?['options'] ?? {};
        return [filters, options];
      
      case 'core.subscribe':
        // Takes a single string parameter in an array
        final event = params?['event'] ?? params?['name'] ?? '';
        return [event];
      
      default:
        return [];
    }
  }

  bool _requiresArrayParams(String method) {
    const arrayParamMethods = {
      'auth.login',
      'auth.token',
      'auth.logout',
      'pool.get_disks',
      'dataset.get_quota',
    };
    return arrayParamMethods.contains(method);
  }

  List<dynamic> _convertToArrayParams(String method, Map<String, dynamic> params) {
    switch (method) {
      case 'auth.login':
        return [params['username'], params['password']];
      case 'auth.token':
        return [params['token']];
      case 'pool.get_disks':
        return [params['name']];
      case 'dataset.get_quota':
        return [params['path'], params['quota_type'] ?? 'USER'];
      default:
        return params.values.toList();
    }
  }

  void _startKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(_keepAliveInterval, (_) async {
      if (isReady) {
        try {
          _logger.fine('Sending keepalive ping');
          await call<String>('core.ping');
        } catch (e) {
          _logger.warning('Keepalive ping failed: $e');
        }
      }
    });
  }

  void _stopKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
  }

  void _handleDisconnection() {
    _logger.info('Handling disconnection - closing peer');
    
    _stopKeepAlive();
    _peer?.close();
    _peer = null;
    _isReady = false;
  }

  @override
  Future<void> close() async {
    _logger.info('Closing TrueNAS Peer client');
    
    _stopKeepAlive();
    await _stateSubscription?.cancel();
    _peer?.close();
    await _notificationController.close();
  }
}