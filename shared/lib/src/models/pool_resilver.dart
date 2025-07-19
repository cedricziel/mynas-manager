import 'package:freezed_annotation/freezed_annotation.dart';

part 'pool_resilver.freezed.dart';
part 'pool_resilver.g.dart';

@freezed
class PoolResilver with _$PoolResilver {
  const factory PoolResilver({
    required String pool,
    required ResilverStatus status,
    required DateTime? startTime,
    required DateTime? estimatedEndTime,
    required int? bytesProcessed,
    required int? totalBytes,
    required double? percentComplete,
    required int? bytesPerSecond,
    required int? errorsFound,
    String? description,
  }) = _PoolResilver;

  factory PoolResilver.fromJson(Map<String, dynamic> json) => _$PoolResilverFromJson(json);
}

enum ResilverStatus {
  @JsonValue('RUNNING')
  running,
  @JsonValue('FINISHED')
  finished,
  @JsonValue('CANCELED')
  canceled,
  @JsonValue('ERROR')
  error,
  @JsonValue('IDLE')
  idle,
}