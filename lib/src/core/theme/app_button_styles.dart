import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Estilos de botões do aplicativo
class AppButtonStyles {
  AppButtonStyles._();

  // Botão Primário (Azul)
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  // Botão Secundário (Outline)
  static ButtonStyle secondary = OutlinedButton.styleFrom(
    foregroundColor: AppColors.textPrimary,
    side: const BorderSide(color: AppColors.border, width: 1),
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  // Botão de Deletar (Vermelho)
  static ButtonStyle delete = TextButton.styleFrom(
    foregroundColor: AppColors.error,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  // Botão de Editar
  static ButtonStyle edit = TextButton.styleFrom(
    foregroundColor: AppColors.textSecondary,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  // Botão Ícone
  static ButtonStyle icon = IconButton.styleFrom(
    foregroundColor: AppColors.iconSecondary,
    padding: const EdgeInsets.all(AppSpacing.sm),
  );

  // FAB (Floating Action Button)
  static ButtonStyle fab = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: AppSpacing.elevationLg,
    padding: const EdgeInsets.all(AppSpacing.md),
    shape: const CircleBorder(),
  );
}
