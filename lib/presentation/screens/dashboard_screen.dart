import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cashpilot_v2/data/providers/auth_provider.dart';
import 'package:cashpilot_v2/data/repositories/auth_repository.dart';
import 'package:cashpilot_v2/core/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authRepo = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authRepo.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Center(
                child: Text('💰', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bem-vindo ao CashPilot!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? 'Usuário',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'DIA 2 concluído! Amanhã implementamos:',
                          style: TextStyle(color: AppColors.text),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(width: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• Modelos de dados',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          Text(
                            '• Repositórios',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          Text(
                            '• Providers',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          Text(
                            '• Testes com Supabase',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
