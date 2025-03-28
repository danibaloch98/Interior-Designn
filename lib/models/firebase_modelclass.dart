class FurnitureItem {
  final String description;
  final int price;
  final int quantity;
  final List<String> imageUrls;

  FurnitureItem({
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrls,
  });

  factory FurnitureItem.fromMap(Map<String, dynamic> map) {
    List<String> urls = [];
    for (var key in map.keys) {
      if (key.startsWith("url")) {  // Extract all URL fields
        urls.add(map[key]);
      }
    }

    return FurnitureItem(
      description: map["description"] ?? "No Description",
      price: map["price"] ?? 0,
      quantity: map["quantity"] ?? 0,
      imageUrls: urls,
    );
  }
}
