import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;

  EditProfileScreen({required this.currentName, required this.currentPhone});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  bool isUpdating = false; // Show loading indicator while updating

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    phoneController = TextEditingController(text: widget.currentPhone);
  }

  Future<void> updateProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        isUpdating = true; // Show loading
      });

      try {
        final response = await Supabase.instance.client.from('users').update({
          'name': nameController.text,
          'phone': phoneController.text,
        }).eq('id', user.id).select();

        print("✅ Update Response: $response"); // Debugging

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Profile Updated Successfully")),
        );

        // Refresh Profile Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } catch (e) {
        print("❌ Update Failed: $e"); // Debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Update Failed: $e")),
        );
      } finally {
        setState(() {
          isUpdating = false; // Hide loading
        });
      }
    } else {
      print("❌ No user found");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUpdating ? null : updateProfile, // Disable button when updating
              child: isUpdating
                  ? CircularProgressIndicator(color: Colors.white) // Show loader
                  : Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
