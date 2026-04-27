import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/fast_usecases.dart';
import '../../../domain/usecases/meal_usecases.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final GetWeeklySessionsUseCase _weeklySessions;
  final GetWeeklyCaloriesUseCase _weeklyCalories;

  StatsCubit({
    required GetWeeklySessionsUseCase weeklySessions,
    required GetWeeklyCaloriesUseCase weeklyCalories,
  })  : _weeklySessions = weeklySessions,
        _weeklyCalories = weeklyCalories,
        super(const StatsInitial());

  Future<void> loadStats() async {
    emit(const StatsLoading());
    try {
      final sessions = await _weeklySessions();
      final calories = await _weeklyCalories();
      emit(
        StatsLoaded(
          weeklyFastingMinutes: sessions.map(
            (key, value) => MapEntry(key, value.inMinutes),
          ),
          weeklyCalories: calories,
        ),
      );
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }
}
