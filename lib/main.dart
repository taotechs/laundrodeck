import 'package:flutter/material.dart';
import 'package:laundrodeck/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'admin_dashboard.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Secrets.supabaseUrl,
    anonKey: Secrets.supabaseAnonKey,
  );

  runApp(LaundrodeckApp());
}

class LaundrodeckApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: laundrodeckTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Start with SplashScreen
      routes: {
        '/': (context) => SplashScreen(), // ✅ Splash Screen as first route
        '/home': (context) => HomeScreen(),
        '/admin': (context) => AdminDashboard(),
        '/login': (context) => LoginScreen(),
        '/onboarding': (context) => OnboardingScreen(),
      },
    );
  }
}
