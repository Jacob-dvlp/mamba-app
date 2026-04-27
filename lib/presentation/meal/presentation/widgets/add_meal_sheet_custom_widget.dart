import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/meal_entity.dart';
import '../../../widgets/inputs_decoration_custom.dart';
import '../../cubit/meal_cubit.dart';

class AddMealSheetCustomWidget extends StatefulWidget {
  final bool isEdit;
  final MealEntity? meal;

  const AddMealSheetCustomWidget({
    super.key,
    this.isEdit = false,
    this.meal,
  }) : assert(
          !isEdit || meal != null,
          'meal must be provided when isEdit is true',
        );

  @override
  State<AddMealSheetCustomWidget> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends State<AddMealSheetCustomWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.meal != null) {
      _nameCtrl.text = widget.meal!.name;
      _calCtrl.text = widget.meal!.calories.toString();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _calCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);

    final name = _nameCtrl.text.trim();
    final calories = int.parse(_calCtrl.text);

    final cubit = context.read<MealCubit>();

    if (widget.isEdit) {
      await cubit.updateMeal(
        widget.meal!.copyWith(
          name: name,
          calories: calories,
          loggedAt: widget.meal!.loggedAt,
        ),
      );
    } else {
      await cubit.addMeal(name: name, calories: calories);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;

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
                  color: textColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.isEdit ? 'Editar refeição' : 'Nova refeição',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: textColor),
              decoration: inputDecoration(
                theme,
                label: 'Nome da refeição',
                icon: Icons.restaurant_outlined,
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _calCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
              decoration: inputDecoration(
                theme,
                label: 'Calorias (kcal)',
                icon: Icons.local_fire_department_outlined,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe as calorias';
                final n = int.tryParse(v);
                if (n == null || n <= 0) return 'Valor inválido';
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: theme.colorScheme.onPrimary,
                  disabledBackgroundColor: color.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        widget.isEdit
                            ? 'Atualizar refeição'
                            : 'Salvar refeição',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
