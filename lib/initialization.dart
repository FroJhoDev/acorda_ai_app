import 'src/core/injections/dependency_injection_simple.dart';

/// Inicializa o aplicativo com todas as dependências necessárias
Future<void> initializeApp() async {
  // Configura todas as injeções de dependência
  await setupDependencyInjection();
}
