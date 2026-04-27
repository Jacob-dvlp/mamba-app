import 'package:mamba_fast_tracker/domain/entities/daily_log_entity.dart';
import 'package:uuid/uuid.dart';
import '../entities/meal_entity.dart';

import '../repositories/i_fast_repository.dart';
import '../repositories/i_meal_repository.dart';

class AddMealUseCase {
  final IMealRepository _repo;
  final _uuid = const Uuid();

  AddMealUseCase(this._repo);

  Future<MealEntity> call({required String name, required int calories}) async {
    final now = DateTime.now();
    final dailyLogId = _dailyLogId(now);
    final meal = MealEntity(
      id: _uuid.v4(),
      name: name,
      calories: calories,
      loggedAt: now,
      dailyLogId: dailyLogId,
    );
    await _repo.saveMeal(meal);
    return meal;
  }

  String _dailyLogId(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class UpdateMealUseCase {
  final IMealRepository _repo;
  UpdateMealUseCase(this._repo);
  Future<void> call(MealEntity meal) => _repo.updateMeal(meal);
}

class DeleteMealUseCase {
  final IMealRepository _repo;
  DeleteMealUseCase(this._repo);
  Future<void> call(String id) => _repo.deleteMeal(id);
}

class GetMealsByDateUseCase {
  final IMealRepository _repo;
  GetMealsByDateUseCase(this._repo);
  Future<List<MealEntity>> call(DateTime date) => _repo.getMealsByDate(date);
}

class GetDailyLogUseCase {
  final IMealRepository _mealRepo;
  final IFastRepository _fastRepo;

  GetDailyLogUseCase(this._mealRepo, this._fastRepo);

  Future<DailyLogEntity> call(DateTime date) async {
    final meals = await _mealRepo.getMealsByDate(date);
    final sessions = await _fastRepo.getSessionsByDate(date: date);
    final id =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return DailyLogEntity(
      id: id,
      date: date,
      meals: meals,
      sessions: sessions,
    );
  }
}

class GetWeeklyCaloriesUseCase {
  final IMealRepository _repo;
  GetWeeklyCaloriesUseCase(this._repo);

  Future<Map<DateTime, int>> call() async {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 6));
    final meals = await _repo.getMealsInRange(from, now);

    final Map<DateTime, int> result = {};
    for (int i = 0; i < 7; i++) {
      final day = DateTime(from.year, from.month, from.day + i);
      result[day] = 0;
    }
    for (final m in meals) {
      final day = DateTime(m.loggedAt.year, m.loggedAt.month, m.loggedAt.day);
      result[day] = (result[day] ?? 0) + m.calories;
    }
    return result;
  }
}
