// lib/config/app_router.dart
// Configuração do roteador GoRouter para navegação na aplicação.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/auth_provider.dart'; // Importa o provedor de autenticação
import '../features/auth/screens/login_page.dart'; // Importa a página de login
import '../features/dashboard/screens/dashboard_page.dart'; // Importa a página do dashboard
import '../features/auth/screens/signup_page.dart'; // Importa a página de registo

final goRouterProvider = Provider<GoRouter>((ref) {
  // Observa o estado de autenticação do utilizador
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/', // Define a rota inicial
    routes: [
      // Rota para a página de login
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // Rota para a página de registo
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      // Rota para a página do dashboard
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      // Adicione outras rotas aqui conforme a aplicação cresce
    ],
    // Lógica de redirecionamento baseada no estado de autenticação
    redirect: (context, state) {
      // Verifica se o utilizador está autenticado
      final bool loggedIn = authState.value != null;
      // Verifica se a rota atual é a de login ou registo, usando state.fullPath
      final bool tryingToAuth =
          state.fullPath == '/' || state.fullPath == '/signup';

      // Se o utilizador NÃO estiver autenticado
      if (!loggedIn) {
        // Se ele estiver a tentar ir para o login ou registo, permite. Senão, redireciona para o login.
        return tryingToAuth ? null : '/';
      }

      // Se o utilizador ESTIVER autenticado
      if (loggedIn) {
        // Se ele estiver na página de login ou registo, redireciona para o dashboard
        return tryingToAuth ? '/dashboard' : null;
      }

      // Nenhuma mudança de rota necessária
      return null;
    },
  );
});
