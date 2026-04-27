part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<DailyLogEntity> logs;
  const HistoryLoaded({required this.logs});
  @override
  List<Object?> get props => [logs];
}

class HistoryDayDetail extends HistoryState {
  final DailyLogEntity log;
  const HistoryDayDetail({required this.log});
  @override
  List<Object?> get props => [log];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
  @override
  List<Object?> get props => [message];
}