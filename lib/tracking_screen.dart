import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  List<Map<String, dynamic>> userOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('orders')
            .select()
            .eq('user_id', user.id); // Filter by logged-in user

        setState(() {
          userOrders = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      } catch (e) {
        print("❌ Failed to fetch orders: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Tracking")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
            : userOrders.isEmpty
            ? Center(child: Text("No orders found."))
            : ListView.builder(
          itemCount: userOrders.length,
          itemBuilder: (context, index) {
            final order = userOrders[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text("Order ID: ${order["id"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Status: ${order["status"]}"),
                trailing: Text(order["expectedDelivery"] ?? "Pending", style: TextStyle(color: Colors.green)),
              ),
            );
          },
        ),
      ),
    );
  }
}
