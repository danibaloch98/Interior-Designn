import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interior_design_project/models/order_history.dart';

class OrderHistoryPrefs {
  static const _key = "order_history";

  static Future<void> saveOrderHistory(List<OrderHistory> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orders.map((order) => jsonEncode(order.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<OrderHistory>> loadOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((jsonStr) {
      final map = jsonDecode(jsonStr);
      return OrderHistory.fromJson(map);
    }).toList();
  }
}
