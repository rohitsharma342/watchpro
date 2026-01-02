import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/watch_details/watch_details_screen.dart';
import '../screens/messaging/messaging_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../data/models/watch_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String watchDetails = '/watch-details';
  static const String messaging = '/messaging';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case watchDetails:
        final watch = settings.arguments as WatchModel;
        return MaterialPageRoute(
          builder: (_) => WatchDetailsScreen(watch: watch),
        );
      case messaging:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MessagingScreen(
            sellerId: args['sellerId'] as String,
            sellerName: args['sellerName'] as String,
            watchTitle: args['watchTitle'] as String,
          ),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
