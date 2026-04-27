import 'package:flutter/material.dart';

InputDecoration inputDecoration(
  ThemeData theme, {
  required String label,
  required IconData icon,
}) {
  final color = theme.colorScheme.primary;
  final textColor = theme.colorScheme.onSurface;

  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
    prefixIcon: Icon(icon, color: textColor.withOpacity(0.6), size: 20),
    filled: true,
    fillColor: theme.colorScheme.surface.withOpacity(0.6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}
