import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/home/cubit/fast_cubit.dart';
import 'presentation/meal/cubit/meal_cubit.dart';
import 'presentation/history/cubit/history_cubit.dart';
import 'presentation/stats/cubit/stats_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await setupDependencies();
  await initializeDateFormatting('pt_BR');
  runApp(const MambaApp());
}

class MambaApp extends StatelessWidget {
  const MambaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<FastCubit>(create: (_) => sl<FastCubit>()),
        BlocProvider<MealCubit>(
          create: (_) => sl<MealCubit>()..loadMeals(),
        ),
        BlocProvider<HistoryCubit>(create: (_) => sl<HistoryCubit>()),
        BlocProvider<StatsCubit>(create: (_) => sl<StatsCubit>()),
      ],
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          final router = createRouter(authCubit);
          return MaterialApp.router(
            title: 'Mamba Fast Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
