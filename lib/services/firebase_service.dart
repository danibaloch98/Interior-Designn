import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interior_design_project/models/firebase_modelclass.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<FurnitureItem>> fetchFurnitureItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection("furniture").get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No furniture documents found.");
        return [];
      }

      List<FurnitureItem> furnitureItems = [];

      for (var doc in querySnapshot.docs) {
        print("🔥 Found document: ${doc.id}");
        print("📌 Document data: ${doc.data()}"); // Debugging output

        Map<String, dynamic>? data = doc.data();
        if (data != null) {
          for (var entry in data.entries) {
            if (entry.value is Map<String, dynamic>) {
              print("🛠 Parsing item: ${entry.key} - ${entry.value}"); // Debugging output
              furnitureItems.add(FurnitureItem.fromMap(entry.value));
            }
          }
        }
      }

      return furnitureItems;
    } catch (e) {
      print("🔥 Error fetching furniture: $e");
      return [];
    }
  }

}
class ARFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ArModelItem>> fetchARFurnitureItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection("ArModels").get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No furniture documents found.");
        return [];
      }

      List<ArModelItem> furnitureItems = [];

      for (var doc in querySnapshot.docs) {
        print("🔥 Found document: ${doc.id}");
        print("📌 Document data: ${doc.data()}"); // Debugging output

        Map<String, dynamic>? data = doc.data();
        if (data != null) {
          for (var entry in data.entries) {
            if (entry.value is Map<String, dynamic>) {
              print("🛠 Parsing item: ${entry.key} - ${entry.value}"); // Debugging output
              furnitureItems.add(ArModelItem.fromMap(entry.value));
            }
          }
        }
      }

      return furnitureItems;
    } catch (e) {
      print("🔥 Error fetching furniture: $e");
      return [];
    }
  }

}
