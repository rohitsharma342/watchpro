import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'providers/watch_provider.dart';
import 'providers/user_provider.dart';
import 'providers/message_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://phuwqwslxgggxsulayes.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBodXdxd3NseGdnZ3hzdWxheWVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNDc1MTksImV4cCI6MjA4MjkyMzUxOX0.dkx-2SxfOP-KA-KauL7ijK3t7jQ9TtbQ4CvTIYV9XBs',
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WatchProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: const WatchProApp(),
    ),
  );
}