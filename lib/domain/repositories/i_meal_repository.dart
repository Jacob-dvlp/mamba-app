import '../../../../domain/entities/meal_entity.dart';

abstract class IMealRepository {
  Future<List<MealEntity>> getMealsByDate(DateTime date);
  Future<void> saveMeal(MealEntity meal);
  Future<void> updateMeal(MealEntity meal);
  Future<void> deleteMeal(String id);
  Future<List<MealEntity>> getMealsInRange(DateTime from, DateTime to);
}
