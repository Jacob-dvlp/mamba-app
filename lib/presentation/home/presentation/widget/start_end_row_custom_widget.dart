import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamba_fast_tracker/presentation/home/cubit/fast_cubit.dart';

class StartEndRowCustomWidget extends StatelessWidget {
  final FastState state;
  const StartEndRowCustomWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('h:mm a');
    final fmtDay = DateFormat('EEEE', 'pt_BR');
    String startTime = '--:--',
        startDay = '---',
        endTime = '--:--',
        endDay = '---';

    if (state is FastActive || state is FastCompleted) {
      final session = state is FastActive
          ? (state as FastActive).session
          : (state as FastCompleted).session;
      startTime = fmt.format(session.startTime);
      startDay = _dayLabel(session.startTime, fmtDay);
      final expectedEnd =
          session.startTime.add(session.protocol.fastingDuration);
      endTime = fmt.format(expectedEnd);
      endDay = _dayLabel(expectedEnd, fmtDay);
    }

    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.play_circle_outline_rounded,
            topLabel: 'INICIADO',
            mainValue: startTime,
            subValue: startDay,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.flag_outlined,
            topLabel: 'TERMINA',
            mainValue: endTime,
            subValue: endDay,
          ),
        ),
      ],
    );
  }

  String _dayLabel(DateTime dt, DateFormat fmt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dtDay = DateTime(dt.year, dt.month, dt.day);
    final diff = dtDay.difference(today).inDays;
    if (diff == 0) return 'Hoje';
    if (diff == -1) return 'Ontem';
    if (diff == 1) return 'Amanhã';
    return fmt.format(dt);
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String topLabel, mainValue, subValue;

  const _InfoCard({
    required this.icon,
    required this.topLabel,
    required this.mainValue,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: colors.onSurfaceVariant,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                topLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mainValue,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subValue,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
