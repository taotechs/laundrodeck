import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUp() async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = response.user;
      if (user != null) {
        print("✅ User Created: ${user.id}");

        // Insert user details into Supabase Database
        await Supabase.instance.client.from('users').insert({
          'id': user.id, // ID from Supabase Auth
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
        });

        print("✅ User Inserted Successfully");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (e) {
      print("❌ Sign Up Failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign Up Failed: $e")));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Account", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 20),
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
              TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
