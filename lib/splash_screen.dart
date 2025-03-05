import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Show splash for 3 seconds

    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      // If the user is logged in, navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // If the user is not logged in, navigate to the onboarding screen
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Set splash screen background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/laundry1.png', height: 120), // Replace with your logo
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white), // Loading indicator
          ],
        ),
      ),
    );
  }
}