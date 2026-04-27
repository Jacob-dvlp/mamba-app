import 'package:mamba_fast_tracker/domain/entities/fast_session_entity.dart';

abstract class IFastRepository {
  Future<FastSessionEntity?> getActiveSession();
  Future<void> saveSession({required FastSessionEntity session});
  Future<void> deleteSession({required String id});
  Future<List<FastSessionEntity>> getSessionsByDate({required DateTime date});
  Future<List<FastSessionEntity>> getSessionsInRange({
    required DateTime from,
    required DateTime dateTime,
  });
}
