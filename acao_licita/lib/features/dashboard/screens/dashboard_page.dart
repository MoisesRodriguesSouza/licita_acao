// lib/features/dashboard/screens/dashboard_page.dart
// Ecrã do Dashboard, exibido após o login bem-sucedido.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as FBAuth; // Alias para User do Firebase
import '../../../core/providers/auth_provider.dart'; // Provedores de autenticação

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa a instância do Firebase Auth para obter o utilizador atual
    final auth = ref.watch(firebaseAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Ícone de terminar sessão
            onPressed: () async {
              // Chama o serviço de autenticação para terminar a sessão do utilizador
              await ref.read(authServiceProvider).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo(a) à AÇÃO LÍCITA!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            // Exibe o e-mail do utilizador autenticado, se houver
            if (auth.currentUser != null)
              Text(
                'Utilizador: ${auth.currentUser!.email}',
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
