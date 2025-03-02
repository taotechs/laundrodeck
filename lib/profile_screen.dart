import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String userEmail = "";
  String userPhone = "";

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            userName = response['name'] ?? "Unknown";
            userEmail = response['email'] ?? "No email found";
            userPhone = response['phone'] ?? "No phone number";
          });
        }
      } catch (e) {
        print("❌ Error fetching profile: $e");
        if (mounted) {
          setState(() {
            userName = "Error loading profile";
            userEmail = "";
            userPhone = "";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: Colors.green, child: Icon(Icons.person, size: 50, color: Colors.white)),
                  SizedBox(height: 10),
                  Text(userName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(userEmail, style: TextStyle(color: Colors.grey)),
                  Text(userPhone, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.green),
              title: Text("Edit Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      currentName: userName,
                      currentPhone: userPhone,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.green),
              title: Text("Order History"),
              onTap: () {
                // Navigate to Order History Page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
