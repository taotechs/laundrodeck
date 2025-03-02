import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await Supabase.instance.client.from('orders').select();

      print("✅ Orders Fetched: $response"); // Debugging

      setState(() {
        orders = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("❌ Failed to fetch orders: $e"); // Debugging
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await Supabase.instance.client
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Order Updated Successfully")),
      );

      fetchOrders(); // Refresh orders after update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to Update Order: $e")),
      );
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    // Redirect to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: logout, // Call logout function when clicked
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(child: Text("No orders available."))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("Order ID: ${order["id"]}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Current Status: ${order["status"]}"),
              trailing: DropdownButton<String>(
                value: order["status"],
                items: [
                  "Pending",
                  "Confirmed",
                  "Picked Up",
                  "Washing",
                  "Delivered",
                  "Completed"
                ]
                    .map((status) => DropdownMenuItem(
                    value: status, child: Text(status)))
                    .toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    updateOrderStatus(order["id"], newStatus);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

