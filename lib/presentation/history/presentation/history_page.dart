import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/history_cubit.dart';
import '../../widgets/main_nav_shell.dart';
import 'widget/day_details_scaffold_custom_widget.dart';
import 'widget/empty_history_custom_widget.dart';
import 'widget/history_list_custom_widget.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().loadLast30Days();
  }

  @override
  Widget build(BuildContext context) {
    return MainNavShell(
      currentIndex: 2,
      child: BlocBuilder<HistoryCubit, HistoryState>(
        bloc: context.read<HistoryCubit>(),
        builder: (context, state) {
          // Detalhe do dia: usa Navigator.push interno para manter o bottom nav
          if (state is HistoryDayDetail) {
            return DayDetailsScaffoldCustomWidget(log: state.log);
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Histórico'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () =>
                      context.read<HistoryCubit>().loadLast30Days(),
                ),
              ],
            ),
            body: () {
              if (state is HistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HistoryError) {
                return ErrorViewCustomWidget(
                  message: state.message,
                  onRetry: () => context.read<HistoryCubit>().loadLast30Days(),
                );
              }
              if (state is HistoryLoaded) {
                if (state.logs.isEmpty) return const EmptyHistoryCustomWidget();
                return HistoryListCustomWidget(logs: state.logs);
              }
              return const SizedBox.shrink();
            }(),
          );
        },
      ),
    );
  }
}
