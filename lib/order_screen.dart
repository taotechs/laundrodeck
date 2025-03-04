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

  @override
  void initState() {
    super.initState();
    // Reset the state when the screen is revisited
    _resetState();
  }

  void _resetState() {
    setState(() {
      _selectedService = "Washing Only";
      _selectedItems = [];
      _pickupDate = null;
      _totalPrice = 0.0;
    });
  }

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
      appBar: AppBar(
        title: Text(
          "Place Order",
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Selection
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Laundry Service",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 10),
                        DropdownButton<String>(
                          value: _selectedService,
                          onChanged: (value) {
                            setState(() {
                              _selectedService = value!;
                            });
                          },
                          items: ["Washing Only", "Ironing Only", "Washing & Ironing"]
                              .map((service) => DropdownMenuItem(
                            value: service,
                            child: Text(
                              service,
                              style: TextStyle(color: Colors.green.shade800),
                            ),
                          ))
                              .toList(),
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.green.shade800),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Item Selection
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Items",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: itemPrices.keys.map((item) {
                            return ChoiceChip(
                              label: Text(item),
                              selected: _selectedItems.contains(item),
                              selectedColor: Colors.green,
                              labelStyle: TextStyle(
                                color: _selectedItems.contains(item) ? Colors.white : Colors.green.shade800,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  selected ? _selectedItems.add(item) : _selectedItems.remove(item);
                                  _updatePrice();
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Pickup Date Selection
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Pickup Date",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 10),
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
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green.shade50,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _pickupDate == null ? "Choose Date" : _pickupDate!.toString().split(' ')[0],
                            style: TextStyle(color: Colors.green.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Total Price
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Price",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "₦$_totalPrice",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Proceed to Payment Button
                Center(
                  child: ElevatedButton(
                    onPressed: _selectedItems.isNotEmpty && _pickupDate != null
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(totalAmount: _totalPrice),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Proceed to Payment",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}