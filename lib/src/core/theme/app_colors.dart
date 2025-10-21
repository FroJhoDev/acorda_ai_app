import 'package:flutter/material.dart';

/// Cores do aplicativo AcordaAI
class AppColors {
  AppColors._();

  // Cores Primárias
  static const Color primary = Color(0xFF1E88E5); // Azul vibrante
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);

  // Cores de Status
  static const Color active = Color(0xFF4CAF50); // Verde - Ativo
  static const Color inactive = Color(0xFF9E9E9E); // Cinza - Inativo
  static const Color paused = Color(0xFFFFC107); // Amarelo - Pausado
  static const Color error = Color(0xFFEF5350); // Vermelho - Erro

  // Background e Superfícies
  static const Color background = Color(0xFF121212); // Fundo escuro
  static const Color surface = Color(0xFF1E1E1E); // Superfície escura
  static const Color surfaceLight = Color(0xFF2C2C2C); // Superfície clara
  static const Color card = Color(0xFF1A1A1A); // Card escuro

  // Textos
  static const Color textPrimary = Color(0xFFFFFFFF); // Branco
  static const Color textSecondary = Color(0xFFB0B0B0); // Cinza claro
  static const Color textHint = Color(0xFF757575); // Cinza médio

  // Bordas e Divisores
  static const Color border = Color(0xFF2C2C2C);
  static const Color divider = Color(0xFF2C2C2C);

  // Ícones
  static const Color iconPrimary = Color(0xFFFFFFFF);
  static const Color iconSecondary = Color(0xFF9E9E9E);
  static const Color iconActive = Color(0xFF4CAF50);

  // Accent e Destaque
  static const Color accent = Color(0xFFFF9800); // Laranja
  static const Color accentLight = Color(0xFFFFB74D);

  // Transparências
  static const Color overlay = Color(0x80000000); // 50% preto
  static const Color scrim = Color(0xB3000000); // 70% preto

  // Cores de Mapas
  static const Color mapPinActive = Color(0xFF4CAF50);
  static const Color mapPinInactive = Color(0xFF607D8B);
  static const Color mapPinPaused = Color(0xFFFFC107);
  static const Color mapCurrentLocation = Color(0xFF1E88E5);
}
