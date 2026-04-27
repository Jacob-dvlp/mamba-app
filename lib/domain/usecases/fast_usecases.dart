import 'package:mamba_fast_tracker/domain/repositories/i_fast_repository.dart';
import 'package:uuid/uuid.dart';
import '../../services/i_notification_service.dart';
import '../entities/fast_protocol_entity.dart';

import '../entities/fast_session_entity.dart';

class StartFastUseCase {
  final IFastRepository _repo;
  final INotificationService _notifications;
  final _uuid = const Uuid();

  StartFastUseCase(this._repo, this._notifications);

  Future<FastSessionEntity> call(FastProtocolEntity protocol) async {
    final existing = await _repo.getActiveSession();
    if (existing != null) {
      final ended = existing.copyWith(
        status: FastStatus.completed,
        endTime: DateTime.now(),
      );
      await _repo.saveSession(session: ended);
    }

    final session = FastSessionEntity(
      id: _uuid.v4(),
      protocol: protocol,
      startTime: DateTime.now(),
      status: FastStatus.running,
    );

    await _repo.saveSession(session: session);
    await _notifications.showFastStarted(
      fastingDuration: protocol.fastingDuration,
    );
    await _notifications.scheduleFastCompletionNotification(
      completionTime: session.startTime.add(protocol.fastingDuration),
    );

    return session;
  }
}

class PauseFastUseCase {
  final IFastRepository _repo;

  PauseFastUseCase(this._repo);

  Future<FastSessionEntity?> call() async {
    final session = await _repo.getActiveSession();
    if (session == null || session.status != FastStatus.running) return null;

    final paused = session.copyWith(
      status: FastStatus.paused,
      pausedAt: DateTime.now(),
    );
    await _repo.saveSession(session: paused);
    return paused;
  }
}

class ResumeFastUseCase {
  final IFastRepository _repo;

  ResumeFastUseCase(this._repo);

  Future<FastSessionEntity?> call() async {
    final session = await _repo.getActiveSession();
    if (session == null || session.status != FastStatus.paused) return null;

    final additionalPause = session.pausedAt != null
        ? DateTime.now().difference(session.pausedAt!)
        : Duration.zero;

    final resumed = session.copyWith(
      status: FastStatus.running,
      pausedDuration: session.pausedDuration + additionalPause,
      clearPausedAt: true,
    );
    await _repo.saveSession(session: resumed);
    return resumed;
  }
}

class EndFastUseCase {
  final IFastRepository _repo;
  final INotificationService _notifications;

  EndFastUseCase(this._repo, this._notifications);

  Future<FastSessionEntity?> call() async {
    final session = await _repo.getActiveSession();
    if (session == null) return null;

    final ended = session.copyWith(
      status: FastStatus.completed,
      endTime: DateTime.now(),
    );
    await _repo.saveSession(session: ended);
    await _notifications.cancelAll();
    await _notifications.showFastCompleted();
    return ended;
  }
}

class GetActiveSessionUseCase {
  final IFastRepository _repo;
  GetActiveSessionUseCase(this._repo);
  Future<FastSessionEntity?> call() => _repo.getActiveSession();
}

class GetSessionsByDateUseCase {
  final IFastRepository _repo;
  GetSessionsByDateUseCase(this._repo);
  Future<List<FastSessionEntity>> call(DateTime date) =>
      _repo.getSessionsByDate(date: date);
}

class GetWeeklySessionsUseCase {
  final IFastRepository _repo;
  GetWeeklySessionsUseCase(this._repo);

  Future<Map<DateTime, Duration>> call() async {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 6));
    final sessions = await _repo.getSessionsInRange(from: from, dateTime: now);

    final Map<DateTime, Duration> result = {};
    for (int i = 0; i < 7; i++) {
      final day = DateTime(from.year, from.month, from.day + i);
      result[day] = Duration.zero;
    }

    for (final s in sessions) {
      final day =
          DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
      result[day] = (result[day] ?? Duration.zero) + s.elapsed;
    }
    return result;
  }
}
