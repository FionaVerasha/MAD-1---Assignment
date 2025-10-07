import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_page.dart';
import 'cart_page.dart' as pages;
import 'cart_manager.dart';

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<CartManager>(context, listen: false);

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final accentColor = isDarkMode ? Colors.tealAccent[700]! : const Color.fromARGB(255, 119, 159, 181);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color(0xFF2C2C2C)
            : const Color.fromARGB(255, 52, 68, 122),
        elevation: 3,
        title: const Text(
          "Whisker Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Search
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: _DummySearchDelegate());
            },
          ),

          // Cart (navigates to full cart page)
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const pages.CartPage()),
              );
            },
          ),

          //Dark Mode Toggle (updates app-level theme)
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
            onPressed: () => onToggleTheme(!isDarkMode),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Stack(
              children: [
                Image.asset(
                  'assets/images/main.jpg',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  color: isDarkMode ? Colors.black.withOpacity(0.6) : null,
                  colorBlendMode: isDarkMode ? BlendMode.darken : null,
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Find the Best Pet Products",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Shop for your furry friend with ease",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CategoryPage()),
                            );
                          },
                          child: const Text("Shop Now"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Featured Categories
            Container(
              color: isDarkMode
                  ? const Color(0xFF2C2C2C)
                  : const Color.fromARGB(255, 80, 84, 98),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Featured Categories",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                    children: [
                      _categoryCard("Dogs", "assets/images/dogs.png", cardColor, textColor),
                      _categoryCard("Cats", "assets/images/cats.png", cardColor, textColor),
                      _categoryCard("Accessories", "assets/images/accessories.png", cardColor, textColor),
                      _categoryCard("Grooming", "assets/images/grooming.png", cardColor, textColor),
                    ],
                  ),
                ],
              ),
            ),

            // Best Sellers
            _sectionTitle("Best Sellers", textColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
                children: [
                  _productCard(context, "Premium Dog Food", "Rs.1200.00", "assets/images/bestsellars1.png", cardColor, textColor, accentColor),
                  _productCard(context, "Clumping Cat Litter", "Rs.900.00", "assets/images/bestsellars2.png", cardColor, textColor, accentColor),
                  _productCard(context, "Rawhide Chews Beef Bones", "Rs.500.00", "assets/images/bestsellars3.png", cardColor, textColor, accentColor),
                  _productCard(context, "Flea & Tick Treatments", "Rs.800.00", "assets/images/bestsellars4.png", cardColor, textColor, accentColor),
                ],
              ),
            ),

            // Featured Products
            _sectionTitle("Featured Products", textColor),
            _productGrid(context, [
              _featuredItem(context, "Pet Toy", "Rs.150.00", "assets/images/pet_toy.png", cardColor, textColor, accentColor),
              _featuredItem(context, "Pet Tools", "Rs.800.00", "assets/images/pet_tool.png", cardColor, textColor, accentColor),
              _featuredItem(context, "Pet Bed", "Rs.5000.00", "assets/images/pet_bed.png", cardColor, textColor, accentColor),
              _featuredItem(context, "Litter Box", "Rs.10000.00", "assets/images/Litterbox.png", cardColor, textColor, accentColor),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(String title, String imagePath, Color cardColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _productGrid(BuildContext context, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: items,
      ),
    );
  }

  Widget _productCard(
    BuildContext context,
    String title,
    String price,
    String imagePath,
    Color cardColor,
    Color textColor,
    Color accentColor,
  ) {
    final cart = Provider.of<CartManager>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.asset(imagePath, height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            // keep price green in both themes for readability
            "",
            style: TextStyle(height: 0), 
          ),
          Text(
            price,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                final parsedPrice = double.parse(price.replaceAll(RegExp(r'[^0-9.]'), ''));
                cart.addToCart(CartItem(name: title, image: imagePath, price: parsedPrice));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title added to cart!'), duration: const Duration(milliseconds: 800)),
                );
              },
              icon: const Icon(Icons.add_shopping_cart, size: 12),
              label: const Text("Add to Cart"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(120, 36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuredItem(
    BuildContext context,
    String title,
    String price,
    String imagePath,
    Color cardColor,
    Color textColor,
    Color accentColor,
  ) {
    return _productCard(context, title, price, imagePath, cardColor, textColor, accentColor);
  }
}

// Search Delegate
class _DummySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) =>
      Center(child: Text("Search results for \"$query\""));

  @override
  Widget buildSuggestions(BuildContext context) =>
      const Center(child: Text("Search for products..."));
}
