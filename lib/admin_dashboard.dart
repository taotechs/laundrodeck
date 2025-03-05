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
      // Fetch orders and join with the users table to get user details
      final response = await Supabase.instance.client
          .from('orders')
          .select('''
            id, created_at, status, amount, user_id,
            users:user_id (name, phone, email)
          ''');

      print("✅ Orders Fetched: $response"); // Debugging

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          orders = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Failed to fetch orders: $e"); // Debugging
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await Supabase.instance.client
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Order Updated Successfully")),
        );
      }

      fetchOrders(); // Refresh orders after update
    } catch (e) {
      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to Update Order: $e")),
        );
      }
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
          final user = order['users'] ?? {};
          final createdAt = DateTime.parse(order['created_at']).toLocal();

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: InkWell(
              onTap: () {
                // Handle card click (e.g., show order details)
                _showOrderDetails(context, order);
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID: ${order["id"]}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButton<String>(
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
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          updateOrderStatus(order["id"], newStatus);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    final user = order['users'] ?? {};
    final createdAt = DateTime.parse(order['created_at']).toLocal();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: ${order["id"]}"),
                Text("Name: ${user['name'] ?? 'N/A'}"),
                Text("Phone: ${user['phone'] ?? 'N/A'}"),
                Text("Email: ${user['email'] ?? 'N/A'}"),
                Text("Amount: ₦${order["amount"] ?? 'N/A'}"),
                Text("Time: ${createdAt.toString().split('.')[0]}"),
                Text("Status: ${order["status"]}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}