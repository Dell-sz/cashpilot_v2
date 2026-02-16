import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cashpilot_v2/core/supabase_client.dart';
import 'package:cashpilot_v2/core/theme/app_theme.dart';
import 'package:cashpilot_v2/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Supabase com suas credenciais
  await SupabaseConfig.initialize();

  runApp(const ProviderScope(child: CashPilotApp()));
}

class CashPilotApp extends ConsumerWidget {
  const CashPilotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CashPilot V2',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
