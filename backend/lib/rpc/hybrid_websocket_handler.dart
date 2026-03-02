import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';
import 'package:mynas_backend/services/session_manager.dart'
    show SessionManager, UserSession, SessionEvent;

/// Handles WebSocket connections with hybrid authentication support.
///
/// This handler supports two authentication modes:
/// 1. API Key authentication - for backend services and automation
/// 2. Session-based authentication - for frontend user interactions
///
/// Both modes can be used simultaneously on the same connection.
class HybridWebSocketHandler {
  final _logger = Logger('HybridWebSocketHandler');
  final WebSocketChannel _channel;
  final SessionManager _sessionManager;
  final ITrueNasClient? _sharedClient; // For API key authenticated operations
  final String _defaultTrueNasUrl;
  late final json_rpc.Peer _peer;

  // Current session for this connection (if using session auth)
  UserSession? _currentSession;

  // Connection status stream
  final _connectionStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription<ConnectionStatus>? _heartbeatSubscription;
  StreamSubscription<SessionEvent>? _sessionEventSubscription;

  HybridWebSocketHandler(
    this._channel,
    this._sessionManager,
    this._sharedClient,
    this._defaultTrueNasUrl,
  );

  void start() {
    _logger.info('New hybrid WebSocket connection established');

    // Create JSON-RPC peer
    _peer = json_rpc.Peer(_channel.cast<String>());

    // Register all methods
    _registerMethods();

    // Listen for session events
    _sessionEventSubscription = _sessionManager.sessionEvents.listen((event) {
      // Only notify about events for the current session
      if (_currentSession != null && event.sessionId == _currentSession!.id) {
        _notifySessionEvent(event);
      }
    });

    // Start listening
    _peer
        .listen()
        .then((_) {
          _logger.info('WebSocket connection closed');
          _cleanup();
        })
        .catchError((error) {
          _logger.severe('WebSocket error: $error');
          _cleanup();
        });
  }

  void _registerMethods() {
    // Authentication methods (always available)
    _peer.registerMethod('auth.login', _login);
    _peer.registerMethod('auth.logout', _logout);
    _peer.registerMethod('session.heartbeat', _sessionHeartbeat);
    _peer.registerMethod('session.info', _getSessionInfo);

    // System methods (can use either auth method)
    _peer.registerMethod('system.info', _withHybridAuth(_getSystemInfo));
    _peer.registerMethod('system.alerts', _withHybridAuth(_getAlerts));

    // Pool methods
    _peer.registerMethod('pool.list', _withHybridAuth(_listPools));
    _peer.registerMethod('pool.get', _withHybridAuth(_getPool));

    // Dataset methods
    _peer.registerMethod('dataset.list', _withHybridAuth(_listDatasets));
    _peer.registerMethod('dataset.get', _withHybridAuth(_getDataset));
    _peer.registerMethod('dataset.create', _withHybridAuth(_createDataset));

    // Share methods
    _peer.registerMethod('share.list', _withHybridAuth(_listShares));
    _peer.registerMethod('share.get', _withHybridAuth(_getShare));
    _peer.registerMethod('share.create', _withHybridAuth(_createShare));
    _peer.registerMethod('share.update', _withHybridAuth(_updateShare));
    _peer.registerMethod('share.delete', _withHybridAuth(_deleteShare));
  }

  // Get the appropriate TrueNAS client based on authentication
  ITrueNasClient? _getClient() {
    // Prefer session client if available (user-specific permissions)
    if (_currentSession != null) {
      return _currentSession!.trueNasClient;
    }
    // Fall back to shared client (API key auth)
    return _sharedClient;
  }

  // Wrapper to ensure methods have a valid client (either session or shared)
  Function _withHybridAuth(Function method) {
    return (json_rpc.Parameters params) async {
      final client = _getClient();
      if (client == null) {
        throw json_rpc.RpcException(
          401,
          'Not authenticated. Please login or configure API key authentication.',
        );
      }
      return await method(params, client);
    };
  }

