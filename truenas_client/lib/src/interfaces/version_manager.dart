import 'dart:async';

/// TrueNAS version information
class TrueNasVersion {
  final String version;
  final String fullVersion;
  final int majorVersion;
  final int minorVersion;
  final int patchVersion;
  final bool isScale;
  final bool isCore;

  const TrueNasVersion({
    required this.version,
    required this.fullVersion,
    required this.majorVersion,
    required this.minorVersion,
    required this.patchVersion,
    required this.isScale,
    required this.isCore,
  });

  /// Parse version string like "TrueNAS-25.04.0" or "TrueNAS-SCALE-24.10.2.1"
  factory TrueNasVersion.parse(String versionString) {
    final fullVersion = versionString;
    final isScale =
        versionString.contains('-SCALE-') ||
        (!versionString.contains('-CORE-') &&
            versionString.startsWith('TrueNAS-'));
    final isCore = versionString.contains('-CORE-');

    // Extract version numbers
    String versionPart;
    if (versionString.contains('-SCALE-')) {
      versionPart = versionString.split('-SCALE-')[1];
    } else if (versionString.contains('-CORE-')) {
      versionPart = versionString.split('-CORE-')[1];
    } else if (versionString.startsWith('TrueNAS-')) {
      // New format: TrueNAS-25.04.0
      versionPart = versionString.substring('TrueNAS-'.length);
    } else {
      versionPart = versionString;
    }

    final parts = versionPart.split('.');
    final major = int.tryParse(parts.isNotEmpty ? parts[0] : '0') ?? 0;
    final minor = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    final patch = int.tryParse(parts.length > 2 ? parts[2] : '0') ?? 0;

    return TrueNasVersion(
      version: versionPart,
      fullVersion: fullVersion,
      majorVersion: major,
      minorVersion: minor,
      patchVersion: patch,
      isScale: isScale,
      isCore: isCore,
    );
  }

  /// Check if this version supports a specific feature
  bool supportsFeature(String feature) {
    switch (feature) {
      case 'json_rpc_websocket':
        return majorVersion >= 25; // JSON-RPC over WebSocket in 25.04+
      case 'legacy_rest_api':
        return majorVersion <
            26; // REST API deprecated in 25.04, removed in future
      case 'api_versioning':
        return majorVersion >= 25; // API versioning in 25.04+
      case 'enhanced_auth':
        return majorVersion >= 25; // Enhanced auth features
      default:
        return true; // Assume feature is available if not specified
    }
  }

  /// Compare versions
  int compareTo(TrueNasVersion other) {
    if (majorVersion != other.majorVersion) {
      return majorVersion.compareTo(other.majorVersion);
    }
    if (minorVersion != other.minorVersion) {
      return minorVersion.compareTo(other.minorVersion);
    }
    return patchVersion.compareTo(other.patchVersion);
  }

  bool operator >(TrueNasVersion other) => compareTo(other) > 0;
  bool operator <(TrueNasVersion other) => compareTo(other) < 0;
  bool operator >=(TrueNasVersion other) => compareTo(other) >= 0;
  bool operator <=(TrueNasVersion other) => compareTo(other) <= 0;

  @override
  String toString() => fullVersion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrueNasVersion &&
          runtimeType == other.runtimeType &&
          fullVersion == other.fullVersion;

  @override
  int get hashCode => fullVersion.hashCode;
}

/// Manages TrueNAS version detection and compatibility
abstract class IVersionManager {
  /// Current detected version
  TrueNasVersion? get currentVersion;

  /// Detect the TrueNAS version
  Future<TrueNasVersion> detectVersion();

  /// Check if a feature is supported by the current version
  bool isFeatureSupported(String feature);

  /// Check if a specific version supports a feature
  bool isFeatureSupportedByVersion(String feature, TrueNasVersion version);

  /// Get the recommended API endpoint for the current version
  String getRecommendedApiEndpoint();

  /// Check if current version is compatible with client
  bool isVersionCompatible();
}
