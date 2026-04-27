import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mamba_fast_tracker/core/router/app_router.dart';

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNav({super.key, required this.child});

  static const _tabs = [
    _NavTab(icon: Icons.timer_outlined, activeIcon: Icons.timer, label: 'Jejum', route: AppRoutes.home),
    _NavTab(icon: Icons.restaurant_outlined, activeIcon: Icons.restaurant, label: 'Refeições', route: AppRoutes.meals),
    _NavTab(icon: Icons.history_outlined, activeIcon: Icons.history, label: 'Histórico', route: AppRoutes.history),
    _NavTab(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Stats', route: AppRoutes.stats),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].route),
        destinations: _tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  selectedIcon: Icon(t.activeIcon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  const _NavTab({required this.icon, required this.activeIcon, required this.label, required this.route});
}
