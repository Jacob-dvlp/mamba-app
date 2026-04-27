import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/fast_session_entity.dart';

class SessionTileHistoryCustomWiget extends StatelessWidget {
  final FastSessionEntity session;
  final Color? color;
  final DateFormat fmtTime;

  const SessionTileHistoryCustomWiget({
    super.key,
    required this.session,
    required this.color,
    required this.fmtTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final accent = color ?? colors.primary;

    final endLabel = session.endTime != null
        ? fmtTime.format(session.endTime!)
        : 'em andamento';

    final protocol = session.protocol.label;

    final h = session.elapsed.inHours;
    final m = session.elapsed.inMinutes.remainder(60);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: accent, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Protocolo $protocol',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${fmtTime.format(session.startTime)} → $endLabel',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${h}h ${m}m',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
