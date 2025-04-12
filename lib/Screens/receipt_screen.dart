import 'package:flutter/material.dart';
import 'package:interior_design_project/models/order_history.dart';
import 'package:interior_design_project/services/order_prefs_service.dart';

class ReceiptScreen extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  final double total;
  final List<Map<String, dynamic>> items;
  final String orderId;

  const ReceiptScreen({
    required this.name,
    required this.address,
    required this.phone,
    required this.total,
    required this.items,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _saveOrderOnce();
  }

  Future<void> _saveOrderOnce() async {
    if (_isSaved) return;

    final newOrder = OrderHistory(
      orderId: widget.orderId,
      name: widget.name,
      address: widget.address,
      phone: widget.phone,
      total: widget.total,
      items: widget.items,
    );

    final currentOrders = await OrderHistoryPrefs.loadOrderHistory();

    // Optional: avoid saving duplicates by checking orderId
    if (!currentOrders.any((order) => order.orderId == widget.orderId)) {
      currentOrders.add(newOrder);
      await OrderHistoryPrefs.saveOrderHistory(currentOrders);
    }

    _isSaved = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${widget.orderId}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Name: ${widget.name}"),
            Text("Phone: ${widget.phone}"),
            Text("Address: ${widget.address}"),
            const Divider(height: 30),
            const Text("Ordered Items:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (_, index) {
                  final item = widget.items[index];
                  return ListTile(
                    title: Text(item['description'].toString()),
                    subtitle: Text("Quantity: ${item['quantity'].toString()}"),
                    trailing: Text(
                      "\$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 30),
            Text(
              "Total: \$${widget.total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
