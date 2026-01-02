import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'routes.dart';
import '../screens/splash/splash_screen.dart';

class WatchProApp extends StatelessWidget {
  const WatchProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WatchPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const SplashScreen(),
    );
  }
}
