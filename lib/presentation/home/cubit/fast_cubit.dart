import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/fast_session_entity.dart';
import '../../../domain/entities/fast_protocol_entity.dart';
import '../../../domain/usecases/fast_usecases.dart';

part 'fast_state.dart';

class FastCubit extends Cubit<FastState> {
  final StartFastUseCase _start;
  final PauseFastUseCase _pause;
  final ResumeFastUseCase _resume;
  final EndFastUseCase _end;
  final GetActiveSessionUseCase _getActive;

  Timer? _ticker;
  bool _goalNotified = false;

  FastCubit({
    required StartFastUseCase start,
    required PauseFastUseCase pause,
    required ResumeFastUseCase resume,
    required EndFastUseCase end,
    required GetActiveSessionUseCase getActive,
  })  : _start = start,
        _pause = pause,
        _resume = resume,
        _end = end,
        _getActive = getActive,
        super(FastIdle()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final session = await _getActive();
      if (session == null) return;
      emit(FastActive(session: session));
      if (session.status == FastStatus.running) {
        _startTicker();
      }
    } catch (_) {}
  }

  Future<void> startFast(FastProtocolEntity protocol) async {
    _stopTicker();
    emit(FastLoading());
    try {
      final session = await _start(protocol);
      emit(FastActive(
        session: session,
        elapsedSnapshot: 0,
      ));
      _startTicker();
    } catch (e) {
      emit(FastError(e.toString()));
    }
  }

  Future<void> pauseFast() async {
    _stopTicker();
    try {
      final session = await _pause();
      if (session != null) emit(FastActive(session: session));
    } catch (_) {}
  }

  Future<void> resumeFast() async {
    try {
      final session = await _resume();
      if (session != null) {
        emit(FastActive(session: session));
        _startTicker();
      }
    } catch (_) {}
  }

  Future<void> endFast() async {
    _stopTicker();
    try {
      final session = await _end();
      if (session != null) {
        emit(FastCompleted(session: session));
      } else {
        emit(FastIdle());
      }
    } catch (_) {
      emit(FastIdle());
    }
  }

  void dismissCompleted() => emit(FastIdle());

  void _startTicker() {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) {
        _ticker?.cancel();
        return;
      }
      final current = state;
      if (current is! FastActive) return;
      if (current.session.status != FastStatus.running) return;
      emit(
        FastActive(
          session: current.session,
          elapsedSnapshot: current.session.elapsed.inSeconds,
        ),
      );

      if (current.session.isGoalReached && !_goalNotified) {
        _goalNotified = true;
        endFast();
      }
    });
  }

  Future<void> loadCurrentFast() async {
    await _restoreSession();
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
    _goalNotified = false;
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
