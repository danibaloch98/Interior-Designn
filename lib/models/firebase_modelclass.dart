class FurnitureItem {
  final String description;
  final int price;
  final int quantity;
  final int id;
  final List<String> imageUrls;

  FurnitureItem({
    required this.description,
    required this.price,
    required this.id,
    required this.quantity,
    required this.imageUrls,
  });

  factory FurnitureItem.fromMap(Map<String, dynamic> map) {
    List<String> urls = [];

    if (map.containsKey('imageUrls')) {
      urls = List<String>.from(map['imageUrls']);
    } else {
      for (var key in map.keys) {
        if (key.startsWith("url")) {
          urls.add(map[key]);
        }
      }
    }

    return FurnitureItem(
      description: map["description"] ?? "No Description",
      price: map["price"] ?? 0,
      id: map["id"] ?? 0,
      quantity: map["quantity"] ?? 0,
      imageUrls: urls,
    );
  }
}
class ArModelItem {
  final String description;
  final int price;
  final int quantity;
  final int id;
  final List<String> imageUrls;
  final String modelUrls;

  ArModelItem({
    required this.description,
    required this.price,
    required this.id,
    required this.quantity,
    required this.imageUrls,
    required this.modelUrls,
  });

  factory ArModelItem.fromMap(Map<String, dynamic> map) {
    List<String> urls = [];

    if (map.containsKey('imageUrls')) {
      urls = List<String>.from(map['imageUrls']);
    } else {
      for (var key in map.keys) {
        if (key.startsWith("url")) {
          urls.add(map[key]);
        }
      }
    }

    return ArModelItem(
      description: map["description"] ?? "No Description",
      price: map["price"] ?? 0,
      id: map["id"] ?? 0,
      quantity: map["quantity"] ?? 0,
      imageUrls: urls,
      modelUrls: map["modelUrl"] ?? "", // also make sure this uses 'modelUrl' (not 'modelurl')
    );
  }
}
