import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cashpilot_v2/core/supabase_client.dart';
import 'package:cashpilot_v2/data/models/category.dart';

class CategoryRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  // Buscar todas as categorias do usuário
  Future<List<Category>> getAll() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('categories')
          .select()
          .eq('user_id', userId)
          .order('name');

      return (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  // Buscar categorias por tipo (income/expense)
  Future<List<Category>> getByType(String type) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('categories')
          .select()
          .eq('user_id', userId)
          .inFilter('type', [type, 'both'])
          .order('name');

      return (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  // Buscar categoria por ID
  Future<Category?> getById(String id) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('categories')
          .select()
          .eq('id', id)
          .eq('user_id', userId)
          .single();

      return Category.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Criar nova categoria
  Future<Category> create(Category category) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('categories')
          .insert(category.toInsertJson())
          .select()
          .single();

      return Category.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar categoria: $e');
    }
  }

  // Atualizar categoria
  Future<Category> update(Category category) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('categories')
          .update({
            'name': category.name,
            'color': category.color,
            'icon': category.icon,
            'type': category.type,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', category.id)
          .eq('user_id', userId)
          .select()
          .single();

      return Category.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar categoria: $e');
    }
  }

  // Deletar categoria
  Future<void> delete(String id) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      await _client
          .from('categories')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }

  // Verificar se categoria está em uso
  Future<bool> isInUse(String id) async {
    try {
      final response = await _client
          .from('transactions')
          .select('id')
          .eq('category_id', id)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
