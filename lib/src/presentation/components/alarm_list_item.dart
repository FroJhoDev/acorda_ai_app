import 'package:flutter/material.dart';
import '../../domain/entities/location_alarm.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';

/// Widget para exibir um item de alarme na lista
class AlarmListItem extends StatelessWidget {
  final LocationAlarm alarm;
  final VoidCallback? onTap;
  final Function(bool)? onToggle;

  const AlarmListItem({
    super.key,
    required this.alarm,
    this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alarm.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alarm.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: alarm.isActive,
                    onChanged: onToggle,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${alarm.radius.toInt()}m de raio',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  _buildStatusChip(),
                ],
              ),
              if (alarm.isTriggered && alarm.triggeredAt != null) ...[
                const SizedBox(height: AppConstants.smallPadding),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Disparado em ${_formatDateTime(alarm.triggeredAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    if (alarm.isTriggered) {
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[800]!;
      text = AppStrings.alarmTriggered;
      icon = Icons.alarm_off;
    } else if (alarm.isActive) {
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      text = AppStrings.alarmActive;
      icon = Icons.alarm_on;
    } else {
      backgroundColor = Colors.grey[200]!;
      textColor = Colors.grey[700]!;
      text = AppStrings.alarmInactive;
      icon = Icons.alarm_off;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min atrás';
    } else {
      return 'Agora';
    }
  }
}
