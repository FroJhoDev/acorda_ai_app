import 'package:flutter/material.dart';
import '../../domain/entities/location_alarm.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Card de alarme para exibição em lista
class AlarmCard extends StatelessWidget {
  final LocationAlarm alarm;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AlarmCard({
    super.key,
    required this.alarm,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com nome e status
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Ícone do tipo de local
                Container(
                  width: AppSpacing.avatarMd,
                  height: AppSpacing.avatarMd,
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    _getIconForAlarm(),
                    color: _getStatusColor(),
                    size: AppSpacing.iconMd,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Nome e endereço
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alarm.title,
                              style: AppTextStyles.alarmTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _StatusBadge(
                            label: alarm.isActive ? 'Ativo' : 'Inativo',
                            color: _getStatusColor(),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${alarm.latitude.toStringAsFixed(4)}, ${alarm.longitude.toStringAsFixed(4)}',
                        style: AppTextStyles.alarmAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Toggle switch
                Switch(
                  value: alarm.isActive,
                  onChanged: onToggle,
                  activeColor: AppColors.active,
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Informações do alarme
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.adjust,
                  size: AppSpacing.iconSm,
                  color: AppColors.iconSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Raio: ${alarm.radius.toInt()}m',
                  style: AppTextStyles.alarmInfo,
                ),
                const SizedBox(width: AppSpacing.lg),
                Icon(
                  Icons.music_note,
                  size: AppSpacing.iconSm,
                  color: AppColors.iconSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Som: ${alarm.soundPath.isNotEmpty ? 'Custom' : 'Padrão'}',
                    style: AppTextStyles.alarmInfo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Ações
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: AppSpacing.iconSm),
                  label: const Text('Editar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: AppSpacing.iconSm),
                  label: const Text('Deletar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    return alarm.isActive ? AppColors.active : AppColors.inactive;
  }

  IconData _getIconForAlarm() {
    // Mapeia ícones baseado no nome ou tipo
    final name = alarm.title.toLowerCase();
    if (name.contains('trabalho') || name.contains('work')) {
      return Icons.work;
    } else if (name.contains('casa') || name.contains('home')) {
      return Icons.home;
    } else if (name.contains('academia') || name.contains('gym')) {
      return Icons.fitness_center;
    } else if (name.contains('escola') || name.contains('school')) {
      return Icons.school;
    }
    return Icons.place;
  }
}

/// Badge de status
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
