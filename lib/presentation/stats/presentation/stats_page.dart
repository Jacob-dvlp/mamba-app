import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/stats_cubit.dart';
import '../../widgets/main_nav_shell.dart';
import 'widgets/stats_body_custom_widget.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool _showFasting = true;
  @override
  void initState() {
    super.initState();
    context.read<StatsCubit>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainNavShell(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estatísticas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => context.read<StatsCubit>().loadStats(),
            ),
          ],
        ),
        body: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, state) {
            if (state is StatsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StatsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(state.message),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.read<StatsCubit>().loadStats(),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }
            if (state is StatsLoaded) {
              return StatsBody(
                state: state,
                showFasting: _showFasting,
                onToggle: (v) => setState(() => _showFasting = v),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
