import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'receipt_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const CheckoutScreen({Key? key, required this.cartItems, required this.total}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetaddressController = TextEditingController();
  final TextEditingController cityaddressController = TextEditingController();
  final TextEditingController counntryaddressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Pretty print the full cartItems data
    String prettyCart = const JsonEncoder.withIndent('  ').convert(widget.cartItems);
    print("🛒 Full Cart Items JSON:\n$prettyCart");
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('username') ?? '';
    streetaddressController.text = prefs.getString('address_street') ?? '';
    cityaddressController.text = prefs.getString('address_city') ?? '';
    counntryaddressController.text = prefs.getString('address_country') ?? '';
    phoneController.text = prefs.getString('phone') ?? '';
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', nameController.text);
    await prefs.setString('address_street', streetaddressController.text);
    await prefs.setString('address_city', cityaddressController.text);
    await prefs.setString('address_country', counntryaddressController.text);
    await prefs.setString('phone', phoneController.text); // ✅ Add this line
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    await _saveUserData();

    final String orderId = const Uuid().v4();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String fullAddress = "${streetaddressController.text}, ${cityaddressController.text}, ${counntryaddressController.text}";

    try {
      // Create the order in Firestore
      await firestore.collection('orders').doc(orderId).set({
        'id': orderId, // String
        'name': nameController.text, // String
        'address': fullAddress, // String
        'phone': phoneController.text, // String
        'total': widget.total.toDouble(), // Ensure it's a double
        'timestamp': Timestamp.now(), // Timestamp
        'items': widget.cartItems.map((item) => {
          'id': item['id']?.toString() ?? '', // Ensure it's a String
          'description': item['description'], // String
          'price': (item['price'] as num).toDouble(), // Ensure price is a double
          'quantity': (item['quantity'] as int).toInt(), // Ensure quantity is an int
        }).toList(),
      });

      for (var item in widget.cartItems) {
        String itemId = item['id'].toString();
        String documentName = item['id'] == 1 ? 'chairs' : 'table'; // Adjust this logic if needed
        String fieldKey = 'chair$itemId'; // So 'chair1', 'chair2', etc.

        DocumentReference docRef = firestore.collection('furniture').doc("chairs");

        await firestore.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(docRef);

          if (snapshot.exists) {
            Map<String, dynamic> docData = snapshot.data() as Map<String, dynamic>;

            if (docData.containsKey(fieldKey)) {
              Map<String, dynamic> itemMap = Map<String, dynamic>.from(docData[fieldKey]);

              int currentQty = itemMap['quantity'] ?? 0;
              int orderedQty = (item['quantity'] as num).toInt();
              int newQty = (currentQty - orderedQty).clamp(0, currentQty);

              itemMap['quantity'] = newQty;

              // Update the specific map field in the document
              transaction.update(docRef, {
                fieldKey: itemMap,
              });
            } else {
              print('❌ Map field not found: $fieldKey');
            }
          } else {
            print('❌ Document not found: $documentName');
          }
        });
      }



      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart_items');

// If it's in memory only
      widget.cartItems.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptScreen(
            name: nameController.text,
            address: fullAddress,
            phone: phoneController.text,
            total: widget.total,
            items: widget.cartItems,
            orderId: orderId,
          ),
        ),
      );
    } catch (e) {
      print('Order submission error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: streetaddressController,
                  decoration: const InputDecoration(labelText: 'Street Address'),
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: cityaddressController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: counntryaddressController,
                  decoration: const InputDecoration(labelText: 'Country'),
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),
                const Text("Items:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...widget.cartItems.map((item) => ListTile(
                  title: Text(item['description']),
                  trailing: Text("Qty: ${item['quantity']}"),
                  subtitle: Text("\$${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
                )),
                const SizedBox(height: 10),
                Text("Total: \$${widget.total.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text("Confirm & Place Order", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
