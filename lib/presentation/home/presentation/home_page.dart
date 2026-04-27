import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mamba_fast_tracker/presentation/auth/cubit/auth_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/utils/date_utils.dart';
import '../cubit/fast_cubit.dart';
import '../../widgets/main_nav_shell.dart';
import 'widget/end_or_star_button_custom_widget.dart';
import 'widget/log_meal_button_custom_widget.dart';
import 'widget/start_end_row_custom_widget.dart';
import 'widget/timer_ring_custom_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MainNavShell(
      currentIndex: 0,
      child: BlocConsumer<FastCubit, FastState>(
        bloc: context.read<FastCubit>(),
        listener: (context, state) {
          if (state is FastCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.celebration, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Jejum concluído! ${fmtShort(state.session.elapsed)}'),
                  ],
                ),
                backgroundColor: AppTheme.kGreen.withOpacity(0.85),
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<FastCubit>().dismissCompleted();
                    context.canPop();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text('Home'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                    },
                    child: CircleAvatar(
                      backgroundColor: AppTheme.kGreen.withOpacity(0.12),
                      child: const Icon(
                        Icons.exit_to_app_rounded,
                        color: AppTheme.kGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    TimerRingCustomWidget(state: state),
                    const SizedBox(height: 20),
                    StartEndRowCustomWidget(state: state),
                    const SizedBox(height: 38),
                    LogMealButtonCustomWidget(state: state),
                    const SizedBox(height: 35),
                    EndOrStartButtonCustomWidget(state: state),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
