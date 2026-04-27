import 'package:hive/hive.dart';
import '../../core/hive/hive_constants.dart';
import '../../domain/entities/meal_entity.dart';

class MealDto {
  final String id;
  final String name;
  final int calories;
  final int loggedAtMicros;
  final String dailyLogId;

  const MealDto({
    required this.id,
    required this.name,
    required this.calories,
    required this.loggedAtMicros,
    required this.dailyLogId,
  });

  factory MealDto.fromEntity(MealEntity meal) => MealDto(
        id: meal.id,
        name: meal.name,
        calories: meal.calories,
        loggedAtMicros: meal.loggedAt.microsecondsSinceEpoch,
        dailyLogId: meal.dailyLogId,
      );

  MealEntity toEntity() => MealEntity(
        id: id,
        name: name,
        calories: calories,
        loggedAt: DateTime.fromMicrosecondsSinceEpoch(loggedAtMicros),
        dailyLogId: dailyLogId,
      );
}

class MealDtoAdapter extends TypeAdapter<MealDto> {
  @override
  final int typeId = HiveTypeIds.meal;

  @override
  MealDto read(BinaryReader reader) {
    return MealDto(
      id: reader.readString(),
      name: reader.readString(),
      calories: reader.readInt(),
      loggedAtMicros: reader.readInt(),
      dailyLogId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MealDto obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.calories);
    writer.writeInt(obj.loggedAtMicros);
    writer.writeString(obj.dailyLogId);
  }
}
