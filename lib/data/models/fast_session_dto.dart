import 'package:hive/hive.dart';

import '../../core/hive/hive_constants.dart';
import '../../domain/entities/fast_protocol_entity.dart';
import '../../domain/entities/fast_session_entity.dart';

class FastSessionDto {
  final String id;
  final int protocolType;
  final int fastingHours;
  final int eatingHours;
  final String protocolLabel;
  final int startTimeMicros;
  final int? endTimeMicros;
  final int? pausedAtMicros;
  final int pausedDurationMicros;
  final int statusIndex;

  const FastSessionDto({
    required this.id,
    required this.protocolType,
    required this.fastingHours,
    required this.eatingHours,
    required this.protocolLabel,
    required this.startTimeMicros,
    this.endTimeMicros,
    this.pausedAtMicros,
    required this.pausedDurationMicros,
    required this.statusIndex,
  });

  factory FastSessionDto.fromEntity(FastSessionEntity s) => FastSessionDto(
        id: s.id,
        protocolType: s.protocol.type.index,
        fastingHours: s.protocol.fastingHours,
        eatingHours: s.protocol.eatingHours,
        protocolLabel: s.protocol.label,
        startTimeMicros: s.startTime.microsecondsSinceEpoch,
        endTimeMicros: s.endTime?.microsecondsSinceEpoch,
        pausedAtMicros: s.pausedAt?.microsecondsSinceEpoch,
        pausedDurationMicros: s.pausedDuration.inMicroseconds,
        statusIndex: s.status.index,
      );

  FastSessionEntity toEntity() {
    final protType = ProtocolType.values[protocolType];
    final protocol = FastProtocolEntity(
      type: protType,
      fastingHours: fastingHours,
      eatingHours: eatingHours,
      label: protocolLabel,
    );
    return FastSessionEntity(
      id: id,
      protocol: protocol,
      startTime: DateTime.fromMicrosecondsSinceEpoch(startTimeMicros),
      endTime: endTimeMicros != null
          ? DateTime.fromMicrosecondsSinceEpoch(endTimeMicros!)
          : null,
      pausedAt: pausedAtMicros != null
          ? DateTime.fromMicrosecondsSinceEpoch(pausedAtMicros!)
          : null,
      pausedDuration: Duration(microseconds: pausedDurationMicros),
      status: FastStatus.values[statusIndex],
    );
  }
}

class FastSessionDtoAdapter extends TypeAdapter<FastSessionDto> {
  @override
  final int typeId = HiveTypeIds.fastSession;

  @override
  FastSessionDto read(BinaryReader reader) {
    return FastSessionDto(
      id: reader.readString(),
      protocolType: reader.readInt(),
      fastingHours: reader.readInt(),
      eatingHours: reader.readInt(),
      protocolLabel: reader.readString(),
      startTimeMicros: reader.readInt(),
      endTimeMicros: reader.readBool() ? reader.readInt() : null,
      pausedAtMicros: reader.readBool() ? reader.readInt() : null,
      pausedDurationMicros: reader.readInt(),
      statusIndex: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, FastSessionDto obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.protocolType);
    writer.writeInt(obj.fastingHours);
    writer.writeInt(obj.eatingHours);
    writer.writeString(obj.protocolLabel);
    writer.writeInt(obj.startTimeMicros);
    writer.writeBool(obj.endTimeMicros != null);
    if (obj.endTimeMicros != null) writer.writeInt(obj.endTimeMicros!);
    writer.writeBool(obj.pausedAtMicros != null);
    if (obj.pausedAtMicros != null) writer.writeInt(obj.pausedAtMicros!);
    writer.writeInt(obj.pausedDurationMicros);
    writer.writeInt(obj.statusIndex);
  }
}
