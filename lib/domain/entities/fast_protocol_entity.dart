import 'package:equatable/equatable.dart';

enum ProtocolType { twelve12, sixteen8, eighteen6, custom }

class FastProtocolEntity extends Equatable {
  final ProtocolType type;
  final int fastingHours;
  final int eatingHours;
  final String label;

  const FastProtocolEntity({
    required this.type,
    required this.fastingHours,
    required this.eatingHours,
    required this.label,
  });

  static const twelve12 = FastProtocolEntity(
    type: ProtocolType.twelve12,
    fastingHours: 12,
    eatingHours: 12,
    label: '12:12',
  );

  static const sixteen8 = FastProtocolEntity(
    type: ProtocolType.sixteen8,
    fastingHours: 16,
    eatingHours: 8,
    label: '16:8',
  );

  static const eighteen6 = FastProtocolEntity(
    type: ProtocolType.eighteen6,
    fastingHours: 18,
    eatingHours: 6,
    label: '18:6',
  );

  factory FastProtocolEntity.custom({
    required int fastingHours,
    required int eatingHours,
  }) {
    return FastProtocolEntity(
      type: ProtocolType.custom,
      fastingHours: fastingHours,
      eatingHours: eatingHours,
      label: '$fastingHours:$eatingHours',
    );
  }

  Duration get fastingDuration => Duration(hours: fastingHours);

  @override
  List<Object?> get props => [type, fastingHours, eatingHours, label];
}
