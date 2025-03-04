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

  // Helper function to get the icon based on order status
  Widget _getStatusIcon(String status) {
    switch (status) {
      case "Pending":
        return Icon(Icons.access_time, color: Colors.orange);
      case "Confirmed":
        return Icon(Icons.check_circle, color: Colors.blue);
      case "Picked Up":
        return Icon(Icons.local_shipping, color: Colors.purple);
      case "Washing":
        return Icon(Icons.local_laundry_service, color: Colors.teal);
      case "Delivered":
        return Icon(Icons.done_all, color: Colors.green);
      case "Completed":
        return Icon(Icons.verified, color: Colors.green);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Tracking",
          style: TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade800),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.green.shade50],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.green)) // Show loader while fetching data
              : userOrders.isEmpty
              ? Center(
            child: Text(
              "No orders found.",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          )
              : ListView.builder(
            itemCount: userOrders.length,
            itemBuilder: (context, index) {
              final order = userOrders[index];

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: _getStatusIcon(order["status"] ?? "Pending"), // Display status icon
                  title: Text(
                    "Order ID: ${order["id"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green.shade800,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        "Status: ${order["status"]}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Amount: ₦${order["amount"] ?? "N/A"}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    order["expectedDelivery"] ?? "N/A",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}