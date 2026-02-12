import 'package:flutter/material.dart';
import 'package:cashpilot_v2/core/supabase_client.dart';
import 'package:cashpilot_v2/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const CashPilotApp());
}

class CashPilotApp extends StatelessWidget {
  const CashPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashPilot V2',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text('CashPilot V2 🚀', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
