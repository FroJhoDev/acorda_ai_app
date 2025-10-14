import 'package:flutter/material.dart';

import 'initialization.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o aplicativo
  await initializeApp();
  
  runApp(const AcordaAIApp());
}