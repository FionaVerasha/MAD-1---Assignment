import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_page.dart';
import 'cart_page.dart' as pages;
import 'cart_manager.dart';
import 'productdetail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<CartManager>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 68, 122),
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

          //Cart with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const pages.CartPage()),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Consumer<CartManager>(
                  builder: (context, cartManager, child) {
                    return cartManager.totalItems > 0
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cartManager.totalItems.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //hero section
            Stack(
              children: [
                Image.asset(
                  'assets/images/main.jpg',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Find the Best Pet Products",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Shop for your furry friend with ease",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 176, 183, 186),
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

            //Featured categories
            Container(
              color: const Color.fromARGB(255, 80, 84, 98),
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
                      categoryCard("Dogs", "assets/images/dogs.png"),
                      categoryCard("Cats", "assets/images/cats.png"),
                      categoryCard("Accessories", "assets/images/accessories.png"),
                      categoryCard("Grooming", "assets/images/grooming.png"),
                    ],
                  ),
                ],
              ),
            ),

            //Best sellers
            sectionTitle("Best Sellers"),
            productItem(context, "Premium Dog Food", "Rs.1200.00", "assets/images/bestsellars1.png"),
            productItem(context, "Clumping Cat Litter", "Rs.900.00", "assets/images/bestsellars2.png"),
            productItem(context, "Rawhide Chews Beef Bones", "Rs.500.00", "assets/images/bestsellars3.png"),
            productItem(context, "Flea & Tick Treatments", "Rs.800.00", "assets/images/bestsellars4.png"),

            //featured products
            sectionTitle("Featured Products"),
            productGrid(context, [
              featuredItem(context, "Pet Toy", "Rs.150.00", "assets/images/pet_toy.png"),
              featuredItem(context, "Pet Tools", "Rs.800.00", "assets/images/pet_tool.png"),
              featuredItem(context, "Pet Bed", "Rs.5000.00", "assets/images/pet_bed.png"),
              featuredItem(context, "Litter Box", "Rs.10000.00", "assets/images/Litterbox.png"),
            ]),
          ],
        ),
      ),
    );
  }

  //category card
  Widget categoryCard(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // section title
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  //product grid
  Widget productGrid(BuildContext context, List<Widget> items) {
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

  //product item card
  Widget productItem(BuildContext context, String title, String price, String imagePath) {
    final cart = Provider.of<CartManager>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(
              title: title,
              price: price,
              imagePath: imagePath,
              description: "High-quality product for your lovely pets.",
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.asset(imagePath, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(price, style: const TextStyle(color: Colors.green, fontSize: 13)),
            const SizedBox(height: 6),
            ElevatedButton.icon(
              onPressed: () {
                final parsedPrice = double.parse(price.replaceAll(RegExp(r'[^0-9.]'), ''));
                cart.addToCart(CartItem(name: title, image: imagePath, price: parsedPrice));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title added to cart!'),
                    duration: const Duration(milliseconds: 800),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart, size: 16),
              label: const Text("Add to Cart"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[700]),
            ),
          ],
        ),
      ),
    );
  }

  // Reuse the same item builder for featured products
  Widget featuredItem(BuildContext context, String title, String price, String imagePath) {
    return productItem(context, title, price, imagePath);
  }
}

// search delegate
class _DummySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

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
