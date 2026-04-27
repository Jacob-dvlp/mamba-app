import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../domain/entities/fast_session_entity.dart';
import '../../cubit/fast_cubit.dart';

class TimerRingCustomWidget extends StatelessWidget {
  final FastState state;
  const TimerRingCustomWidget({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    double progress = 0;
    String topLabel = 'Tempo Inicial';
    String timeStr = '00:00:00';
    String bottomLabel = '';
    bool showProtocol = false;

    if (state is FastActive) {
      final s = (state as FastActive).session;
      final isRunning = s.status == FastStatus.running;
      progress = s.progress;
      topLabel = isRunning ? 'Tempo Restante' : 'Tempo Decorrido';
      timeStr = isRunning ? fmtHMS(s.remaining) : fmtHMS(s.elapsed);
      bottomLabel = s.protocol.label;
      showProtocol = true;
    } else if (state is FastCompleted) {
      final s = (state as FastCompleted).session;
      progress = 1.0;
      topLabel = 'Tempo Total';
      timeStr = fmtHMS(s.elapsed);
      bottomLabel = s.protocol.label;
      showProtocol = true;
    }

    final ringColor = state is FastCompleted
        ? colors.primary
        : state is FastActive &&
                (state as FastActive).session.status == FastStatus.paused
            ? colors.tertiary // laranja adaptado ao theme
            : colors.primary;

    final trackColor = colors.outlineVariant;

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(250, 300),
            painter: _RingPainter(
              progress: progress,
              ringColor: ringColor,
              trackColor: trackColor,
              strokeWidth: 16,
              brightness: Theme.of(context).brightness,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                topLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                timeStr,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  height: 1,
                ),
              ),
              if (showProtocol) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: colors.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Jejum $bottomLabel',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (state is FastActive && progress > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ringColor.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color trackColor;
  final double strokeWidth;
  final Brightness brightness;

  _RingPainter({
    required this.progress,
    required this.ringColor,
    required this.trackColor,
    required this.strokeWidth,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    // Track
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0) {
      final glowOpacity = brightness == Brightness.dark ? 0.25 : 0.12;
      final blurSigma = brightness == Brightness.dark ? 8.0 : 4.0;

      // Glow
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = ringColor.withOpacity(glowOpacity)
          ..strokeWidth = strokeWidth + (brightness == Brightness.dark ? 8 : 4)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma),
      );

      // Progress
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = ringColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.ringColor != ringColor ||
      old.trackColor != trackColor ||
      old.brightness != brightness;
}
