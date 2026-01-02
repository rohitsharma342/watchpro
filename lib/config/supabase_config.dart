import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://phuwqwslxgggxsulayes.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBodXdxd3NseGdnZ3hzdWxheWVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNDc1MTksImV4cCI6MjA4MjkyMzUxOX0.dkx-2SxfOP-KA-KauL7ijK3t7jQ9TtbQ4CvTIYV9XBs';
  
  static SupabaseClient get client => Supabase.instance.client;
}