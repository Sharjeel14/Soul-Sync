import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static String get url =>
      dotenv.get('SUPABASE_URL', fallback: 'https://placeholder.supabase.co');

  static String get anonKey {
    final jwt = dotenv.maybeGet('SUPABASE_ANON_KEY');
    if (jwt != null && jwt.isNotEmpty) return jwt;
    return dotenv.get('SUPABASE_PUBLISHABLE_KEY', fallback: 'placeholder-anon-key');
  }

  static SupabaseClient get client => Supabase.instance.client;
}
