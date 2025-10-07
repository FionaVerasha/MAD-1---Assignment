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
    // Ensure provider is available
    Provider.of<CartManager>(context, listen: false);

    final isWide = MediaQuery.of(context).size.width > 600;

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
          // Search (same as HomePage)
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: _AboutSearchDelegate());
            },
          ),

          // Cart with badge (same as HomePage)
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4B5563), Color(0xFF94A3B8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildTextSection(context)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildImageSection()),
                  ],
                )
              : Column(
                  children: [
                    _buildTextSection(context),
                    const SizedBox(height: 20),
                    _buildImageSection(),
                  ],
                ),
        ),
      ),
    );
  }

  // Text Section
  Widget _buildTextSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ABOUT US",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "At Whisker Cart, we know pets are more than just animals — they’re part of the family. "
          "That’s why we’ve created an easy-to-use online store where pet parents can find everything "
          "they need in one place. From nutritious food and fun toys to grooming essentials and everyday "
          "accessories, our goal is to make caring for your furry friends simple, affordable, and enjoyable.",
          style: TextStyle(
            color: Color(0xFFe5e7eb),
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "With fast delivery, secure checkout, and a wide range of trusted products, we’re here to keep tails wagging "
          "and whiskers twitching with happiness. What makes us different is our focus on convenience and care. "
          "Quick product searches, clear categories, and personalized recommendations help you find exactly what your pet needs. "
          "Plus, with bundle deals, loyalty rewards, and seasonal promotions, you always get great value without compromising quality.",
          style: TextStyle(
            color: Color(0xFFe5e7eb),
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Whether you’re a first-time pet parent or a long-time companion, "
          "Whisker Cart is here to support you every step of the way.",
          style: TextStyle(
            color: Color(0xFFe5e7eb),
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
          ),
          onPressed: () {
            // Navigate to your Contact Us page (set up this route in MaterialApp)
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
