import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../meal/cubit/meal_cubit.dart';
import '../../../widgets/inputs_decoration_custom.dart';

class QuickAddMealSheetCustomWidget extends StatefulWidget {
  const QuickAddMealSheetCustomWidget({super.key});
  @override
  State<QuickAddMealSheetCustomWidget> createState() =>
      _QuickAddMealSheetCustomWidgetState();
}

class _QuickAddMealSheetCustomWidgetState
    extends State<QuickAddMealSheetCustomWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  @override
  void dispose() {
    _nameCtrl.dispose();
    _calCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<MealCubit>().addMeal(
            name: _nameCtrl.text.trim(),
            calories: int.parse(_calCtrl.text),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Registrar Refeição',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: inputDecoration(
                theme,
                label: 'Nome',
                icon: Icons.restaurant_outlined,
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _calCtrl,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(
                theme,
                label: 'Calorias (kcal)',
                icon: Icons.local_fire_department_outlined,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe as calorias';
                final n = int.tryParse(v);
                if (n == null || n <= 0) return 'Número inválido';
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  disabledBackgroundColor: colors.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: _submit,
                child: const Text(
                  'Registrar Refeição',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
