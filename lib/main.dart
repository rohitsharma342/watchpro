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
    url: 'https://qgzdbsyfyjwyzcfjtmbj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnemRic3lmeWp3eXpjZmp0bWJqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNDgwMzQsImV4cCI6MjA4MjkyNDAzNH0.cqPTAGsyW_Bn1H_D4tlhtFcmf4WXp109qmbc40OESwM',
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