  // Authentication methods
  Future<Map<String, dynamic>> _login(json_rpc.Parameters params) async {
    final username = params['username'].asString;
    final password = params['password'].asString;
    final trueNasUrl = params['trueNasUrl'].asStringOr(_defaultTrueNasUrl);

    _logger.info('Login attempt for user: $username');

    try {
      // Create a new TrueNAS client for this user
      final trueNasClient = TrueNasClient.withCredentials(
        uri: trueNasUrl,
        username: username,
        password: password,
      );

      // Attempt to connect and authenticate
      await trueNasClient.connect();

      // Get user info from TrueNAS
      final userInfo = await trueNasClient.getSystemInfo();

      // Create session
      _currentSession = await _sessionManager.createSession(
        username: username,
        trueNasClient: trueNasClient,
        userInfo: {'hostname': userInfo.hostname, 'version': userInfo.version},
      );

      // Start monitoring this user's TrueNAS connection
      _currentSession!.startHeartbeatMonitoring((status) {
        _notifyConnectionStatus(status);
      });

      _logger.info('Login successful for user: $username');

      return {
        'success': true,
        'sessionId': _currentSession!.id,
        'username': username,
        'userInfo': _currentSession!.userInfo,
      };
    } catch (e) {
      _logger.warning('Login failed for user $username: $e');
      throw json_rpc.RpcException(
        401,
        'Authentication failed: ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>> _logout(json_rpc.Parameters params) async {
    if (_currentSession != null) {
      await _sessionManager.removeSession(_currentSession!.id);
      _currentSession = null;
    }
    return {'success': true};
  }

  Future<Map<String, dynamic>> _sessionHeartbeat(
    json_rpc.Parameters params,
  ) async {
    if (_currentSession == null) {
      throw json_rpc.RpcException(401, 'No active session');
    }

    await _sessionManager.updateSessionActivity(_currentSession!.id);

    // Calculate time remaining before inactivity timeout
    final now = DateTime.now();
    final timeSinceActivity = now.difference(_currentSession!.lastActivity);
    final timeRemaining = _sessionManager.inactivityTimeout - timeSinceActivity;

    return {
      'success': true,
      'timestamp': now.toIso8601String(),
      'sessionStatus': {
        'active': true,
        'timeRemainingSeconds': timeRemaining.inSeconds,
        'expiresAt': now.add(timeRemaining).toIso8601String(),
      },
    };
  }

  Future<Map<String, dynamic>> _getSessionInfo(
    json_rpc.Parameters params,
  ) async {
    if (_currentSession == null) {
      return {
        'authenticated': false,
        'authMethod': _sharedClient != null ? 'apiKey' : 'none',
      };
    }

    return {
      'authenticated': true,
      'authMethod': 'session',
      ..._currentSession!.toJson(),
    };
  }

  void _notifyConnectionStatus(ConnectionStatus status) {
    if (!_connectionStatusController.isClosed) {
      _connectionStatusController.add({
        'status': status.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Send notification to client
      try {
        _peer.sendNotification('truenas.connectionStatusChanged', {
          'status': status.name,
          'timestamp': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        _logger.warning('Failed to send connection status notification: $e');
      }
    }
  }

  void _notifySessionEvent(SessionEvent event) {
    try {
      _peer.sendNotification('session.event', event.toJson());
      _logger.info(
        'Sent session event: ${event.type.name} for session ${event.sessionId}',
      );
    } catch (e) {
      _logger.warning('Failed to send session event notification: $e');
    }
  }

  // System methods
  Future<Map<String, dynamic>> _getSystemInfo(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final info = await client.getSystemInfo();
    return info.toJson();
  }

  Future<List<Map<String, dynamic>>> _getAlerts(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final alerts = await client.getAlerts();
    return alerts.map((a) => a.toJson()).toList();
  }

  // Pool methods
  Future<List<Map<String, dynamic>>> _listPools(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final pools = await client.listPools();
    return pools.map((p) => p.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getPool(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final id = params['id'].asString;
    final pool = await client.getPool(id);
    return pool.toJson();
  }

  // Dataset methods
  Future<List<Map<String, dynamic>>> _listDatasets(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    String? poolId;
    try {
      poolId = params['poolId'].asString;
    } catch (_) {
      poolId = null;
    }
    final datasets = await client.listDatasets(poolId: poolId);
    return datasets.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDataset(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final id = params['id'].asString;
    final dataset = await client.getDataset(id);
    return dataset.toJson();
  }

  Future<Map<String, dynamic>> _createDataset(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final pool = params['pool'].asString;
    final name = params['name'].asString;
    final properties = params['properties'].asMapOr({});

    final dataset = await client.createDataset(
      pool: pool,
      name: name,
      properties: properties.cast<String, dynamic>(),
    );
    return dataset.toJson();
  }

  // Share methods
  Future<List<Map<String, dynamic>>> _listShares(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    String? type;
    try {
      type = params['type'].asString;
    } catch (_) {
      type = null;
    }
    ShareType? shareType;
    if (type != null) {
      shareType = ShareType.values.firstWhere(
        (t) => t.name == type,
        orElse: () => throw ArgumentError('Invalid share type: $type'),
      );
    }

    final shares = await client.listShares(type: shareType);
    return shares.map((s) => s.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getShare(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final id = params['id'].asString;
    final share = await client.getShare(id);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _createShare(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final shareData = Share.fromJson(params.asMap.cast<String, dynamic>());
    final share = await client.createShare(shareData);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _updateShare(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final shareData = Share.fromJson(params.asMap.cast<String, dynamic>());
    final share = await client.updateShare(shareData);
    return share.toJson();
  }

  Future<bool> _deleteShare(
    json_rpc.Parameters params,
    ITrueNasClient client,
  ) async {
    final id = params['id'].asString;
    return await client.deleteShare(id);
  }

  void notifyConnectionStatus(ConnectionStatus status) {
    _notifyConnectionStatus(status);
  }

  void _cleanup() {
    _heartbeatSubscription?.cancel();
    _sessionEventSubscription?.cancel();
    _connectionStatusController.close();
    // Note: We don't remove the session here as the user might reconnect
  }

  void dispose() {
    _cleanup();
    // Stop heartbeat monitoring to prevent memory leaks when connection is closed
    if (_currentSession != null) {
      _logger.info(
        'Stopping heartbeat monitoring for session ${_currentSession!.id}',
      );
      _currentSession!.stopHeartbeatMonitoring();
      // We keep the session alive in case the user reconnects
      // The session will eventually be cleaned up by SessionManager's cleanup timer
    }
  }
}
