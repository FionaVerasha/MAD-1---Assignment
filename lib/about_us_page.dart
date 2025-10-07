import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'cart_page.dart' as pages;

class AboutUsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const AboutUsPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Access cart provider
    Provider.of<CartManager>(context, listen: false);

    final isWide = MediaQuery.of(context).size.width > 600;

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[300]! : const Color(0xFF374151);
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
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Theme Toggle Button
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            tooltip: isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
            onPressed: () => onToggleTheme(!isDarkMode),
          ),

          // Search Button
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: _AboutSearchDelegate());
            },
          ),

          // Cart with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => pages.CartPage(
                        isDarkMode: isDarkMode,
                        onToggleTheme: onToggleTheme,
                      ),
                    ),
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
                                fontWeight: FontWeight.bold,
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

      // Body with Dark/Light theme support
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [const Color(0xFF1F2937), const Color(0xFF374151)]
                  : [const Color(0xFF4B5563), const Color(0xFF94A3B8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildTextSection(context, textColor, subTextColor)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildImageSection()),
                  ],
                )
              : Column(
                  children: [
                    _buildTextSection(context, textColor, subTextColor),
                    const SizedBox(height: 20),
                    _buildImageSection(),
                  ],
                ),
        ),
      ),
    );
  }

  // Text Section
  Widget _buildTextSection(BuildContext context, Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ABOUT US",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "At Whisker Cart, we know pets are more than just animals — they’re part of the family. "
          "That’s why we’ve created an easy-to-use online store where pet parents can find everything "
          "they need in one place. From nutritious food and fun toys to grooming essentials and everyday "
          "accessories, our goal is to make caring for your furry friends simple, affordable, and enjoyable.",
          style: TextStyle(
            color: subTextColor,
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "With fast delivery, secure checkout, and a wide range of trusted products, we’re here to keep tails wagging "
          "and whiskers twitching with happiness. What makes us different is our focus on convenience and care. "
          "Quick product searches, clear categories, and personalized recommendations help you find exactly what your pet needs. "
          "Plus, with bundle deals, loyalty rewards, and seasonal promotions, you always get great value without compromising quality.",
          style: TextStyle(
            color: subTextColor,
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Whether you’re a first-time pet parent or a long-time companion, "
          "Whisker Cart is here to support you every step of the way.",
          style: TextStyle(
            color: subTextColor,
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.blueGrey[700] : Colors.blue[700],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/contact_us');
          },
          child: const Text(
            "Contact Us",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Image Section
  Widget _buildImageSection() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/bg.png',
          height: 260,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// Simple SearchDelegate (same behavior as in HomePage)
class _AboutSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) =>
      Center(child: Text('Search results for "$query"'));

  @override
  Widget buildSuggestions(BuildContext context) =>
      const Center(child: Text("Search for products..."));
}
