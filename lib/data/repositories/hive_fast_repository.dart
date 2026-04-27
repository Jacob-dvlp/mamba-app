import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive/hive.dart';

import '../../core/hive/hive_constants.dart';
import '../../domain/entities/fast_session_entity.dart';
import '../../domain/repositories/i_fast_repository.dart';

import '../models/fast_session_dto.dart';

class HiveFastRepository implements IFastRepository {
  Box<FastSessionDto> get _box =>
      Hive.box<FastSessionDto>(HiveBoxes.fastSessions);

  @override
  Future<FastSessionEntity?> getActiveSession() async {
    try {
      final sessions = _box.values
          .where((dto) =>
              dto.statusIndex == FastStatus.running.index ||
              dto.statusIndex == FastStatus.paused.index)
          .toList();

      if (sessions.isEmpty) return null;
      sessions.sort((a, b) => b.startTimeMicros.compareTo(a.startTimeMicros));
      return sessions.first.toEntity();
    } catch (_, stack) {
      FirebaseCrashlytics.instance.recordError(_, stack, fatal: false);
      return null;
    }
  }

  @override
  Future<void> deleteSession({required String id}) async {
    await _box.delete(id);
  }

  @override
  Future<List<FastSessionEntity>> getSessionsByDate({
    required DateTime date,
  }) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return _box.values
        .where((dto) {
          final start =
              DateTime.fromMicrosecondsSinceEpoch(dto.startTimeMicros);
          return start.isAfter(dayStart) && start.isBefore(dayEnd);
        })
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<List<FastSessionEntity>> getSessionsInRange({
    required DateTime from,
    required DateTime dateTime,
  }) async {
    final fromMicros = from.microsecondsSinceEpoch;
    final toMicros = dateTime.microsecondsSinceEpoch;

    return _box.values
        .where((dto) =>
            dto.startTimeMicros >= fromMicros &&
            dto.startTimeMicros <= toMicros)
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<void> saveSession({required FastSessionEntity session}) async {
    await _box.put(session.id, FastSessionDto.fromEntity(session));
  }
}
