import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tracking_screen.dart'; // Navigate to tracking after payment

class PaymentScreen extends StatelessWidget {
  final double totalAmount;

  PaymentScreen({required this.totalAmount});

  Future<void> createOrder(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      try {
        final response = await Supabase.instance.client.from('orders').insert({
          'user_id': user.id, // Store the user's ID
          'amount': totalAmount,
          'status': 'Pending', // Initial status
        }).select();

        if (response.isNotEmpty) {
          String orderId = response[0]['id']; // Get the generated Order ID

          // Show confirmation popup
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Payment Confirmed"),
                content: Text("An agent will locate you shortly. Your Order ID: $orderId"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close popup
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TrackingScreen()),
                      );
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to Create Order: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ User Not Logged In")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bank Transfer Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Bank: Zenith Bank"),
            Text("Account Name: Laundrodeck Services"),
            Text("Account Number: 1234567890"),
            SizedBox(height: 20),
            Divider(),
            Text("Total Amount: ₦$totalAmount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => createOrder(context), // Call function to create order
              child: Text("I Have Sent Money"),
            ),
          ],
        ),
      ),
    );
  }
}
