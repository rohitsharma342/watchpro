import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://qgzdbsyfyjwyzcfjtmbj.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnemRic3lmeWp3eXpjZmp0bWJqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNDgwMzQsImV4cCI6MjA4MjkyNDAzNH0.cqPTAGsyW_Bn1H_D4tlhtFcmf4WXp109qmbc40OESwM';
  
  static SupabaseClient get client => Supabase.instance.client;
}