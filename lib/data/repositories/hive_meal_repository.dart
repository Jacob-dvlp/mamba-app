import 'package:hive/hive.dart';

import '../../core/hive/hive_constants.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/i_meal_repository.dart';

import '../models/meal_dto.dart';

class HiveMealRepository implements IMealRepository {
  Box<MealDto> get _box => Hive.box<MealDto>(HiveBoxes.meals);

  @override
  Future<List<MealEntity>> getMealsByDate(DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return _box.values
        .where((dto) {
          final logged =
              DateTime.fromMicrosecondsSinceEpoch(dto.loggedAtMicros);
          return logged.isAfter(dayStart) && logged.isBefore(dayEnd);
        })
        .map((dto) => dto.toEntity())
        .toList()
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
  }

  @override
  Future<void> saveMeal(MealEntity meal) async {
    await _box.put(meal.id, MealDto.fromEntity(meal));
  }

  @override
  Future<void> updateMeal(MealEntity meal) async {
    await _box.put(meal.id, MealDto.fromEntity(meal));
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<MealEntity>> getMealsInRange(DateTime from, DateTime to) async {
    final fromMicros = from.microsecondsSinceEpoch;
    final toMicros = to.microsecondsSinceEpoch;

    return _box.values
        .where((dto) =>
            dto.loggedAtMicros >= fromMicros && dto.loggedAtMicros <= toMicros)
        .map((dto) => dto.toEntity())
        .toList()
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
  }
}
