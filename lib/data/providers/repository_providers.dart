import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cashpilot_v2/data/repositories/category_repository.dart';
import 'package:cashpilot_v2/data/repositories/transaction_repository.dart';
import 'package:cashpilot_v2/data/models/category.dart';
import 'package:cashpilot_v2/data/models/transaction.dart';

// Repositories
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

// Streams de dados
final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  // Converter Future para Stream
  return Stream.fromFuture(repo.getAll());
});

final transactionsStreamProvider = StreamProvider<List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return Stream.fromFuture(repo.getAll());
});

// Providers com filtro por mês
final currentMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final monthlyTransactionsProvider =
    FutureProvider.family<List<Transaction>, DateTime>((ref, month) {
      final repo = ref.watch(transactionRepositoryProvider);
      return repo.getAll(month: month.month, year: month.year);
    });

final monthlySummaryProvider =
    FutureProvider.family<Map<String, double>, DateTime>((ref, month) {
      final repo = ref.watch(transactionRepositoryProvider);
      return repo.getMonthlySummary(month.month, month.year);
    });

// Saldo total
final balanceProvider = FutureProvider<double>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getBalance();
});
