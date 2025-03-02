import 'package:flutter/material.dart';
import 'package:laundrodeck/admin_dashboard.dart';
import 'order_screen.dart';
import 'tracking_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    LaundryListScreen(),
    OrderScreen(),
    TrackingScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laundrodeck"), // Kept as requested
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_laundry_service), label: "Laundries"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: "Tracking"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class LaundryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center( // Centering the card
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListTile(
            title: Text(
              "Laundrodeck Services",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              "Calabar, Nigeria",
              textAlign: TextAlign.center,
            ),
            trailing: Icon(Icons.arrow_forward, color: Colors.green),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen()));
            },
          ),
        ),
      ),
    );
  }
}
