import 'package:flutter/material.dart';
import 'package:interior_design_project/Screens/receipt_screen.dart';
import 'package:interior_design_project/models/order_history.dart';
import 'package:interior_design_project/services/order_prefs_service.dart';


class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderHistory> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final loadedOrders = await OrderHistoryPrefs.loadOrderHistory();
    setState(() {
      orders = loadedOrders.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: ListTile(
              title: Text("Order ID: ${order.orderId}"),
              subtitle: Text("${order.name} - \$${order.total.toStringAsFixed(2)}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReceiptScreen(
                      name: order.name,
                      address: order.address,
                      phone: order.phone,
                      total: order.total,
                      items: order.items,
                      orderId: order.orderId,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}