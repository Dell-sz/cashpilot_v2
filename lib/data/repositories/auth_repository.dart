import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cashpilot_v2/core/supabase_client.dart';

class AuthRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  // Login
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return response.user;
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e.message));
    } catch (e) {
      throw Exception('Erro ao fazer login. Tente novamente.');
    }
  }

  // Cadastro
  Future<User?> signUp(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );
      return response.user;
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e.message));
    } catch (e) {
      throw Exception('Erro ao cadastrar. Tente novamente.');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Usuário atual
  User? get currentUser => _client.auth.currentUser;

  // Stream de auth state
  Stream<AuthState> get authState => _client.auth.onAuthStateChange;

  // Mapear erros comuns do Supabase para mensagens amigáveis
  String _mapAuthError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'E-mail ou senha incorretos';
    }
    if (error.contains('Email not confirmed')) {
      return 'E-mail não confirmado. Verifique sua caixa de entrada.';
    }
    if (error.contains('User already registered')) {
      return 'Este e-mail já está cadastrado';
    }
    if (error.contains('Password should be at least 6 characters')) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return error;
  }
}
