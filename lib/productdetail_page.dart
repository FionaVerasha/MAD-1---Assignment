import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';

class ProductDetailsPage extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;
  final String description;

  const ProductDetailsPage({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Add to Cart button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text(
                "Add to Cart",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                cart.addToCart(
                  CartItem(
                    name: title,
                    image: imagePath,
                    price: double.parse(price.replaceAll(RegExp(r'[^0-9.]'), '')),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Product added to cart!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
