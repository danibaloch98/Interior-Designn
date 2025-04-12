import 'package:flutter/material.dart';
import 'package:interior_design_project/Screens/product_view_screen.dart';
import 'package:interior_design_project/models/firebase_modelclass.dart';

class ProductCard extends StatelessWidget {
  final FurnitureItem item;

  const ProductCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductViewScreen(item: item),
          ),
        );
      },
      child: Container(
        width: 130,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFFAF6F3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                (item.imageUrls.isNotEmpty && item.imageUrls[0].isNotEmpty)
                    ? item.imageUrls[0]
                    : 'https://i.pinimg.com/736x/cf/ad/f4/cfadf4e92dc03920357cf1838a3de0c3.jpg',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 2),

            // Product Name (Description)
            Text(
              item.description,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4),

            // Price
            Text(
              "\$${item.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ArProductCard extends StatelessWidget {
  final ArModelItem item;

  const ArProductCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArProductViewScreen(item: item),
          ),
        );
      },
      child: Container(
        width: 130,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFFAF6F3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                (item.imageUrls.isNotEmpty && item.imageUrls[0].isNotEmpty)
                    ? item.imageUrls[0]
                    : 'https://i.pinimg.com/736x/cf/ad/f4/cfadf4e92dc03920357cf1838a3de0c3.jpg',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 2),

            // Product Name (Description)
            Text(
              item.description,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4),

            // Price
            Text(
              "\$${item.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
