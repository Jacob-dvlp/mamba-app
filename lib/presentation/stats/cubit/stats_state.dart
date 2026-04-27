part of 'stats_cubit.dart';

abstract class StatsState extends Equatable {
  const StatsState();
  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {
  const StatsInitial();
}

class StatsLoading extends StatsState {
  const StatsLoading();
}

class StatsLoaded extends StatsState {
  /// key = dia (DateTime sem hora), value = minutos de jejum
  final Map<DateTime, int> weeklyFastingMinutes;

  /// key = dia (DateTime sem hora), value = calorias totais
  final Map<DateTime, int> weeklyCalories;

  const StatsLoaded({
    required this.weeklyFastingMinutes,
    required this.weeklyCalories,
  });

  @override
  List<Object?> get props => [weeklyFastingMinutes, weeklyCalories];
}

class StatsError extends StatsState {
  final String message;
  const StatsError(this.message);
  @override
  List<Object?> get props => [message];
}
