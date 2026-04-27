import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/fast_session_entity.dart';
import '../../cubit/fast_cubit.dart';

class StatusPillCustomWidget extends StatelessWidget {
  final FastState state;
  const StatusPillCustomWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isActive = state is FastActive &&
        (state as FastActive).session.status == FastStatus.running;
    final isPaused = state is FastActive &&
        (state as FastActive).session.status == FastStatus.paused;

    String label;
    Color dotColor;
    if (isActive) {
      label = 'KETOSIS ACTIVO';
      dotColor = Colors.green;
    } else if (isPaused) {
      label = 'JEJUM PAUSADO';
      dotColor = Colors.red;
    } else if (state is FastCompleted) {
      label = 'JEJUM CONCLUÍDO';
      dotColor = Colors.green;
    } else {
      label = 'SEM JEJUM ATIVO';
      dotColor = AppTheme.kTextSecondary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: AppTheme.kCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.6),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              child: Text(
                label,
                style: TextStyle(
                  color: dotColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
