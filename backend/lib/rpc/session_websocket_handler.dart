import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:logging/logging.dart';
import 'package:truenas_client/truenas_client.dart';
import 'package:mynas_backend/services/session_manager.dart';

class SessionWebSocketHandler {
  final _logger = Logger('SessionWebSocketHandler');
  final WebSocketChannel _channel;
  final SessionManager _sessionManager;
  final String _defaultTrueNasUrl;
  late final json_rpc.Peer _peer;

  // Current session for this connection
  UserSession? _currentSession;

  // Connection status stream
  final _connectionStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription<ConnectionStatus>? _heartbeatSubscription;

  SessionWebSocketHandler(
    this._channel,
    this._sessionManager,
    this._defaultTrueNasUrl,
  );

  void start() {
    _logger.info('New WebSocket connection established');

    // Create JSON-RPC peer
    _peer = json_rpc.Peer(_channel.cast<String>());

    // Register all methods
    _registerMethods();

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
    // Authentication methods
    _peer.registerMethod('auth.login', _login);
    _peer.registerMethod('auth.logout', _logout);
    _peer.registerMethod('session.heartbeat', _sessionHeartbeat);
    _peer.registerMethod('session.info', _getSessionInfo);

    // System methods (require session)
    _peer.registerMethod('system.info', _withSession(_getSystemInfo));
    _peer.registerMethod('system.alerts', _withSession(_getAlerts));

    // Pool methods (require session)
    _peer.registerMethod('pool.list', _withSession(_listPools));
    _peer.registerMethod('pool.get', _withSession(_getPool));

    // Dataset methods (require session)
    _peer.registerMethod('dataset.list', _withSession(_listDatasets));
    _peer.registerMethod('dataset.get', _withSession(_getDataset));
    _peer.registerMethod('dataset.create', _withSession(_createDataset));

    // Share methods (require session)
    _peer.registerMethod('share.list', _withSession(_listShares));
    _peer.registerMethod('share.get', _withSession(_getShare));
    _peer.registerMethod('share.create', _withSession(_createShare));
    _peer.registerMethod('share.update', _withSession(_updateShare));
    _peer.registerMethod('share.delete', _withSession(_deleteShare));
  }

  // Wrapper to ensure methods require a valid session
  Function _withSession(Function method) {
    return (json_rpc.Parameters params) async {
      if (_currentSession == null) {
        throw json_rpc.RpcException(
          401,
          'Not authenticated. Please login first.',
        );
      }
      return await method(params);
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
      throw json_rpc.RpcException(401, 'Not authenticated');
    }

    await _sessionManager.updateSessionActivity(_currentSession!.id);

    return {'success': true, 'timestamp': DateTime.now().toIso8601String()};
  }

  Future<Map<String, dynamic>> _getSessionInfo(
    json_rpc.Parameters params,
  ) async {
    if (_currentSession == null) {
      throw json_rpc.RpcException(401, 'Not authenticated');
    }

    return _currentSession!.toJson();
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

  // System methods
  Future<Map<String, dynamic>> _getSystemInfo(
    json_rpc.Parameters params,
  ) async {
    final info = await _currentSession!.trueNasClient.getSystemInfo();
    return info.toJson();
  }

  Future<List<Map<String, dynamic>>> _getAlerts(
    json_rpc.Parameters params,
  ) async {
    final alerts = await _currentSession!.trueNasClient.getAlerts();
    return alerts.map((a) => a.toJson()).toList();
  }

  // Pool methods
  Future<List<Map<String, dynamic>>> _listPools(
    json_rpc.Parameters params,
  ) async {
    final pools = await _currentSession!.trueNasClient.listPools();
    return pools.map((p) => p.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getPool(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final pool = await _currentSession!.trueNasClient.getPool(id);
    return pool.toJson();
  }

  // Dataset methods
  Future<List<Map<String, dynamic>>> _listDatasets(
    json_rpc.Parameters params,
  ) async {
    String? poolId;
    try {
      poolId = params['poolId'].asString;
    } catch (_) {
      poolId = null;
    }
    final datasets = await _currentSession!.trueNasClient.listDatasets(
      poolId: poolId,
    );
    return datasets.map((d) => d.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getDataset(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final dataset = await _currentSession!.trueNasClient.getDataset(id);
    return dataset.toJson();
  }

  Future<Map<String, dynamic>> _createDataset(
    json_rpc.Parameters params,
  ) async {
    final pool = params['pool'].asString;
    final name = params['name'].asString;
    final properties = params['properties'].asMapOr({});

    final dataset = await _currentSession!.trueNasClient.createDataset(
      pool: pool,
      name: name,
      properties: properties.cast<String, dynamic>(),
    );
    return dataset.toJson();
  }

  // Share methods
  Future<List<Map<String, dynamic>>> _listShares(
    json_rpc.Parameters params,
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

    final shares = await _currentSession!.trueNasClient.listShares(
      type: shareType,
    );
    return shares.map((s) => s.toJson()).toList();
  }

  Future<Map<String, dynamic>> _getShare(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    final share = await _currentSession!.trueNasClient.getShare(id);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _createShare(json_rpc.Parameters params) async {
    final shareData = Share.fromJson(params.asMap.cast<String, dynamic>());
    final share = await _currentSession!.trueNasClient.createShare(shareData);
    return share.toJson();
  }

  Future<Map<String, dynamic>> _updateShare(json_rpc.Parameters params) async {
    final shareData = Share.fromJson(params.asMap.cast<String, dynamic>());
    final share = await _currentSession!.trueNasClient.updateShare(shareData);
    return share.toJson();
  }

  Future<bool> _deleteShare(json_rpc.Parameters params) async {
    final id = params['id'].asString;
    return await _currentSession!.trueNasClient.deleteShare(id);
  }

  void _cleanup() {
    _heartbeatSubscription?.cancel();
    _connectionStatusController.close();
    // Note: We don't remove the session here as the user might reconnect
  }

  void dispose() {
    _cleanup();
  }
}
