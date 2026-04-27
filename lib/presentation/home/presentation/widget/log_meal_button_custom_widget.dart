import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../meal/cubit/meal_cubit.dart';
import '../../cubit/fast_cubit.dart';
import 'quick_add_meal_sheet_custom_widget.dart';

class LogMealButtonCustomWidget extends StatelessWidget {
  final FastState state;
  const LogMealButtonCustomWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => _showAddMealSheet(context),
        icon: const Icon(Icons.restaurant_rounded, size: 20),
        label: const Text(
          'Registrar Refeição',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showAddMealSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<MealCubit>(),
        child: const QuickAddMealSheetCustomWidget(),
      ),
    );
  }
}
