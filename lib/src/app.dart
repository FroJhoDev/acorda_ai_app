import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'presentation/pages/map_home/map_home_page.dart';

/// Widget principal do aplicativo AcordaAI
class AcordaAIApp extends StatelessWidget {
  const AcordaAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MapHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
