// lib/main.dart
// Ponto de entrada principal da aplicação Flutter.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
// Importa o ficheiro gerado pelo FlutterFire CLI com as opções do Firebase
import 'firebase_options.dart';
// Importa a configuração do roteador da aplicação
import 'config/app_router.dart';

Future<void> main() async {
  // Garante que os widgets do Flutter estejam inicializados antes de configurar o Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as opções da plataforma atual
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Executa a aplicação Flutter, envolvendo-a com ProviderScope para usar Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa o provedor do roteador GoRouter
    final router = ref.watch(goRouterProvider);

    // Retorna MaterialApp.router para usar o sistema de roteamento do GoRouter
    return MaterialApp.router(
      title: 'AÇÃO LÍCITA', // Título da aplicação
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor primária do tema
        useMaterial3: true, // Habilita o Material Design 3
      ),
      routerConfig: router, // Atribui a configuração do roteador
    );
  }
}
