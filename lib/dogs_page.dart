import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';

class DogsPage extends StatelessWidget {
  const DogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Product List
    final List<Map<String, dynamic>> dogsProducts = [
      {
        "name": "BHawak Dog Food",
        "price": "Rs. 2500.00",
        "image": "assets/images/BHawak.png",
      },
      {
        "name": "American Journey Dog Food",
        "price": "Rs. 800.00",
        "image": "assets/images/american.png",
      },
      {
        "name": "Classic Pets Dog Food",
        "price": "Rs. 1200.00",
        "image": "assets/images/classicpets.png",
      },
      {
        "name": "IAMS Dog Food",
        "price": "Rs. 600.00",
        "image": "assets/images/IAMS.png",
      },
      {
        "name": "Pet Star Dog Food",
        "price": "Rs. 600.00",
        "image": "assets/images/PetStar.png",
      },
      {
        "name": "Small Breed Dog Food",
        "price": "Rs. 600.00",
        "image": "assets/images/smallbreed.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 229, 235),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              "DOGS",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 10),

            // Dog Product Cards
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: dogsProducts.length,
                itemBuilder: (context, index) {
                  final product = dogsProducts[index];
                  return _buildProductCard(context, product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Product Card Widget
  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final cart = Provider.of<CartManager>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 212, 218, 222),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              product["image"],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),

          // Product Name
          Text(
            product["name"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),

          // Product Price
          Text(
            product["price"],
            style: const TextStyle(
              color: Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          //Add to Cart Button
          ElevatedButton.icon(
            onPressed: () {
              
              final priceText = product["price"].toString();
              final match =
                  RegExp(r'([0-9]+(?:\.[0-9]+)?)').firstMatch(priceText);
              final double parsedPrice =
                  match != null ? double.tryParse(match.group(1)!) ?? 0.0 : 0.0;

              // Add product to cart
              cart.addToCart(
                CartItem(
                  name: product["name"],
                  image: product["image"],
                  price: parsedPrice,
                ),
              );

              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${product["name"]} added to cart (Rs. ${parsedPrice.toStringAsFixed(2)})"),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.blueGrey[700],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[800],
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart,
                color: Colors.white, size: 18),
            label: const Text(
              "Add to Cart",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
