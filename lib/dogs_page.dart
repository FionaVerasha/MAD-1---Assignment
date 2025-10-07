import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';

class DogsPage extends StatelessWidget {
  final bool isDarkMode;
  const DogsPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dogsProducts = [
      {"name": "BHawak Dog Food", "price": "Rs. 2500.00", "image": "assets/images/BHawak.png"},
      {"name": "American Journey Dog Food", "price": "Rs. 800.00", "image": "assets/images/american.png"},
      {"name": "Classic Pets Dog Food", "price": "Rs. 1200.00", "image": "assets/images/classicpets.png"},
      {"name": "IAMS Dog Food", "price": "Rs. 600.00", "image": "assets/images/IAMS.png"},
      {"name": "Pet Star Dog Food", "price": "Rs. 600.00", "image": "assets/images/PetStar.png"},
      {"name": "Small Breed Dog Food", "price": "Rs. 600.00", "image": "assets/images/smallbreed.png"},
    ];

    final bg = isDarkMode ? const Color(0xFF121212) : const Color.fromARGB(255, 228, 229, 235);
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : const Color.fromARGB(255, 212, 218, 222);
    final buttonBg = isDarkMode ? Colors.blueGrey[400]! : Colors.blueGrey[800]!;

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              "DOGS",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),

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
                  return _buildProductCard(context, product, cardColor, titleColor, buttonBg);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Map<String, dynamic> product,
    Color cardColor,
    Color titleColor,
    Color buttonBg,
  ) {
    final cart = Provider.of<CartManager>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.asset(
              product["image"],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            product["name"],
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
          ),

          Text(
            product["price"],
            style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: () {
              final priceText = product["price"].toString();
              final match = RegExp(r'([0-9]+(?:\.[0-9]+)?)').firstMatch(priceText);
              final double parsedPrice = match != null ? double.tryParse(match.group(1)!) ?? 0.0 : 0.0;

              cart.addToCart(CartItem(name: product["name"], image: product["image"], price: parsedPrice));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product["name"]} added to cart (Rs. ${parsedPrice.toStringAsFixed(2)})"),
                  duration: const Duration(seconds: 2),
                  backgroundColor: buttonBg,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBg,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
            label: const Text("Add to Cart", style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
