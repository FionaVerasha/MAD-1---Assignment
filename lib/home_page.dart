import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shop_page.dart';
import 'cart_page.dart' as pages;
import 'cart_manager.dart';
import 'providers/product_provider.dart';
import 'productdetail_page.dart';
import 'models/product.dart';
import 'models/featured_item.dart';
import 'services/connectivity_service.dart';
import 'providers/featured_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      final isOnline = Provider.of<ConnectivityService>(
        context,
        listen: false,
      ).isOnline;
      Provider.of<FeaturedProvider>(
        context,
        listen: false,
      ).fetchFeaturedItems(isOnline);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final accentColor = isDarkMode
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2E7D32);
    final appBarColor = isDarkMode
        ? const Color(0xFF1B3022)
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 3,
        title: const Text(
          "Whisker Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: _DummySearchDelegate());
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
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
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.totalItems.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
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
      body: Column(
        children: [
          // Offline Banner
          Consumer<ConnectivityService>(
            builder: (context, connectivity, child) {
              if (connectivity.isOffline) {
                return Container(
                  width: double.infinity,
                  color: Colors.orange[800],
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        "Offline Mode – Showing cached/local data",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
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
                            ? Colors.black.withOpacity(0.6)
                            : null,
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
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(blurRadius: 10, color: Colors.black),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Shop for your furry friend with ease",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.white,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(blurRadius: 5, color: Colors.black),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShopPage(
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
                      categoryCard(
                        "Dogs",
                        "assets/images/dogs.png",
                        cardColor,
                        textColor,
                        'DOG Products',
                      ),
                      categoryCard(
                        "Cats",
                        "assets/images/cats.png",
                        cardColor,
                        textColor,
                        'CAT Products',
                      ),
                      categoryCard(
                        "Accessories",
                        "assets/images/accessories.png",
                        cardColor,
                        textColor,
                        'PET Accessories',
                      ),
                      categoryCard(
                        "Premium",
                        "assets/images/grooming.png",
                        cardColor,
                        textColor,
                        'Premium Products',
                      ),
                    ],
                  ),

                  // Product API Sections
                  if (productProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (productProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              productProvider.errorMessage!,
                              style: TextStyle(color: textColor),
                            ),
                            ElevatedButton(
                              onPressed: () => productProvider.fetchProducts(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    //Best Sellers
                    buildSection(
                      title: "Best Sellers",
                      backgroundColor: isDarkMode
                          ? const Color(0xFF252525)
                          : const Color.fromARGB(255, 153, 172, 185),
                      children: productProvider.products
                          .take(4)
                          .map((p) => productCard(p, cardColor, textColor))
                          .toList(),
                    ),

                    //New Arrivals
                    buildSection(
                      title: "New Arrivals",
                      backgroundColor: isDarkMode
                          ? const Color(0xFF1E1E1E)
                          : const Color.fromARGB(255, 84, 102, 137),
                      children: productProvider.products
                          .skip(4)
                          .take(4)
                          .map((p) => productCard(p, cardColor, textColor))
                          .toList(),
                    ),

                    // Featured Products Section (Online/Offline Handling)
                    Consumer2<FeaturedProvider, ConnectivityService>(
                      builder: (context, featuredProp, connectivity, child) {
                        if (featuredProp.featuredItems.isEmpty &&
                            !featuredProp.isLoading) {
                          return const SizedBox.shrink();
                        }
                        return buildSection(
                          title: connectivity.isOnline
                              ? "Featured Products"
                              : "Recommended for You",
                          backgroundColor: isDarkMode
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFFFDEFD9),
                          children: featuredProp.isLoading
                              ? [
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ]
                              : featuredProp.featuredItems
                                    .take(4)
                                    .map(
                                      (item) => featuredCard(
                                        item,
                                        cardColor,
                                        textColor,
                                      ),
                                    )
                                    .toList(),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Product Card Widget for API data
  Widget productCard(Product product, Color cardColor, Color textColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              slug: product.slug,
              isDarkMode: isDarkMode,
              onToggleTheme: widget.onToggleTheme,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: product.image != null
                    ? Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print(
                            '--- ERROR: Failed to load image: ${product.image}',
                          );
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 40, color: Colors.grey),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Column(
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "Rs. ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Category Card Widget
  Widget categoryCard(
    String title,
    String imagePath,
    Color cardColor,
    Color textColor,
    String categoryName,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopPage(
              isDarkMode: isDarkMode,
              onToggleTheme: widget.onToggleTheme,
              initialCategory: categoryName,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
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
                height: 150,
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
      ),
    );
  }

  // Featured Card Widget
  Widget featuredCard(FeaturedItem item, Color cardColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                item.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.pets, size: 40, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "Rs. ${item.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
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
    if (children.isEmpty) return const SizedBox.shrink();
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
            childAspectRatio: 0.85,
            children: children,
          ),
        ],
      ),
    );
  }
}

class _DummySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) =>
      Center(child: Text("Search results for \"$query\""));

  @override
  Widget buildSuggestions(BuildContext context) =>
      const Center(child: Text("Search for products..."));
}
