import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_page.dart' as pages;
import 'cart_manager.dart';
import 'providers/product_provider.dart';
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

    // Modern Professional Green Theme
    final Color primaryGreen = const Color(0xFF8BC34A); // Lime green from image
    final Color scaffoldColor = isDarkMode
        ? const Color(0xFF121212)
        : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final Color subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        title: Text(
          "WHISKER CART",
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: primaryGreen,
            ),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
              widget.onToggleTheme(isDarkMode);
            },
          ),
          _buildCartIcon(cart, primaryGreen),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Professional Hero Section
            _buildProfessionalHero(primaryGreen),

            const SizedBox(height: 40),

            // 2. About Us Section
            _buildAboutUsSection(primaryGreen, textColor, subTextColor),

            const SizedBox(height: 40),

            // 3. Services Section
            _buildServicesSection(primaryGreen, textColor, subTextColor),

            const SizedBox(height: 40),

            // 4. Trust Section
            _buildTrustSection(textColor),

            const SizedBox(height: 40),

            // 5. Professional Footer
            _buildFooter(primaryGreen, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(Color primaryGreen, Color textColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Branding column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Whisker Cart",
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Whisker Cart is your one-stop shop for premium pet essentials. From nutritious food to engaging toys, we provide everything your furry friends need to thrive.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // 2. Quick Links
              Expanded(
                flex: 2,
                child: _buildFooterColumn("QUICK LINKS", [
                  "Home",
                  "Shop",
                  "About Us",
                  "Contact",
                ]),
              ),
              // 3. Services
              Expanded(
                flex: 2,
                child: _buildFooterColumn("SERVICES", [
                  "Cat Essentials",
                  "Dog Essentials",
                  "Pet Grooming",
                  "Health & Wellness",
                ]),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Divider(color: Colors.grey.withOpacity(0.15)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "© 2026 Whisker Cart. All rights reserved.",
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Row(
                children: [
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Terms of Service",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 25),
        ...items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildTrustSection(Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF263238)
            : const Color(0xFF37474F), // Lighter blue-grey
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Why Pet Owners Trust Us",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "We are committed to excellence in every package we deliver.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ), // Brighter text
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildTrustCard(
            Icons.verified_user_outlined,
            const Color(0xFF81C784), // Lighter Green
            "Secure Payments",
            "Shop with confidence using our encrypted and highly secure payment gateways.",
          ),
          const SizedBox(height: 20),
          _buildTrustCard(
            Icons.bolt,
            const Color(0xFF64B5F6), // Lighter Blue
            "Fast Delivery",
            "Running low on food? Don't worry, we offer lightning-fast shipping across the country.",
          ),
          const SizedBox(height: 20),
          _buildTrustCard(
            Icons.auto_awesome,
            const Color(0xFFFFB74D), // Lighter Orange
            "Quality Products",
            "Every item in our inventory is hand-checked for quality, safety, and pet satisfaction.",
          ),
        ],
      ),
    );
  }

  Widget _buildTrustCard(
    IconData icon,
    Color iconColor,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.12,
        ), // Higher opacity for lighter feel
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartIcon(CartManager cart, Color primaryGreen) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_bag_outlined, color: primaryGreen),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => pages.CartPage(
                  isDarkMode: isDarkMode,
                  onToggleTheme: widget.onToggleTheme,
                ),
              ),
            );
          },
        ),
        if (cart.totalItems > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                cart.totalItems.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfessionalHero(Color primaryGreen) {
    return Stack(
      children: [
        Container(
          height: 350,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?q=80&w=800",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "PET SHOP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "MAKE YOUR PETS HAPPY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(
                width: 250,
                child: Text(
                  "Discover the best products and care services for your beloved pets. We provide everything from premium food to expert training.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "JOIN NOW",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutUsSection(
    Color primaryGreen,
    Color textColor,
    Color subTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=400",
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(height: 30, width: 4, color: primaryGreen),
                    const SizedBox(width: 10),
                    const Text(
                      "ABOUT US",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "WE KEEP YOUR PETS HAPPY ALL TIME",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Our passion for pets drives everything we do. We believe every pet deserves the highest quality products and professional care.",
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildTab(primaryGreen, "CHOOSE US", true),
                    const SizedBox(width: 15),
                    _buildTab(primaryGreen, "OUR MISSION", false),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "We provide specialized pet care and products that prioritize health and happiness above all else.",
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(Color primaryGreen, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? primaryGreen : Colors.transparent,
        border: Border.all(
          color: isActive ? primaryGreen : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildServicesSection(
    Color primaryGreen,
    Color textColor,
    Color subTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(height: 30, width: 4, color: primaryGreen),
              const SizedBox(width: 10),
              const Text(
                "SERVICES",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "OUR EXCELLENT PET CARE SERVICES",
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 30),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.2,
            children: [
              _buildServiceBox(
                primaryGreen,
                Icons.home_work_outlined,
                "PET BOARDING",
                textColor,
                subTextColor,
              ),
              _buildServiceBox(
                primaryGreen,
                Icons.restaurant_menu,
                "PET FEEDING",
                textColor,
                subTextColor,
              ),
              _buildServiceBox(
                primaryGreen,
                Icons.content_cut,
                "PET GROOMING",
                textColor,
                subTextColor,
              ),
              _buildServiceBox(
                primaryGreen,
                Icons.psychology_outlined,
                "PET TRAINING",
                textColor,
                subTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceBox(
    Color primaryGreen,
    IconData icon,
    String title,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryGreen, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Premium care for your pet.",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          const Spacer(),
          Text(
            "READ MORE ->",
            style: TextStyle(
              color: primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
