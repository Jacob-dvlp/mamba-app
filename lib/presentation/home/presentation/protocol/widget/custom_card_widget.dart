import 'package:flutter/material.dart';

import '../../../../../domain/entities/fast_protocol_entity.dart';
import 'silder_row_widget.dart';

class CustomCardWidget extends StatelessWidget {
  final bool isSelected;
  final int fastingHours;
  final int eatingHours;
  final VoidCallback onTap;
  final ValueChanged<int> onFastingChanged;
  final ValueChanged<int> onEatingChanged;

  const CustomCardWidget({
    super.key,
    required this.isSelected,
    required this.fastingHours,
    required this.eatingHours,
    required this.onTap,
    required this.onFastingChanged,
    required this.onEatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color
                : theme.colorScheme.onSurface.withOpacity(0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: isSelected ? theme.colorScheme.onPrimary : color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personalizar Protocolo',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${fastingHours}h jejum · ${eatingHours}h comendo',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: color,
                    size: 22,
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              SliderRowWidget(
                label: 'Jejum',
                value: fastingHours,
                min: 8,
                max: 23,
                onChanged: onFastingChanged,
              ),
              const SizedBox(height: 4),
              SliderRowWidget(
                label: 'Comendo',
                value: eatingHours,
                min: 1,
                max: 16,
                onChanged: onEatingChanged,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PresetCard extends StatelessWidget {
  final FastProtocolEntity protocol;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const PresetCard({
    super.key,
    required this.protocol,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color
                : theme.colorScheme.onSurface.withOpacity(0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  protocol.label,
                  style: TextStyle(
                    color: isSelected ? theme.colorScheme.onPrimary : color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    protocol.label,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: color,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
