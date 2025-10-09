import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_page.dart';
import 'cart_page.dart' as pages;
import 'cart_manager.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context);
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardColor =
        isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final accentColor =
        isDarkMode ? Colors.tealAccent[700]! : const Color(0xFF779FB5);
    final appBarColor = isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color.fromARGB(255, 52, 68, 122);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
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
          //Search
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: _DummySearchDelegate());
            },
          ),

          //Cart
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => pages.CartPage(
                        isDarkMode: isDarkMode,
                        onToggleTheme: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                          widget.onToggleTheme(value);
                        },
                      ),
                    ),
                  );
                },
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.totalItems.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          //Theme Toggle
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: isDarkMode
                ? "Switch to Light Mode"
                : "Switch to Dark Mode",
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
              widget.onToggleTheme(isDarkMode);
            },
          ),
        ],
      ),

      //Body Content
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Hero Section
            Stack(
              children: [
                Image.asset(
                  'assets/images/main.jpg',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  color: isDarkMode
                      // ignore: deprecated_member_use
                      ? Colors.black.withOpacity(0.6)
                      : null,
                  colorBlendMode:
                      isDarkMode ? BlendMode.darken : null,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                  isDarkMode: isDarkMode,
                                  onToggleTheme: widget.onToggleTheme,
                                ),
                              ),
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

            //Featured Categories
            buildSection(
              title: "Featured Categories",
              backgroundColor: isDarkMode
                  ? const Color(0xFF2C2C2C)
                  : const Color.fromARGB(255, 170, 175, 190),
              children: [
                categoryCard("Dogs", "assets/images/dogs.png",
                    cardColor, textColor),
                categoryCard("Cats", "assets/images/cats.png",
                    cardColor, textColor),
                categoryCard("Accessories",
                    "assets/images/accessories.png", cardColor, textColor),
                categoryCard("Grooming",
                    "assets/images/grooming.png", cardColor, textColor),
              ],
            ),

            //Best Sellers
            buildSection(
              title: "Best Sellers",
              backgroundColor: isDarkMode
                  ? const Color(0xFF252525)
                  : const Color.fromARGB(255, 153, 172, 185),
              children: [
                categoryCard("Premium Dog Collar","assets/images/collars.png", cardColor, textColor),
                categoryCard("Cat Scratching Post","assets/images/scratchingpost.png", cardColor, textColor),
                categoryCard("Luxury Pet Bed","assets/images/petbed.png", cardColor, textColor),
                categoryCard("Interactive Toy","assets/images/toys.png", cardColor, textColor),
              ],
            ),

            //New Arrivals
            buildSection(
              title: "New Arrivals",
              backgroundColor: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : const Color.fromARGB(255, 84, 102, 137),
              children: [
                categoryCard("Automatic Feeder","assets/images/new1.png", cardColor, textColor),
                categoryCard("Cat Backpack","assets/images/new2.png", cardColor, textColor),
                categoryCard("Pet Dryer","assets/images/new3.png", cardColor, textColor),
                categoryCard("Pet Water Fountain","assets/images/new4.png", cardColor, textColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Category Card Widget
  Widget categoryCard(
      String title, String imagePath, Color cardColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 200, // 🔹 Fixed height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Section Builder Widget
  Widget buildSection({
    required String title,
    required Color backgroundColor,
    required List<Widget> children,
  }) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
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
            childAspectRatio: 0.9, // Adjusted for 200px image height
            children: children,
          ),
        ],
      ),
    );
  }
}

//Simple Search Delegate
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
