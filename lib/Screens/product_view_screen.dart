import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interior_design_project/models/firebase_modelclass.dart';

class ProductViewScreen extends StatefulWidget {
  final FurnitureItem item;

  const ProductViewScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadFavoriteStatus(); // Load favorite status when screen initializes
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItems = prefs.getStringList('favorite_items') ?? [];

    setState(() {
      isFavorite = favoriteItems.any((item) {
        final decodedItem = jsonDecode(item);
        return decodedItem['id'] == widget.item.id;
      });
    });
  }

  Future<void> toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItems = prefs.getStringList('favorite_items') ?? [];

    if (isFavorite) {
      // Remove item from favorites
      favoriteItems.removeWhere((item) {
        final decodedItem = jsonDecode(item);
        return decodedItem['id'] == widget.item.id;
      });
    } else {
      // Add item to favorites
      favoriteItems.add(jsonEncode({
        'id': widget.item.id,
        'description': widget.item.description,
        'price': widget.item.price,
        'quantity': widget.item.quantity,
        'imageUrls': widget.item.imageUrls,
      }));
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    await prefs.setStringList('favorite_items', favoriteItems);
  }
  Future<void> addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart_items') ?? [];

    // Check if already in cart
    bool alreadyInCart = cartItems.any((item) {
      final decodedItem = jsonDecode(item);
      return decodedItem['id'] == widget.item.id;
    });

    if (!alreadyInCart) {
      cartItems.add(jsonEncode({
        'type':'regular',
        'id': widget.item.id,
        'description': widget.item.description,
        'price': widget.item.price,
        'quantity': 1, // default quantity 1
        'imageUrls': widget.item.imageUrls,
      }));

      await prefs.setStringList('cart_items', cartItems);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item already in cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Image Slider**
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // **Image Slider with Overlay**
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 350,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                            ),
                            items: widget.item.imageUrls.map((imageUrl) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                      // **Gradient Overlay for Better Visibility**
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    // **Back Button with Glass Effect**
                    Positioned(
                      top: 10,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // **Product Information**
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(widget.item.description,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Background color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // Soft shadow
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 24,
                            ),
                            onPressed: toggleFavorite, // Toggle favorite
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10),
                    Text("\$${widget.item.price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Expand for more details
                      },
                      child: Text("View More +",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // **Add to Cart Button**
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: addToCart,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Add To Cart", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    Text("\$${widget.item.price}",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ArProductViewScreen extends StatefulWidget {
  final ArModelItem item;

  const ArProductViewScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ArProductViewScreen> createState() => _ArProductViewScreenState();
}

class _ArProductViewScreenState extends State<ArProductViewScreen> {
  bool isFavorite = false;
  Future<void> addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart_items') ?? [];

    // Check if already in cart
    bool alreadyInCart = cartItems.any((item) {
      final decodedItem = jsonDecode(item);
      return decodedItem['id'] == widget.item.id;
    });

    if (!alreadyInCart) {
      cartItems.add(jsonEncode({
        'id': widget.item.id,
        'description': widget.item.description,
        'price': widget.item.price,
        'quantity': 1, // default quantity 1
        'imageUrls': widget.item.imageUrls,
      }));

      await prefs.setStringList('cart_items', cartItems);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item already in cart')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    loadFavoriteStatus(); // Load favorite status when screen initializes
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItems = prefs.getStringList('favorite_items') ?? [];

    setState(() {
      isFavorite = favoriteItems.any((item) {
        final decodedItem = jsonDecode(item);
        return decodedItem['id'] == widget.item.id;
      });
    });
  }

  Future<void> toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItems = prefs.getStringList('favorite_items') ?? [];

    if (isFavorite) {
      // Remove item from favorites
      favoriteItems.removeWhere((item) {
        final decodedItem = jsonDecode(item);
        return decodedItem['id'] == widget.item.id;
      });
    } else {
      // Add item to favorites
      favoriteItems.add(jsonEncode({
        'type':'ar',
        'id': widget.item.id,
        'description': widget.item.description,
        'price': widget.item.price,
        'quantity': widget.item.quantity,
        'imageUrls': widget.item.imageUrls,
        'modelUrl':widget.item.modelUrls,
      }));
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    await prefs.setStringList('favorite_items', favoriteItems);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Image Slider**
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Stack(
                                            children: [

                                          CarouselSlider(
                                          options: CarouselOptions(
                                          height: 350,
                                            enlargeCenterPage: true,
                                            enableInfiniteScroll: false,
                                          ),
                          items: widget.item.imageUrls.map((imageUrl) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    // **Gradient Overlay for Better Visibility**
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.5),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                                            ],
                      ),
                    ),

                    // **Back Button with Glass Effect**
                    Positioned(
                      top: 10,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // **Product Information**
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(widget.item.description,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Background color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // Soft shadow
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 24,
                            ),
                            onPressed: toggleFavorite, // Toggle favorite
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10),
                    Text("\$${widget.item.price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Expand for more details
                      },
                      child: Text("View More +",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // **Add to Cart Button**
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: addToCart,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Add To Cart", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    Text("\$${widget.item.price}",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
