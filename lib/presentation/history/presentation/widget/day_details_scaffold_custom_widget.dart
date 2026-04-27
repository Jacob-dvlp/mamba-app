import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/daily_log_entity.dart';
import '../../cubit/history_cubit.dart';
import 'meal_title_history_custom_widget.dart';
import 'section_title_custom_widget.dart';
import 'session_tile_history_custom_wiget.dart';
import 'summary_card_custom_widget.dart';

class DayDetailsScaffoldCustomWidget extends StatelessWidget {
  final DailyLogEntity log;
  const DayDetailsScaffoldCustomWidget({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final fmtTitle = DateFormat('EEEE, d \'de\' MMMM', 'pt_BR');
    final fmtTime = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colors.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.read<HistoryCubit>().loadLast30Days(),
        ),
        title: Text(
          fmtTitle.format(log.date),
          style: theme.textTheme.titleSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryCardCustomWidget(
                    icon: Icons.timer_rounded,
                    iconColor: colors.primary,
                    label: 'Jejum total',
                    value:
                        '${log.totalFastingTime.inHours}h ${log.totalFastingTime.inMinutes.remainder(60)}m',
                    sub: '${log.sessions.length} sessão(ões)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCardCustomWidget(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: colors.tertiary,
                    label: 'Calorias',
                    value: '${log.totalCalories}',
                    sub: 'kcal ingeridas',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SummaryCardCustomWidget(
                    icon: Icons.restaurant_rounded,
                    iconColor: colors.secondary,
                    label: 'Refeições',
                    value: '${log.meals.length}',
                    sub: 'registradas',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCardCustomWidget(
                    icon: log.totalFastingTime.inMinutes > 0
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    iconColor: log.totalFastingTime.inMinutes > 0
                        ? colors.primary
                        : colors.onSurfaceVariant,
                    label: 'Status',
                    value: log.totalFastingTime.inMinutes > 0
                        ? 'Meta OK'
                        : 'Sem jejum',
                    sub: log.totalFastingTime.inMinutes > 0
                        ? '🎉 Parabéns!'
                        : 'Tente amanhã',
                  ),
                ),
              ],
            ),
            if (log.sessions.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionTitleCustomWidget(
                icon: Icons.timer_outlined,
                label: 'Sessões de jejum',
                color: colors.primary,
              ),
              const SizedBox(height: 10),
              ...log.sessions.map(
                (s) => SessionTileHistoryCustomWiget(
                  session: s,
                  color: colors.primary,
                  fmtTime: fmtTime,
                ),
              ),
            ],
            if (log.meals.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionTitleCustomWidget(
                icon: Icons.restaurant_outlined,
                label: 'Refeições',
                color: colors.secondary,
              ),
              const SizedBox(height: 10),
              ...log.meals.map(
                (m) => MealTitleHistoryCustomWidget(
                  meal: m,
                  fmtTime: fmtTime,
                ),
              ),
            ],
            if (log.sessions.isEmpty && log.meals.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: Text(
                    'Nenhum dado para este dia.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
