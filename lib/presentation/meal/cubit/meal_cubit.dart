import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/meal_usecases.dart';
import '../../../domain/entities/meal_entity.dart';

part 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final AddMealUseCase _add;
  final UpdateMealUseCase _update;
  final DeleteMealUseCase _delete;
  final GetMealsByDateUseCase _getByDate;

  MealCubit({
    required AddMealUseCase add,
    required UpdateMealUseCase update,
    required DeleteMealUseCase delete,
    required GetMealsByDateUseCase getByDate,
  })  : _add = add,
        _update = update,
        _delete = delete,
        _getByDate = getByDate,
        super(const MealInitial());

  Future<void> loadMeals([DateTime? date]) async {
    emit(const MealLoading());
    try {
      final meals = await _getByDate(date ?? DateTime.now());
      emit(MealLoaded(meals: meals, selectedDate: date ?? DateTime.now()));
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> addMeal({required String name, required int calories}) async {
    try {
      await _add(name: name, calories: calories);
      await loadMeals(_selectedDate);
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> updateMeal(MealEntity meal) async {
    try {
      await _update(meal);
      await loadMeals(_selectedDate);
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      await _delete(id);
      await loadMeals(_selectedDate);
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  DateTime? get _selectedDate {
    final s = state;
    return s is MealLoaded ? s.selectedDate : null;
  }
}
