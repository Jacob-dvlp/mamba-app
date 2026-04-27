part of 'fast_cubit.dart';

abstract class FastState {}

class FastIdle extends FastState {}

class FastLoading extends FastState {}

class FastActive extends FastState {
  final FastSessionEntity session;
  final int elapsedSnapshot;

  FastActive({
    required this.session,
    int? elapsedSnapshot,
  }) : elapsedSnapshot = elapsedSnapshot ?? session.elapsed.inSeconds;

  FastActive copyWith({
    FastSessionEntity? session,
    int? elapsedSnapshot,
  }) {
    return FastActive(
      session: session ?? this.session,
      elapsedSnapshot: elapsedSnapshot ?? this.elapsedSnapshot,
    );
  }
}

class FastCompleted extends FastState {
  final FastSessionEntity session;
  FastCompleted({required this.session});
}

class FastError extends FastState {
  final String message;
  FastError(this.message);
}
