import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamba_fast_tracker/data/datasources/firebase_auth_datasource.dart';

import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/repositories/i_fast_repository.dart';
import '../../domain/repositories/i_meal_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/hive_fast_repository.dart';
import '../../data/repositories/hive_meal_repository.dart';
import '../../data/models/fast_session_dto.dart';
import '../../data/models/meal_dto.dart';
import '../../domain/usecases/fast_usecases.dart';
import '../../domain/usecases/meal_usecases.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../presentation/auth/cubit/auth_cubit.dart';
import '../../presentation/home/cubit/fast_cubit.dart';
import '../../presentation/history/cubit/history_cubit.dart';
import '../../presentation/meal/cubit/meal_cubit.dart';
import '../../presentation/stats/cubit/stats_cubit.dart';
import '../../services/i_notification_service.dart';
import '../../services/notification_service.dart';

import '../hive/hive_constants.dart';
import '../theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(HiveTypeIds.fastSession)) {
    Hive.registerAdapter(FastSessionDtoAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveTypeIds.meal)) {
    Hive.registerAdapter(MealDtoAdapter());
  }
  await Hive.openBox<FastSessionDto>(HiveBoxes.fastSessions);
  await Hive.openBox<MealDto>(HiveBoxes.meals);

  sl.registerLazySingleton<INotificationService>(() => NotificationService());

  sl.registerLazySingleton(
    () => FirebaseAuth.instance,
  );

  sl.registerLazySingleton<IAuthDataSource>(
    () => FirebaseAuthDataSource(firebaseAuth: sl.get()),
  );
  sl.registerLazySingleton<IAuthRepository>(
    () => FirebaseAuthRepository(dataSource: sl.get()),
  );
  sl.registerLazySingleton<IFastRepository>(() => HiveFastRepository());
  sl.registerLazySingleton<IMealRepository>(() => HiveMealRepository());

  sl.registerFactory(() => SignInUseCase(sl()));
  sl.registerFactory(() => SignUpUseCase(sl()));
  sl.registerFactory(() => SignOutUseCase(sl()));
  sl.registerFactory(() => GetAuthStateUseCase(sl()));

  sl.registerFactory(() => StartFastUseCase(sl(), sl()));
  sl.registerFactory(() => PauseFastUseCase(sl()));
  sl.registerFactory(() => ResumeFastUseCase(sl()));
  sl.registerFactory(() => EndFastUseCase(sl(), sl()));
  sl.registerFactory(() => GetActiveSessionUseCase(sl()));
  sl.registerFactory(() => GetSessionsByDateUseCase(sl()));
  sl.registerFactory(() => GetWeeklySessionsUseCase(sl()));

  sl.registerFactory(() => AddMealUseCase(sl()));
  sl.registerFactory(() => UpdateMealUseCase(sl()));
  sl.registerFactory(() => DeleteMealUseCase(sl()));
  sl.registerFactory(() => GetMealsByDateUseCase(sl()));
  sl.registerFactory(() => GetDailyLogUseCase(sl(), sl()));
  sl.registerFactory(() => GetWeeklyCaloriesUseCase(sl()));

  // ── Cubits ─────────────────────────────────────────────────
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getAuthState: sl(),
    ),
  );

  sl.registerFactory<FastCubit>(() => FastCubit(
        start: sl(),
        pause: sl(),
        resume: sl(),
        end: sl(),
        getActive: sl(),
      ));

  sl.registerFactory<MealCubit>(
    () => MealCubit(add: sl(), update: sl(), delete: sl(), getByDate: sl()),
  );

  sl.registerFactory<HistoryCubit>(() => HistoryCubit(getDailyLog: sl()));

  sl.registerFactory<StatsCubit>(
    () => StatsCubit(
      weeklySessions: sl(),
      weeklyCalories: sl(),
    ),
  );
  sl.registerFactory<ThemeCubit>(() => ThemeCubit());

  await sl<INotificationService>().initialize();
}
