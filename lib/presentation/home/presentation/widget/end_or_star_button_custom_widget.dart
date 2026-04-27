import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/fast_session_entity.dart';
import '../../cubit/fast_cubit.dart';

class EndOrStartButtonCustomWidget extends StatelessWidget {
  final FastState state;
  const EndOrStartButtonCustomWidget({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FastCubit>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isActive = state is FastActive;
    final isRunning =
        isActive && (state as FastActive).session.status == FastStatus.running;

    if (!isActive && state is! FastCompleted) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          onPressed: () => context.push('/home/protocol-selector'),
          icon: Icon(Icons.play_arrow_rounded, color: colors.primary),
          label: Text(
            'Iniciar Jejum',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (isActive) ...[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: isRunning ? cubit.pauseFast : cubit.resumeFast,
              icon: Icon(
                isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isRunning ? colors.tertiary : colors.primary,
              ),
              label: Text(
                isRunning ? 'Pausar Jejum' : 'Retomar Jejum',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isRunning ? colors.tertiary : colors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isRunning ? colors.tertiary : colors.primary,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: () => _confirmEnd(context, cubit),
            style: TextButton.styleFrom(
              backgroundColor: colors.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: colors.outline),
              ),
            ),
            child: Text(
              'Encerrar Jejum antecipadamente',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmEnd(BuildContext context, FastCubit cubit) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // ❌ remove backgroundColor manual
        title: Text(
          'Encerrar jejum?',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Seu progresso será salvo no histórico.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.endFast();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colors.tertiary,
            ),
            child: Text(
              'Encerrar Jejum',
              style: TextStyle(color: colors.onTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
