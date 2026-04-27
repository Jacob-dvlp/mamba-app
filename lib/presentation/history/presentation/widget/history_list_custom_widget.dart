import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/daily_log_entity.dart';
import '../../cubit/history_cubit.dart';

class HistoryListCustomWidget extends StatelessWidget {
  final List<DailyLogEntity> logs;
  const HistoryListCustomWidget({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<DailyLogEntity>> grouped = {};
    final monthFmt = DateFormat('MMMM yyyy', 'pt_BR');

    for (final log in logs) {
      final key = monthFmt.format(log.date);
      grouped.putIfAbsent(key, () => []).add(log);
    }

    final sections = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: sections.fold<int>(0, (sum, e) => sum + 1 + e.value.length),
      itemBuilder: (context, idx) {
        int cursor = 0;

        for (final entry in sections) {
          if (idx == cursor) {
            return _MonthHeader(label: entry.key);
          }
          cursor++;

          for (final log in entry.value) {
            if (idx == cursor) {
              return _DayCard(
                log: log,
                onTap: () =>
                    context.read<HistoryCubit>().loadLogForDate(log.date),
              );
            }
            cursor++;
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final String label;
  const _MonthHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: theme.textTheme.labelLarge?.copyWith(
          color: colors.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final DailyLogEntity log;
  final VoidCallback onTap;

  const _DayCard({
    required this.log,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final primary = colors.primary;
    final isToday = _isToday(log.date);

    final weekdayFmt = DateFormat('EEE', 'pt_BR');

    final fastH = log.totalFastingTime.inHours;
    final fastM = log.totalFastingTime.inMinutes.remainder(60);

    final goalMet = log.totalFastingTime.inMinutes > 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: isToday
              ? Border.all(color: primary.withOpacity(0.5), width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            // Date badge
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isToday ? primary : primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    log.date.day.toString(),
                    style: TextStyle(
                      color: isToday ? colors.onPrimary : primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      height: 1,
                    ),
                  ),
                  Text(
                    weekdayFmt.format(log.date).toUpperCase(),
                    style: TextStyle(
                      color: isToday
                          ? colors.onPrimary.withOpacity(0.75)
                          : primary.withOpacity(0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isToday
                        ? 'Hoje'
                        : DateFormat('d \'de\' MMMM', 'pt_BR').format(log.date),
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      if (log.totalFastingTime.inMinutes > 0)
                        _MiniChip(
                          icon: Icons.timer_outlined,
                          label: '${fastH}h ${fastM}m',
                          color: primary,
                        ),
                      if (log.totalCalories > 0)
                        _MiniChip(
                          icon: Icons.local_fire_department_outlined,
                          label: '${log.totalCalories} kcal',
                          color: colors.tertiary,
                        ),
                      if (log.meals.isNotEmpty)
                        _MiniChip(
                          icon: Icons.restaurant_outlined,
                          label: '${log.meals.length} refeições',
                          color: colors.secondary,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: goalMet
                    ? Colors.green.withOpacity(0.12)
                    : colors.onSurface.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                goalMet ? Icons.check_rounded : Icons.chevron_right_rounded,
                size: 16,
                color: goalMet ? Colors.green : colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
