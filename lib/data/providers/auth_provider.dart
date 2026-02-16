import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cashpilot_v2/data/repositories/auth_repository.dart';
import 'package:cashpilot_v2/core/supabase_client.dart';

// Provider do repositório
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Provider do usuário atual (stream)
final authStateProvider = StreamProvider<User?>((ref) {
  return SupabaseConfig.client.auth.onAuthStateChange.map((event) {
    return event.session?.user;
  });
});

// Provider do usuário logado (valor atual)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// Provider de status de autenticação
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});
