import 'package:mamba_fast_tracker/domain/entities/daily_log_entity.dart';
import 'package:mamba_fast_tracker/domain/entities/fast_protocol_entity.dart';
import 'package:mamba_fast_tracker/domain/entities/fast_session_entity.dart';
import 'package:mamba_fast_tracker/domain/entities/meal_entity.dart';
import 'package:mamba_fast_tracker/domain/entities/user_profile_entity.dart';

import 'package:mamba_fast_tracker/domain/repositories/i_auth_repository.dart';
import 'package:mamba_fast_tracker/domain/repositories/i_fast_repository.dart';
import 'package:mamba_fast_tracker/domain/repositories/i_meal_repository.dart';
import 'package:mamba_fast_tracker/domain/usecases/fast_usecases.dart';
import 'package:mamba_fast_tracker/domain/usecases/meal_usecases.dart';
import 'package:mamba_fast_tracker/domain/usecases/auth_usecases.dart';
import 'package:mamba_fast_tracker/services/i_notification_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockFastRepository extends Mock implements IFastRepository {}

class MockMealRepository extends Mock implements IMealRepository {}

class MockNotificationService extends Mock implements INotificationService {}

class MockStartFastUseCase extends Mock implements StartFastUseCase {}

class MockPauseFastUseCase extends Mock implements PauseFastUseCase {}

class MockResumeFastUseCase extends Mock implements ResumeFastUseCase {}

class MockEndFastUseCase extends Mock implements EndFastUseCase {}

class MockGetActiveSessionUseCase extends Mock
    implements GetActiveSessionUseCase {}

class MockGetWeeklySessionsUseCase extends Mock
    implements GetWeeklySessionsUseCase {}

class MockAddMealUseCase extends Mock implements AddMealUseCase {}

class MockUpdateMealUseCase extends Mock implements UpdateMealUseCase {}

class MockDeleteMealUseCase extends Mock implements DeleteMealUseCase {}

class MockGetMealsByDateUseCase extends Mock implements GetMealsByDateUseCase {}

class MockGetDailyLogUseCase extends Mock implements GetDailyLogUseCase {}

class MockGetWeeklyCaloriesUseCase extends Mock
    implements GetWeeklyCaloriesUseCase {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockGetAuthStateUseCase extends Mock implements GetAuthStateUseCase {}

class Fixtures {
  static const p16_8 = FastProtocolEntity.sixteen8;
  static const p12_12 = FastProtocolEntity.twelve12;
  static const p18_6 = FastProtocolEntity.eighteen6;

  static FastProtocolEntity custom({int fasting = 20, int eating = 4}) =>
      FastProtocolEntity.custom(fastingHours: fasting, eatingHours: eating);

  static FastSessionEntity runningSession({
    String id = 'session-1',
    FastProtocolEntity? protocol,
    DateTime? startTime,
  }) =>
      FastSessionEntity(
        id: id,
        protocol: protocol ?? p16_8,
        startTime:
            startTime ?? DateTime.now().subtract(const Duration(hours: 2)),
        status: FastStatus.running,
      );

  static FastSessionEntity pausedSession({
    String id = 'session-paused',
    DateTime? startTime,
    DateTime? pausedAt,
    Duration pausedDuration = const Duration(minutes: 10),
  }) {
    final start =
        startTime ?? DateTime.now().subtract(const Duration(hours: 3));
    return FastSessionEntity(
      id: id,
      protocol: p16_8,
      startTime: start,
      pausedAt:
          pausedAt ?? DateTime.now().subtract(const Duration(minutes: 30)),
      pausedDuration: pausedDuration,
      status: FastStatus.paused,
    );
  }

  static FastSessionEntity completedSession({
    String id = 'session-done',
    FastProtocolEntity? protocol,
    Duration elapsed = const Duration(hours: 16),
  }) {
    final start = DateTime.now().subtract(elapsed);
    return FastSessionEntity(
      id: id,
      protocol: protocol ?? p16_8,
      startTime: start,
      endTime: DateTime.now(),
      status: FastStatus.completed,
    );
  }

  static MealEntity meal({
    String id = 'meal-1',
    String name = 'Almoço',
    int calories = 500,
    String dailyLogId = '2025-01-15',
    DateTime? loggedAt,
  }) =>
      MealEntity(
        id: id,
        name: name,
        calories: calories,
        loggedAt: loggedAt ?? DateTime(2025, 1, 15, 12, 0),
        dailyLogId: dailyLogId,
      );

  static List<MealEntity> mealList() => [
        meal(id: '1', name: 'Café', calories: 200),
        meal(id: '2', name: 'Almoço', calories: 600),
        meal(id: '3', name: 'Jantar', calories: 500),
      ];

  static DailyLogEntity dailyLog({
    String id = '2025-01-15',
    List<MealEntity>? meals,
    List<FastSessionEntity>? sessions,
  }) =>
      DailyLogEntity(
        id: id,
        date: DateTime(2025, 1, 15),
        meals: meals ?? mealList(),
        sessions: sessions ?? [completedSession()],
      );

  static UserProfileEntity user({
    String uid = 'uid-123',
    String email = 'test@mamba.com',
  }) =>
      UserProfileEntity(uid: uid, email: email);
}
