import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cashpilot_v2/data/providers/repository_providers.dart';
import 'package:cashpilot_v2/data/models/category.dart';
import 'package:cashpilot_v2/data/models/transaction.dart';
import 'package:cashpilot_v2/core/theme/app_theme.dart';
import 'package:cashpilot_v2/data/providers/auth_provider.dart';

class TestDataScreen extends ConsumerStatefulWidget {
  const TestDataScreen({super.key});

  @override
  ConsumerState<TestDataScreen> createState() => _TestDataScreenState();
}

class _TestDataScreenState extends ConsumerState<TestDataScreen> {
  bool _isLoading = false;

  Future<void> _createTestData() async {
    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Usuário não logado');

      final categoryRepo = ref.read(categoryRepositoryProvider);
      final transactionRepo = ref.read(transactionRepositoryProvider);

      // Criar categoria de teste
      final testCategory = Category(
        id: '',
        userId: user.id,
        name: 'Teste ${DateTime.now().second}',
        color: '#FF5733',
        icon: '🧪',
        type: 'expense',
        isDefault: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdCategory = await categoryRepo.create(testCategory);

      // Criar transação de teste
      final testTransaction = Transaction(
        id: '',
        userId: user.id,
        categoryId: createdCategory.id,
        amount: 99.90,
        type: 'expense',
        description: 'Transação de teste',
        date: DateTime.now(),
        isRecurring: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await transactionRepo.create(testTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dados de teste criados com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final balanceAsync = ref.watch(balanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Teste de Dados')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botão criar teste
            ElevatedButton(
              onPressed: _isLoading ? null : _createTestData,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('➕ Criar Dados de Teste'),
            ),
            const SizedBox(height: 24),

            // Saldo total
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Total',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    balanceAsync.when(
                      data: (balance) => Text(
                        'R\$ ${balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Erro ao carregar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Categorias
            const Text(
              'Categorias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            categoriesAsync.when(
              data: (categories) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse(cat.color.substring(1, 7), radix: 16) +
                              0xFF000000,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text(cat.icon)),
                    ),
                    title: Text(cat.name),
                    subtitle: Text(cat.type),
                    trailing: cat.isDefault
                        ? const Icon(Icons.star, color: AppColors.warning)
                        : null,
                  );
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Erro ao carregar categorias'),
            ),
            const SizedBox(height: 16),

            // Transações
            const Text(
              'Transações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            transactionsAsync.when(
              data: (transactions) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: t.type == 'income'
                            ? AppColors.success.withOpacity(0.2)
                            : AppColors.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(t.type == 'income' ? '💰' : '💸'),
                      ),
                    ),
                    title: Text(t.description),
                    subtitle: Text(t.categoryName ?? 'Sem categoria'),
                    trailing: Text(
                      t.formattedAmount,
                      style: TextStyle(
                        color: t.type == 'income'
                            ? AppColors.success
                            : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Erro ao carregar transações'),
            ),
          ],
        ),
      ),
    );
  }
}
