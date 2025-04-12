import 'package:flutter/material.dart';
import 'package:interior_design_project/models/firebase_modelclass.dart';
import 'package:interior_design_project/models/listing_view_model.dart';
import 'package:interior_design_project/services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<FurnitureItem>> _furnitureFuture;
  final ARFirestoreService _arfirestoreService = ARFirestoreService();
  late Future<List<ArModelItem>> _arfurnitureFuture;

  @override
  void initState() {
    super.initState();
    _furnitureFuture = _firestoreService.fetchFurnitureItems();
    _arfurnitureFuture = _arfirestoreService.fetchARFurnitureItems();
  }
  // List<ArModelItem> filterArModels(List<ArModelItem> items) {
  //   return items
  //       .where((item) => item.title.toLowerCase().contains("armodels"))
  //       .toList();
  // }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFFAF6F3),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "explore",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Reflection of your style, taste,\nand personality",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: Icon(Icons.remove_red_eye, color: Colors.white),
                    label: Text(
                      "Discover More",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "New Collection",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 13),

            // TabBar
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 15, vertical: 0), // Adds top & bottom spacing
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade300], // Subtle gradient effect
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Soft shadow
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Color(0xFFFFFFFF), // Dark indicator for contrast
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Soft inner shadow effect
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black26,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make selected text bolder
                  tabs: [
                    Tab(text: "   Chairs   "), // Icons for better user experience
                    Tab(text: "   Tables   "),
                    Tab(text: "  AR Models   "),
                  ],
                ),
              ),
            ),

            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab (Chairs)
                  FutureBuilder<List<FurnitureItem>>(
                    future: _furnitureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error loading chairs"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No chairs found"));
                      }

                      List<FurnitureItem> chairs = snapshot.data!
                          .where((item) => item.description.toLowerCase().contains("chair"))
                          .toList();

                      return FurnitureGrid(items: chairs);
                    },
                  ),

                  // Second Tab (Tables)
                  FutureBuilder<List<FurnitureItem>>(
                    future: _furnitureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error loading tables"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No tables found"));
                      }

                      List<FurnitureItem> tables = snapshot.data!
                          .where((item) => item.description.toLowerCase().contains("table"))
                          .toList();

                      return FurnitureGrid(items: tables);
                    },
                  ),

                  // Third Tab (AR Models)
                  FutureBuilder<List<ArModelItem>>(
                    future: _arfurnitureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error loading AR models"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No AR models found"));
                      }

                      // ✅ Just use all AR models
                      List<ArModelItem> armodelItems = snapshot.data!;

                      return ArFurnitureGrid(items: armodelItems);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class FurnitureGrid extends StatelessWidget {
  final List<FurnitureItem> items;

  FurnitureGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text("No items available"));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ProductCard(item: items[index]);
        },
      ),
    );
  }
}
class ArFurnitureGrid extends StatelessWidget {
  final List<ArModelItem> items;

  ArFurnitureGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text("No items available"));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ArProductCard(item: items[index]);
        },
      ),
    );
  }
}
