import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/auth/cubit/auth_cubit.dart';

import '../../presentation/auth/presentation/auth_page.dart';
import '../../presentation/auth/presentation/register_page.dart';
import '../../presentation/history/presentation/history_page.dart';

import '../../presentation/home/presentation/home_page.dart';
import '../../presentation/meal/presentation/meals_page.dart';
import '../../presentation/home/presentation/protocol/protocol_selector_page.dart';
import '../../presentation/stats/presentation/stats_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const meals = '/meals';
  static const history = '/history';
  static const stats = '/stats';
}

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: _AuthNotifier(authCubit),
    redirect: (context, state) {
      final isAuthenticated = authCubit.state is AuthAuthenticated;

      final loggingIn = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (authCubit.state is AuthInitial) return null;

      if (!isAuthenticated && !loggingIn) {
        return AppRoutes.login;
      }

      if (isAuthenticated && loggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const HomePage(),
        routes: [
          GoRoute(
            path: 'protocol-selector',
            builder: (_, __) => const ProtocolSelectorPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.meals,
        builder: (_, __) => const MealsPage(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (_, __) => const HistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (_, __) => const StatsPage(),
      ),
    ],
  );
}

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(AuthCubit cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }

  late final dynamic _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
