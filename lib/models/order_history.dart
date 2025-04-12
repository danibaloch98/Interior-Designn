class OrderHistory {
  final String orderId;
  final String name;
  final String address;
  final String phone;
  final double total;
  final List<Map<String, dynamic>> items; // Changed here

  OrderHistory({
    required this.orderId,
    required this.name,
    required this.address,
    required this.phone,
    required this.total,
    required this.items,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      orderId: json['orderId'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      total: json['total'],
      items: List<Map<String, dynamic>>.from(json['items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'name': name,
      'address': address,
      'phone': phone,
      'total': total,
      'items': items,
    };
  }
}
