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
      final response = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single()
          .catchError((_) => null);

      bool isAdmin = response != null && response['role'] == 'admin';

      // Navigate using named routes
      Navigator.pushReplacementNamed(context, isAdmin ? '/admin' : '/home');
    } else {
      // Navigate to onboarding if user is not logged in
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
            Image.asset('assets/laundry2.png', height: 120), // Replace with your logo
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white), // Loading indicator
          ],
        ),
      ),
    );
  }
}
