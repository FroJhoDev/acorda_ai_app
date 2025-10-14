import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// Dialog para solicitar permissão de localização
class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback? onGrantPermission;
  final VoidCallback? onCancel;

  const LocationPermissionDialog({
    super.key,
    this.onGrantPermission,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.permissionRequired),
      content: const Text(AppStrings.locationPermissionMessage),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: onGrantPermission ?? () => Navigator.of(context).pop(true),
          child: const Text(AppStrings.grantPermission),
        ),
      ],
    );
  }

  /// Mostra o dialog e retorna se o usuário aceitou ou não
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LocationPermissionDialog(),
    );

    return result ?? false;
  }
}
