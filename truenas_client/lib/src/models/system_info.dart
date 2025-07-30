import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_info.freezed.dart';
part 'system_info.g.dart';

@freezed
sealed class SystemInfo with _$SystemInfo {
  const factory SystemInfo({
    required String hostname,
    required String version,
    required String uptime,
    required double cpuUsage,
    required MemoryInfo memory,
    required double cpuTemperature,
    @Default([]) List<Alert> alerts,
  }) = _SystemInfo;

  factory SystemInfo.fromJson(Map<String, dynamic> json) =>
      _$SystemInfoFromJson(json);
}

@freezed
sealed class MemoryInfo with _$MemoryInfo {
  const factory MemoryInfo({
    required int total,
    required int used,
    required int free,
    required int cached,
  }) = _MemoryInfo;

  factory MemoryInfo.fromJson(Map<String, dynamic> json) =>
      _$MemoryInfoFromJson(json);
}

@freezed
sealed class Alert with _$Alert {
  const factory Alert({
    required String id,
    required AlertLevel level,
    required String message,
    required DateTime timestamp,
    @Default(false) bool dismissed,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

enum AlertLevel {
  @JsonValue('info')
  info,
  @JsonValue('warning')
  warning,
  @JsonValue('error')
  error,
  @JsonValue('critical')
  critical,
}
