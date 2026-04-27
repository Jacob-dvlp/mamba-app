import 'package:equatable/equatable.dart';
import 'fast_protocol_entity.dart';

enum FastStatus { idle, running, paused, completed }

class FastSessionEntity extends Equatable {
  final String id;
  final FastProtocolEntity protocol;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime? pausedAt;
  final Duration pausedDuration;
  final FastStatus status;

  const FastSessionEntity({
    required this.id,
    required this.protocol,
    required this.startTime,
    this.endTime,
    this.pausedAt,
    this.pausedDuration = Duration.zero,
    required this.status,
  });

  Duration get elapsed {
    if (status == FastStatus.idle) return Duration.zero;

    final base = (endTime ?? DateTime.now()).difference(startTime);
    final extraPause = (status == FastStatus.paused && pausedAt != null)
        ? DateTime.now().difference(pausedAt!)
        : Duration.zero;

    final total = base - pausedDuration - extraPause;
    return total.isNegative ? Duration.zero : total;
  }

  Duration get remaining {
    final left = protocol.fastingDuration - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  double get progress {
    final p = elapsed.inSeconds / protocol.fastingDuration.inSeconds;
    return p.clamp(0.0, 1.0);
  }

  bool get isGoalReached => elapsed >= protocol.fastingDuration;

  FastSessionEntity copyWith({
    String? id,
    FastProtocolEntity? protocol,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? pausedAt,
    Duration? pausedDuration,
    FastStatus? status,
    bool clearEndTime = false,
    bool clearPausedAt = false,
  }) {
    return FastSessionEntity(
      id: id ?? this.id,
      protocol: protocol ?? this.protocol,
      startTime: startTime ?? this.startTime,
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
      pausedDuration: pausedDuration ?? this.pausedDuration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, protocol, startTime, endTime, pausedAt, pausedDuration, status];
}
