import 'package:flutter/material.dart';

class SectionTitleCustomWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const SectionTitleCustomWidget({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final accent = color ?? colors.primary;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: accent,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
