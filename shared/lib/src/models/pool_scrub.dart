import 'package:freezed_annotation/freezed_annotation.dart';

part 'pool_scrub.freezed.dart';
part 'pool_scrub.g.dart';

@freezed
class PoolScrub with _$PoolScrub {
  const factory PoolScrub({
    required String id,
    required String pool,
    required ScrubStatus status,
    required DateTime? startTime,
    required DateTime? endTime,
    required int? duration, // seconds
    required int? bytesProcessed,
    required int? bytesPerSecond,
    required int? errorsFound,
    required String description,
    @Default(false) bool enabled,
    String? schedule, // cron expression
  }) = _PoolScrub;

  factory PoolScrub.fromJson(Map<String, dynamic> json) => _$PoolScrubFromJson(json);
}

@freezed
class PoolScrubTask with _$PoolScrubTask {
  const factory PoolScrubTask({
    required String id,
    required String pool,
    required String description,
    required String schedule, // cron expression
    @Default(true) bool enabled,
    required DateTime? nextRun,
    required DateTime? lastRun,
    Map<String, dynamic>? options,
  }) = _PoolScrubTask;

  factory PoolScrubTask.fromJson(Map<String, dynamic> json) => _$PoolScrubTaskFromJson(json);
}

enum ScrubStatus {
  @JsonValue('RUNNING')
  running,
  @JsonValue('FINISHED')
  finished,
  @JsonValue('CANCELED')
  canceled,
  @JsonValue('ERROR')
  error,
  @JsonValue('WAITING')
  waiting,
}