import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mamba_fast_tracker/domain/entities/daily_log_entity.dart';
import '../../../domain/usecases/meal_usecases.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetDailyLogUseCase _getDailyLog;

  HistoryCubit({required GetDailyLogUseCase getDailyLog})
      : _getDailyLog = getDailyLog,
        super(const HistoryInitial());

  Future<void> loadLast30Days() async {
    emit(const HistoryLoading());
    try {
      final logs = <DailyLogEntity>[];
      final today = DateTime.now();
      for (int i = 0; i < 30; i++) {
        final date = today.subtract(Duration(days: i));
        final log = await _getDailyLog(date);
        if (log.meals.isNotEmpty || log.sessions.isNotEmpty) {
          logs.add(log);
        }
      }
      emit(HistoryLoaded(logs: logs));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> loadLogForDate(DateTime date) async {
    emit(const HistoryLoading());
    try {
      final log = await _getDailyLog(date);
      emit(HistoryDayDetail(log: log));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
