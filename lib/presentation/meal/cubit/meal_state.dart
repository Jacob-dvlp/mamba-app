part of 'meal_cubit.dart';

abstract class MealState extends Equatable {
  const MealState();
  @override
  List<Object?> get props => [];
}

class MealInitial extends MealState {
  const MealInitial();
}

class MealLoading extends MealState {
  const MealLoading();
}

class MealLoaded extends MealState {
  final List<MealEntity> meals;
  final DateTime selectedDate;

  const MealLoaded({required this.meals, required this.selectedDate});

  int get totalCalories => meals.fold(0, (sum, m) => sum + m.calories);

  @override
  List<Object?> get props => [meals, selectedDate];
}

class MealError extends MealState {
  final String message;
  const MealError(this.message);
  @override
  List<Object?> get props => [message];
}
