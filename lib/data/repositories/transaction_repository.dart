import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cashpilot_v2/core/supabase_client.dart';
import 'package:cashpilot_v2/data/models/transaction.dart';

class TransactionRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  // Buscar todas as transações do usuário
  Future<List<Transaction>> getAll({int? limit, int? month, int? year}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('transactions')
          .select('''
            *,
            categories (
              name
            )
          ''')
          .eq('user_id', userId)
          .order('date', ascending: false);

      List<Transaction> transactions = (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      // Filtrar por mês/ano em memória se necessário
      if (month != null && year != null) {
        transactions = transactions.where((t) {
          return t.date.month == month && t.date.year == year;
        }).toList();
      }

      if (limit != null) {
        transactions = transactions.take(limit).toList();
      }

      return transactions;
    } catch (e) {
      throw Exception('Erro ao buscar transações: $e');
    }
  }

  // Buscar transações por tipo
  Future<List<Transaction>> getByType(
    String type, {
    int? month,
    int? year,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('transactions')
          .select('''
            *,
            categories (
              name
            )
          ''')
          .eq('user_id', userId)
          .eq('type', type)
          .order('date', ascending: false);

      List<Transaction> transactions = (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      // Filtrar por mês/ano em memória se necessário
      if (month != null && year != null) {
        transactions = transactions.where((t) {
          return t.date.month == month && t.date.year == year;
        }).toList();
      }

      return transactions;
    } catch (e) {
      throw Exception('Erro ao buscar transações: $e');
    }
  }

  // Buscar transação por ID
  Future<Transaction?> getById(String id) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('transactions')
          .select('''
            *,
            categories (
              name
            )
          ''')
          .eq('id', id)
          .eq('user_id', userId)
          .single();

      return Transaction.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Criar nova transação
  Future<Transaction> create(Transaction transaction) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('transactions')
          .insert(transaction.toInsertJson())
          .select('''
            *,
            categories (
              name
            )
          ''')
          .single();

      return Transaction.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar transação: $e');
    }
  }

  // Atualizar transação
  Future<Transaction> update(Transaction transaction) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('transactions')
          .update({
            'category_id': transaction.categoryId,
            'amount': transaction.amount,
            'type': transaction.type,
            'description': transaction.description,
            'date': transaction.date.toIso8601String().split('T').first,
            'is_recurring': transaction.isRecurring,
            'recurring_frequency': transaction.recurringFrequency,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', transaction.id)
          .eq('user_id', userId)
          .select('''
            *,
            categories (
              name
            )
          ''')
          .single();

      return Transaction.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar transação: $e');
    }
  }

  // Deletar transação
  Future<void> delete(String id) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      await _client
          .from('transactions')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Erro ao deletar transação: $e');
    }
  }

  // Calcular saldo
  Future<double> getBalance() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('transactions')
          .select('amount, type')
          .eq('user_id', userId);

      double balance = 0;
      for (var t in response) {
        if (t['type'] == 'income') {
          balance += (t['amount'] as num).toDouble();
        } else {
          balance -= (t['amount'] as num).toDouble();
        }
      }
      return balance;
    } catch (e) {
      return 0;
    }
  }

  // Calcular totais do mês
  Future<Map<String, double>> getMonthlySummary(int month, int year) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Usuário não autenticado');

      final response = await _client
          .from('transactions')
          .select('amount, type, date')
          .eq('user_id', userId);

      double income = 0;
      double expense = 0;

      for (var t in response) {
        final date = DateTime.parse(t['date'] as String);
        if (date.month == month && date.year == year) {
          if (t['type'] == 'income') {
            income += (t['amount'] as num).toDouble();
          } else {
            expense += (t['amount'] as num).toDouble();
          }
        }
      }

      return {
        'income': income,
        'expense': expense,
        'balance': income - expense,
      };
    } catch (e) {
      return {'income': 0, 'expense': 0, 'balance': 0};
    }
  }
}
