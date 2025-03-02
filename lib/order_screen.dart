import 'package:flutter/material.dart';
import 'payment_screen.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _selectedService = "Washing Only";
  List<String> _selectedItems = [];
  DateTime? _pickupDate;
  double _totalPrice = 0.0;

  final Map<String, double> itemPrices = {
    "Shirt": 500,
    "Trousers": 700,
    "Duvet": 1500,
    "Shoes": 1000,
  };

  void _updatePrice() {
    double price = 0;
    for (var item in _selectedItems) {
      price += itemPrices[item] ?? 0;
    }
    setState(() {
      _totalPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Place Order")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Laundry Service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedService,
              onChanged: (value) {
                setState(() {
                  _selectedService = value!;
                });
              },
              items: ["Washing Only", "Ironing Only", "Washing & Ironing"]
                  .map((service) => DropdownMenuItem(value: service, child: Text(service)))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text("Select Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: itemPrices.keys.map((item) {
                return ChoiceChip(
                  label: Text(item),
                  selected: _selectedItems.contains(item),
                  onSelected: (selected) {
                    setState(() {
                      selected ? _selectedItems.add(item) : _selectedItems.remove(item);
                      _updatePrice();
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text("Select Pickup Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 7)),
                );
                if (selectedDate != null) {
                  setState(() {
                    _pickupDate = selectedDate;
                  });
                }
              },
              child: Text(_pickupDate == null ? "Choose Date" : _pickupDate!.toString().split(' ')[0]),
            ),
            SizedBox(height: 20),
            Text("Total Price: ₦$_totalPrice", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedItems.isNotEmpty && _pickupDate != null
                  ? () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(totalAmount: _totalPrice)));
              }
                  : null,
              child: Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
