// lib/features/auth/screens/login_page.dart
// Tela de Login e Registo de utilizadores.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Necessário para FirebaseAuthException
import '../../../core/providers/auth_provider.dart'; // Provedores de autenticação
import 'package:go_router/go_router.dart'; // Para navegação

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  bool _isLogin = true; // Alterna entre ecrã de Login e Registo

  // Função para submeter o formulário (Login ou Registo)
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Se o formulário for válido, tenta autenticar
      try {
        final authService = ref.read(
          authServiceProvider,
        ); // Obtém o serviço de autenticação
        if (_isLogin) {
          await authService.signInWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
        } else {
          // Se for registo, redireciona para a página de registo
          context.go('/signup');
          return; // Sai da função para não tentar registar aqui
        }
      } on FirebaseAuthException catch (e) {
        // Captura e exibe erros específicos do Firebase Auth
        if (!mounted)
          return; // Verifica se o widget ainda está montado antes de mostrar o SnackBar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
      } catch (e) {
        // Captura e exibe outros erros inesperados
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro inesperado: $e')),
        );
      }
    }
  }

  // Função para fazer login com a conta Google
  Future<void> _signInWithGoogle() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      // Captura e exibe erros específicos do Firebase Auth no login com Google
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro com o Google: ${e.message}')),
      );
    } catch (e) {
      // Captura e exibe outros erros inesperados no login com Google
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro inesperado com o Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Registo')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um e-mail.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Palavra-passe'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma palavra-passe.';
                    }
                    if (value.length < 6) {
                      return 'A palavra-passe deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isLogin ? 'Entrar' : 'Ir para Registo'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin; // Alterna entre login e registo
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Não tem uma conta? Crie uma.'
                        : 'Já tem uma conta? Entre.',
                  ),
                ),
                const Divider(height: 32),
                ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.g_mobiledata), // Ícone do Google
                  label: const Text('Entrar com Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
