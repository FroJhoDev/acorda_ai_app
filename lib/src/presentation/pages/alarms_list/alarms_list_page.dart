import 'package:flutter/material.dart';
import '../../../domain/entities/location_alarm.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/injections/dependency_injection_simple.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../components/alarm_card.dart';
import '../alarm_form/alarm_form_page.dart';

/// Página de listagem de alarmes
class AlarmsListPage extends StatefulWidget {
  const AlarmsListPage({super.key});

  @override
  State<AlarmsListPage> createState() => _AlarmsListPageState();
}

class _AlarmsListPageState extends State<AlarmsListPage> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>();
    _viewModel.refresh();
  }

  int _getActiveCount() {
    return _viewModel.alarms.where((alarm) => alarm.isActive).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Alarmes',
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          // Contador de alarmes ativos
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return Text(
                    '${_getActiveCount()} Ativos',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _viewModel.refresh(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () => _viewModel.refresh(),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_viewModel.alarms.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxl + AppSpacing.lg,
            ),
            itemCount: _viewModel.alarms.length,
            itemBuilder: (context, index) {
              final alarm = _viewModel.alarms[index];
              return AlarmCard(
                alarm: alarm,
                onToggle: (value) async {
                  // TODO: Implementar toggle via UseCase
                  await _viewModel.refresh();
                },
                onEdit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlarmFormPage(
                        preselectedLocation:
                            null, // TODO: passar alarm para edição
                      ),
                    ),
                  );

                  if (result == true || mounted) {
                    await _viewModel.refresh();
                  }
                },
                onDelete: () {
                  _showDeleteConfirmation(context, alarm);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AlarmFormPage(),
            ),
          );

          if (result == true || mounted) {
            await _viewModel.refresh();
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm_off,
              size: 80,
              color: AppColors.iconSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nenhum alarme criado',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Toque no botão + para criar seu primeiro alarme',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar para criação
              },
              icon: const Icon(Icons.add),
              label: const Text('Criar Primeiro Alarme'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, LocationAlarm alarm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Excluir Alarme'),
        content: Text(
          'Deseja realmente excluir o alarme "${alarm.title}"?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              // TODO: Implementar deleção via UseCase
              Navigator.pop(context);
              await _viewModel.refresh();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${alarm.title} excluído'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
