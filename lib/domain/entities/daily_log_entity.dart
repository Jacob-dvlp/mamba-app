import 'package:equatable/equatable.dart';

import 'fast_session_entity.dart';
import 'meal_entity.dart';

class DailyLogEntity extends Equatable {
  final String id;
  final DateTime date;
  final List<MealEntity> meals;
  final List<FastSessionEntity> sessions;

  const DailyLogEntity({
    required this.id,
    required this.date,
    required this.meals,
    required this.sessions,
  });

  int get totalCalories => meals.fold(0, (sum, m) => sum + m.calories);

  Duration get totalFastingTime => sessions.fold(
        Duration.zero,
        (sum, s) => sum + s.elapsed,
      );

  bool isGoalReached(int calorieGoal) => totalCalories <= calorieGoal;

  DailyLogEntity copyWith({
    String? id,
    DateTime? date,
    List<MealEntity>? meals,
    List<FastSessionEntity>? sessions,
  }) {
    return DailyLogEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      meals: meals ?? this.meals,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  List<Object?> get props => [id, date, meals, sessions];
}
