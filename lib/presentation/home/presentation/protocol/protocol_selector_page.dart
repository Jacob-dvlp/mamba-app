import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mamba_fast_tracker/domain/entities/fast_protocol_entity.dart';
import 'package:mamba_fast_tracker/presentation/home/cubit/fast_cubit.dart';

import '../../../../core/utils/string_constants_utils.dart';
import 'widget/custom_card_widget.dart';

class ProtocolSelectorPage extends StatefulWidget {
  const ProtocolSelectorPage({super.key});

  @override
  State<ProtocolSelectorPage> createState() => _ProtocolSelectorPageState();
}

class _ProtocolSelectorPageState extends State<ProtocolSelectorPage> {
  FastProtocolEntity _selected = FastProtocolEntity.twelve12;
  bool _isCustom = false;
  int _customFasting = 20;
  int _customEating = 4;
  bool _loading = false;

  static const _presets = [
    FastProtocolEntity.twelve12,
    FastProtocolEntity.sixteen8,
    FastProtocolEntity.eighteen6,
  ];

  Future<void> _confirm() async {
    if (_loading) return;

    setState(() => _loading = true);

    final protocol = _isCustom
        ? FastProtocolEntity.custom(
            fastingHours: _customFasting,
            eatingHours: _customEating,
          )
        : _selected;

    if (mounted) {
      await context.read<FastCubit>().startFast(protocol);
      await context.read<FastCubit>().loadCurrentFast();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Escolher protocolo',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Protocolos pré-definidos',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              ..._presets.map(
                (p) => PresetCard(
                  protocol: p,
                  description: descriptions[p.type] ?? '',
                  isSelected: !_isCustom && _selected == p,
                  onTap: () => setState(() {
                    _selected = p;
                    _isCustom = false;
                  }),
                ),
              ),
              const SizedBox(height: 8),
              CustomCardWidget(
                isSelected: _isCustom,
                fastingHours: _customFasting,
                eatingHours: _customEating,
                onTap: () => setState(() => _isCustom = true),
                onFastingChanged: (v) => setState(() => _customFasting = v),
                onEatingChanged: (v) => setState(() => _customEating = v),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: theme.colorScheme.onPrimary,
                    disabledBackgroundColor: color.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          'Iniciar jejum ${_isCustom ? "$_customFasting:$_customEating" : _selected.label}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
