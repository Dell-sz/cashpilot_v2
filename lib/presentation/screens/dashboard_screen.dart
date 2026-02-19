import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cashpilot_v2/data/providers/auth_provider.dart';
import 'package:cashpilot_v2/data/providers/repository_providers.dart';
import 'package:cashpilot_v2/data/models/transaction.dart';
import 'package:cashpilot_v2/core/theme/app_theme.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTime _selectedMonth = DateTime.now();

  String get _monthYearText {
    return DateFormat('MMMM yyyy', 'pt_BR').format(_selectedMonth);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(
      monthlyTransactionsProvider(_selectedMonth),
    );
    final summaryAsync = ref.watch(monthlySummaryProvider(_selectedMonth));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Deseja realmente sair?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                ref.read(authRepositoryProvider).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seletor de mês
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _previousMonth,
                      splashRadius: 20,
                    ),
                    Text(
                      _monthYearText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextMonth,
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cards de resumo
              summaryAsync.when(
                data: (summary) => Row(
                  children: [
                    // Saldo total
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Saldo',
                        value: summary['balance'] ?? 0,
                        icon: Imons.total_balance,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Entradas
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Entradas',
                        value: summary['income'] ?? 0,
                        icon: Icons.arrow_upward,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Saídas
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Saídas',
                        value: summary['expense'] ?? 0,
                        icon: Icons.arrow_downward,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    const Center(child: Text('Erro ao carregar resumo')),
              ),
              const SizedBox(height: 24),

              // Gráfico de distribuição
              const Text(
                'Distribuição de Despesas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              _buildExpenseChart(transactionsAsync),
              const SizedBox(height: 24),

              // Últimas transações
              const Text(
                'Últimas Transações',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              _buildRecentTransactions(transactionsAsync),
              const SizedBox(height: 16),

              // Botão nova transação
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navegar para tela de nova transação (DIA 5)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Funcionalidade em desenvolvimento - DIA 5',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nova Transação'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatter.format(value),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: title == 'Saldo'
                  ? (value >= 0 ? AppColors.success : AppColors.error)
                  : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseChart(AsyncValue<List<Transaction>> transactionsAsync) {
    return transactionsAsync.when(
      data: (transactions) {
        // Filtrar apenas despesas
        final expenses = transactions
            .where((t) => t.type == 'expense')
            .toList();

        if (expenses.isEmpty) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'Nenhuma despesa no mês',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        // Agrupar por categoria
        Map<String, double> categoryTotals = {};
        for (var expense in expenses) {
          final categoryName = expense.categoryName ?? 'Outros';
          categoryTotals[categoryName] =
              (categoryTotals[categoryName] ?? 0) + expense.amount;
        }

        // Preparar dados para o gráfico
        final List<PieChartSectionData> sections = [];
        final colors = [
          AppColors.primary,
          AppColors.secondary,
          AppColors.success,
          AppColors.warning,
          AppColors.error,
          AppColors.info,
          Colors.purple,
          Colors.orange,
          Colors.teal,
        ];

        int colorIndex = 0;
        categoryTotals.forEach((category, amount) {
          sections.add(
            PieChartSectionData(
              value: amount,
              title:
                  '${(amount / categoryTotals.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%',
              color: colors[colorIndex % colors.length],
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
          colorIndex++;
        });

        return Container(
          height: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'Erro ao carregar gráfico',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
    AsyncValue<List<Transaction>> transactionsAsync,
  ) {
    return transactionsAsync.when(
      data: (transactions) {
        final recent = transactions.take(5).toList();

        if (recent.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 12),
                Text(
                  'Nenhuma transação ainda',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 4),
                Text(
                  'Clique em "Nova Transação" para começar',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recent.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: AppColors.border),
          itemBuilder: (context, index) {
            final t = recent[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: t.type == 'income'
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(t.icon, style: const TextStyle(fontSize: 20)),
                ),
              ),
              title: Text(
                t.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              subtitle: Text(
                t.categoryName ?? 'Sem categoria',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t.formattedAmount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: t.type == 'income'
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM').format(t.date),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'Erro ao carregar transações',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}
