import 'package:interior_design_project/models/firebase_modelclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      List<FurnitureItem> furnitureList = [];

      for (var doc in querySnapshot.docs) {
        print("🔥 Found document: ${doc.id}");

        // Extract map fields (e.g., chair1, chair2, table1)
        Map<String, dynamic>? data = doc.data();
        if (data != null) {
          for (var entry in data.entries) {
            if (entry.value is Map<String, dynamic>) {
              furnitureList.add(FurnitureItem.fromMap(entry.value));
            }
          }
        }
      }

      return furnitureList;
    } catch (e) {
      print("🔥 Error fetching furniture: $e");
      return [];
    }
  }
}
