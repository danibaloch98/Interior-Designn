import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:interior_design_project/models/firebase_modelclass.dart';
import 'package:interior_design_project/models/listing_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<dynamic> favoriteItems = []; // Contains both FurnitureItem and ArModelItem

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson = prefs.getStringList('favorite_items') ?? [];

    List<dynamic> loadedItems = [];

    for (String item in favoriteItemsJson) {
      final decoded = jsonDecode(item);

      if (decoded['type'] == 'ar') {
        loadedItems.add(ArModelItem.fromMap(decoded));
      } else {
        loadedItems.add(FurnitureItem.fromMap(decoded));
      }
    }

    setState(() {
      favoriteItems = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: favoriteItems.isEmpty
            ? const Center(child: Text("No favorites added yet."))
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            final item = favoriteItems[index];

            if (item is ArModelItem) {
              return ArProductCard(item: item);
            } else if (item is FurnitureItem) {
              return ProductCard(item: item);
            } else {
              return const SizedBox(); // fallback
            }
          },
        ),
      ),
    );
  }
}
