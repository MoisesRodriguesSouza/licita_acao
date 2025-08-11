// =================================================================================
// lib/config/app_router.dart
// Configuração do roteador GoRouter.
// =================================================================================
import 'package:acao_licita/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acao_licita/core/services/providers/auth_provider.dart';

import '../features/auth/screens/login_page.dart';
import '../features/dashboard/screens/dashboard_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Observa o estado de autenticação para acionar o 'redirect'
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    redirect: (context, state) {
      // Usa o valor mais recente do provider, sem 'watch' para evitar loops
      final authStateValue = ref.read(authStateProvider);
      final loggedIn = authStateValue.valueOrNull != null;

      // Enquanto o estado de autenticação está carregando,
      // permaneça na tela de splash.
      if (authStateValue.isLoading) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      final onLoginPage = state.matchedLocation == '/';
      final onSplashPage = state.matchedLocation == '/splash';

      // Se o usuário não está logado, deve ir para a tela de login.
      if (!loggedIn) {
        return onLoginPage ? null : '/';
      }

      // Se o usuário está logado e na tela de login ou splash,
      // redireciona para o dashboard.
      if (loggedIn && (onLoginPage || onSplashPage)) {
        return '/dashboard';
      }

      return null;
    },
  );
});
