import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/meal_cubit.dart';
import '../../widgets/main_nav_shell.dart';
import 'widgets/add_meal_sheet_custom_widget.dart';
import 'widgets/meals_body_custom_widgets.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MealCubit>().loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    return MainNavShell(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('Refeições')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddMealSheet(context),
          child: const Icon(Icons.add_rounded),
        ),
        body: BlocBuilder<MealCubit, MealState>(
          builder: (context, state) {
            if (state is MealLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MealLoaded) {
              return MealsBody(state: state);
            }
            if (state is MealError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
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
        child: const AddMealSheetCustomWidget(),
      ),
    );
  }
}
