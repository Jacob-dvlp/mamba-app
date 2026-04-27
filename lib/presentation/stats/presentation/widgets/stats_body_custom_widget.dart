import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_utils.dart';
import '../../cubit/stats_cubit.dart';
import 'kpi_card_custom_widget.dart';
import 'toggle_button_custom_widget.dart';

class StatsBody extends StatelessWidget {
  final StatsLoaded state;
  final bool showFasting;
  final ValueChanged<bool> onToggle;

  const StatsBody({
    super.key,
    required this.state,
    required this.showFasting,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;

    final fastingData = Map.fromEntries(
      state.weeklyFastingMinutes.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );

    final calorieData = Map.fromEntries(
      state.weeklyCalories.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );

    final currentData = showFasting
        ? fastingData.map((k, v) => MapEntry(k, v / 60.0))
        : calorieData.map((k, v) => MapEntry(k, v.toDouble()));

    final sortedKeys = currentData.keys.toList();
    final values = sortedKeys.map((k) => currentData[k] ?? 0.0).toList();

    final maxVal =
        values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);

    final safeMax = maxVal == 0 ? (showFasting ? 24.0 : 3000.0) : maxVal * 1.2;

    final totalVal = values.fold(0.0, (a, b) => a + b);
    final avgVal = values.isEmpty ? 0.0 : totalVal / values.length;
    final bestVal =
        values.isEmpty ? 0.0 : values.reduce((a, b) => a > b ? a : b);

    final mutedText = onSurface.withOpacity(0.4);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOGGLE
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: surface.withOpacity(0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                ToggleBtn(
                  label: '⏱ Jejum',
                  isActive: showFasting,
                  onTap: () => onToggle(true),
                ),
                ToggleBtn(
                  label: '🔥 Calorias',
                  isActive: !showFasting,
                  onTap: () => onToggle(false),
                ),
              ],
            ),
          ),

          // KPI
          Row(
            children: [
              Expanded(
                child: KpiCardCustomWidget(
                  label: 'Total',
                  value: showFasting
                      ? '${totalVal.toStringAsFixed(1)}h'
                      : '${totalVal.toInt()} kcal',
                  color: primary,
                  icon: Icons.summarize_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KpiCardCustomWidget(
                  label: 'Média/dia',
                  value: showFasting
                      ? '${avgVal.toStringAsFixed(1)}h'
                      : '${avgVal.toInt()} kcal',
                  color: primary,
                  icon: Icons.show_chart_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KpiCardCustomWidget(
                  label: 'Melhor dia',
                  value: showFasting
                      ? '${bestVal.toStringAsFixed(1)}h'
                      : '${bestVal.toInt()} kcal',
                  color: primary,
                  icon: Icons.emoji_events_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            showFasting
                ? 'Horas de jejum — últimos 7 dias'
                : 'Calorias — últimos 7 dias',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),

          const SizedBox(height: 16),

          // CHART
          Container(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              height: 220,
              child: sortedKeys.isEmpty
                  ? Center(
                      child: Text(
                        'Sem dados ainda',
                        style: TextStyle(color: mutedText),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        maxY: safeMax,
                        minY: 0,
                        barGroups: sortedKeys.asMap().entries.map((e) {
                          final val = values[e.key];

                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: val,
                                width: 26,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    primary.withOpacity(0.6),
                                    primary,
                                  ],
                                ),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: safeMax,
                                  color: primary.withOpacity(0.05),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: safeMax / 4,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: onSurface.withOpacity(0.06),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: safeMax / 4,
                              getTitlesWidget: (v, _) => Text(
                                showFasting
                                    ? '${v.toInt()}h'
                                    : v >= 1000
                                        ? '${(v / 1000).toStringAsFixed(1)}k'
                                        : v.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: mutedText,
                                ),
                              ),
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                final i = v.toInt();
                                if (i < 0 || i >= sortedKeys.length) {
                                  return const SizedBox.shrink();
                                }

                                final day = sortedKeys[i];
                                final today = isToday(day);

                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    DateFormat('E', 'pt_BR')
                                        .format(day)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: today
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: today ? primary : mutedText,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) =>
                                theme.colorScheme.inverseSurface,
                            getTooltipItem: (group, _, rod, __) {
                              final day = sortedKeys[group.x];
                              final v = rod.toY;

                              return BarTooltipItem(
                                '${DateFormat('d/M').format(day)}\n',
                                TextStyle(
                                  color: theme.colorScheme.onInverseSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: showFasting
                                        ? '${v.toStringAsFixed(1)}h'
                                        : '${v.toInt()} kcal',
                                    style: TextStyle(
                                      color: theme.colorScheme.onInverseSurface
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Detalhamento diário',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),

          const SizedBox(height: 12),

          if (sortedKeys.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Sem dados ainda.\nInicie um jejum ou registre refeições!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: mutedText),
                ),
              ),
            )
          else
            ...sortedKeys.reversed.map((day) {
              final val = currentData[day] ?? 0.0;
              final frac = safeMax > 0 ? (val / safeMax).clamp(0.0, 1.0) : 0.0;
              final today = isToday(day);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(12),
                  border: today
                      ? Border.all(color: primary.withOpacity(0.4), width: 1.5)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEE, d MMM', 'pt_BR').format(day),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          val == 0
                              ? '—'
                              : showFasting
                                  ? '${val.toStringAsFixed(1)}h'
                                  : '${val.toInt()} kcal',
                          style: TextStyle(
                            color: val == 0 ? mutedText : primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: frac,
                        minHeight: 7,
                        backgroundColor: primary.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation(
                          val == 0 ? Colors.grey : primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
