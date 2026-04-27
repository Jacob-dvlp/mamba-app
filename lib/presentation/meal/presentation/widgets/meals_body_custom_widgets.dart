import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamba_fast_tracker/presentation/meal/presentation/widgets/add_meal_sheet_custom_widget.dart';

import '../../../../domain/entities/meal_entity.dart';
import '../../cubit/meal_cubit.dart';
import 'meal_title_custom_widget.dart';

class MealsBody extends StatelessWidget {
  final MealLoaded state;
  const MealsBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final colors = theme.colorScheme;

    final textMuted = theme.colorScheme.onSurface.withOpacity(0.3);

    if (state.meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 64,
              color: color.withOpacity(0.25),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma refeição hoje',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em Adicionar para registrar',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total de hoje',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${state.totalCalories} kcal',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.meals.length,
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => _showAddMealSheet(context, state.meals[i]),
              child: MealTitleCustomWidget(meal: state.meals[i]),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddMealSheet(BuildContext context, MealEntity meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<MealCubit>(),
        child: AddMealSheetCustomWidget(
          isEdit: true,
          meal: meal,
        ),
      ),
    );
  }
}
