// Placeholder for router
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // 🔴 NOVAS CREDENCIAIS - CashPilot V2
  static const String _supabaseUrl = 'https://fzyxcrbznsnpmntgnxnn.supabase.co';
  static const String _supabaseAnonKey =
      'sb_publishable_Qub6dVUXb0woz_D0iVF9Ug_2BOxQ7-a';

  static Future<void> initialize() async {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
