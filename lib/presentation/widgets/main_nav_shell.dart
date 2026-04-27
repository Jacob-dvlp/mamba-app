import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';

class MainNavShell extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainNavShell({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  static const _routes = [
    AppRoutes.home,
    AppRoutes.stats,
    AppRoutes.history,
    AppRoutes.meals,
  ];

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.outline, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.timer_rounded,
                  label: 'Jejum',
                  isActive: widget.currentIndex == 0,
                  onTap: () => context.go(MainNavShell._routes[0]),
                ),
                _NavItem(
                  icon: Icons.show_chart_rounded,
                  label: 'Resumo',
                  isActive: widget.currentIndex == 1,
                  onTap: () => context.go(MainNavShell._routes[1]),
                ),
                _NavItem(
                  icon: Icons.format_list_bulleted_rounded,
                  label: 'Histórico',
                  isActive: widget.currentIndex == 2,
                  onTap: () => context.go(MainNavShell._routes[2]),
                ),
                _NavItem(
                  icon: Icons.restaurant_menu_rounded,
                  label: 'Refeições',
                  isActive: widget.currentIndex == 3,
                  onTap: () => context.go(MainNavShell._routes[3]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final color = isActive ? colors.primary : colors.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? colors.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
