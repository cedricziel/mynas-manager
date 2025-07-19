import 'dart:async';
import 'package:logging/logging.dart';
import '../interfaces/version_manager.dart';
import '../interfaces/json_rpc_client.dart';

/// TrueNAS version detection and compatibility manager
class TrueNasVersionManager implements IVersionManager {
  final _logger = Logger('TrueNasVersionManager');
  final IJsonRpcClient _jsonRpcClient;
  
  TrueNasVersion? _currentVersion;

  TrueNasVersionManager({
    required IJsonRpcClient jsonRpcClient,
  }) : _jsonRpcClient = jsonRpcClient;

  @override
  TrueNasVersion? get currentVersion => _currentVersion;

  @override
  Future<TrueNasVersion> detectVersion() async {
    _logger.info('Detecting TrueNAS version');

    try {
      // Try different version detection methods in order of preference
      dynamic result;
      
      // Method 1: Try system.info (most common)
      try {
        result = await _jsonRpcClient.call('system.info');
        if (result is Map<String, dynamic> && result.containsKey('version')) {
          result = result['version'];
        }
      } catch (e) {
        _logger.fine('system.info failed: $e');
        
        // Method 2: Try system.version
        try {
          result = await _jsonRpcClient.call('system.version');
        } catch (e2) {
          _logger.fine('system.version failed: $e2');
          
          // Method 3: Try core.get_version (legacy)
          try {
            result = await _jsonRpcClient.call('core.get_version');
          } catch (e3) {
            _logger.fine('core.get_version failed: $e3');
            
            // Method 4: Try system.general.version
            try {
              result = await _jsonRpcClient.call('system.general.version');
            } catch (e4) {
              _logger.warning('All version detection methods failed. Assuming default version.');
              // Fallback to a reasonable default
              result = 'TrueNAS-SCALE-24.04.0';
            }
          }
        }
      }

      String versionString;
      if (result is String) {
        versionString = result;
      } else if (result is Map<String, dynamic>) {
        // Extract version from object response
        versionString = result['version'] ?? 
                       result['fullversion'] ?? 
                       result['name'] ?? 
                       'unknown';
      } else {
        throw Exception('Unexpected version response type: ${result.runtimeType}');
      }

      _currentVersion = TrueNasVersion.parse(versionString);
      _logger.info('Detected TrueNAS version: $_currentVersion');
      
      return _currentVersion!;
    } catch (e) {
      _logger.severe('Failed to detect TrueNAS version: $e');
      rethrow;
    }
  }

  @override
  bool isFeatureSupported(String feature) {
    if (_currentVersion == null) {
      _logger.warning('Version not detected, assuming feature is supported: $feature');
      return true;
    }
    
    return isFeatureSupportedByVersion(feature, _currentVersion!);
  }

  @override
  bool isFeatureSupportedByVersion(String feature, TrueNasVersion version) {
    return version.supportsFeature(feature);
  }

  @override
  String getRecommendedApiEndpoint() {
    if (_currentVersion == null) {
      _logger.warning('Version not detected, using default endpoint');
      return '/api/current';
    }

    if (_currentVersion!.supportsFeature('api_versioning')) {
      // Use versioned endpoint for TrueNAS 25.04+
      return '/api/v${_currentVersion!.majorVersion}.${_currentVersion!.minorVersion}';
    } else {
      // Use current endpoint for older versions
      return '/api/current';
    }
  }

  @override
  bool isVersionCompatible() {
    if (_currentVersion == null) {
      return false;
    }

    // Define minimum supported version
    const minVersion = TrueNasVersion(
      version: '24.04.0',
      fullVersion: 'TrueNAS-SCALE-24.04.0',
      majorVersion: 24,
      minorVersion: 4,
      patchVersion: 0,
      isScale: true,
      isCore: false,
    );

    // Check if current version meets minimum requirements
    if (_currentVersion! < minVersion) {
      _logger.warning('TrueNAS version $_currentVersion is below minimum supported version $minVersion');
      return false;
    }

    // Check if it's a supported platform (SCALE only for now)
    if (!_currentVersion!.isScale) {
      _logger.warning('TrueNAS Core is not supported, only TrueNAS SCALE');
      return false;
    }

    return true;
  }

  /// Get feature capabilities for the current version
  Map<String, bool> getFeatureCapabilities() {
    if (_currentVersion == null) {
      return {};
    }

    return {
      'json_rpc_websocket': _currentVersion!.supportsFeature('json_rpc_websocket'),
      'legacy_rest_api': _currentVersion!.supportsFeature('legacy_rest_api'),
      'api_versioning': _currentVersion!.supportsFeature('api_versioning'),
      'enhanced_auth': _currentVersion!.supportsFeature('enhanced_auth'),
      'vm_management': _currentVersion!.majorVersion >= 24,
      'app_management': _currentVersion!.majorVersion >= 24,
      'advanced_networking': _currentVersion!.majorVersion >= 24,
      'snapshot_management': true, // Available in all supported versions
      'replication': true, // Available in all supported versions
    };
  }

  /// Get recommended client configuration for the current version
  Map<String, dynamic> getRecommendedClientConfig() {
    final capabilities = getFeatureCapabilities();
    
    return {
      'use_websocket': capabilities['json_rpc_websocket'] ?? false,
      'use_rest_fallback': capabilities['legacy_rest_api'] ?? true,
      'api_endpoint': getRecommendedApiEndpoint(),
      'auth_methods': capabilities['enhanced_auth'] == true 
          ? ['api_key', 'credentials'] 
          : ['credentials'],
      'supported_features': capabilities.keys.where((k) => capabilities[k] == true).toList(),
    };
  }
}