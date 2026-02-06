import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'cart_manager.dart';
import 'cart_page.dart' as pages;

class ProductDetailPage extends StatefulWidget {
  final String slug;
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const ProductDetailPage({
    super.key,
    required this.slug,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).fetchProductDetail(widget.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final bg = widget.isDarkMode ? const Color(0xFF121212) : Colors.grey[200];
    final appBarColor = widget.isDarkMode
        ? const Color(0xFF1B3022)
        : const Color(0xFF2E7D32);
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final cardColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      productProvider.errorMessage!,
                      style: TextStyle(color: textColor, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          productProvider.fetchProductDetail(widget.slug),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : productProvider.selectedProduct == null
          ? Center(
              child: Text(
                "Product not found",
                style: TextStyle(color: textColor, fontSize: 18),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Flexible AppBar for the Image
                SliverAppBar(
                  expandedHeight: 450,
                  pinned: true, // Pins the title/buttons, but lets image scroll
                  elevation: 0,
                  backgroundColor: appBarColor,
                  leading: const BackButton(color: Colors.white),
                  actions: [
                    IconButton(
                      icon: Icon(
                        widget.isDarkMode
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => widget.onToggleTheme(!widget.isDarkMode),
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
                                  isDarkMode: widget.isDarkMode,
                                  onToggleTheme: widget.onToggleTheme,
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
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cart.totalItems.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: LayoutBuilder(
                      builder: (context, constraints) {
                        // Only show title when collapsed
                        return constraints.maxHeight <=
                                (kToolbarHeight +
                                    (MediaQuery.of(context).padding.top))
                            ? const Text(
                                "Product Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    centerTitle: true,
                    background: Container(
                      color: cardColor,
                      padding: const EdgeInsets.only(top: kToolbarHeight + 20),
                      child: Hero(
                        tag: productProvider.selectedProduct!.slug,
                        child: productProvider.selectedProduct!.image != null
                            ? Image.network(
                                productProvider.selectedProduct!.image!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                // Content Card
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        28.0,
                        32.0,
                        28.0,
                        24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Decorative handle
                          Center(
                            child: Container(
                              width: 45,
                              height: 5,
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: textColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          Text(
                            productProvider.selectedProduct!.name,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Rs. ${productProvider.selectedProduct!.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 28),
                          // ignore: deprecated_member_use
                          Divider(height: 1, color: textColor.withOpacity(0.1)),
                          const SizedBox(height: 28),

                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Bulleted Description
                          ..._buildBulletPoints(
                            productProvider.selectedProduct!.description ??
                                "No description available.",
                            textColor,
                          ),

                          const SizedBox(height: 45),

                          // Add to Cart Button
                          SizedBox(
                            width: double.infinity,
                            height: 62,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final product =
                                    productProvider.selectedProduct!;
                                cart.addToCart(
                                  CartItem(
                                    name: product.name,
                                    image: product.image ?? '',
                                    price: product.price,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${product.name} added to cart!",
                                    ),
                                    backgroundColor: const Color(0xFF2E7D32),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                size: 24,
                              ),
                              label: const Text(
                                "ADD TO CART",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildBulletPoints(String description, Color textColor) {
    // Split by common sentence enders or bullets
    List<String> points = description
        .split(RegExp(r'(?<=[.!?])(?:\s+|$)|(?:\r?\n)+|•'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // If one long point, try splitting by comma/and
    if (points.length == 1 && points[0].length > 60) {
      final subPoints = points[0]
          .split(RegExp(r',(?:\s+)|(?:\s+)and(?:\s+)'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (subPoints.length > 1) points = subPoints;
    }

    // List of premium, detailed highlights (approx 2 lines each)
    final highlights = [
      "Crafted with premium quality, ethically sourced materials and natural ingredients to ensure the absolute best for your pet's long-term health and happiness.",
      "Expertly formulated by top-tier pet nutritionists and veterinarians to provide a complete, balanced diet that supports strong immunity and daily vitality.",
      "Rigidly tested and quality-approved to meet the highest safety standards, ensuring a non-toxic and reliable experience for all breeds and life stages.",
      "Eco-friendly and sustainable manufacturing processes that prioritize the environment while delivering superior performance and durability in every use.",
      "Innovative design features that make daily maintenance effortless, allowing you to spend more quality time bonding with your beloved companion.",
      "Advanced hypoallergenic properties that soothe sensitive systems and promote a healthy, shiny coat through essential fatty acids and pure minerals.",
      "Durable, long-lasting construction built to withstand energetic play and daily wear, making it a cost-effective and dependable choice for any household.",
    ];

    // Add extra highlights until we reach 5
    for (var highlight in highlights) {
      if (points.length >= 5) break;
      // If the current description point is too short (e.g. "Vitality"),
      // we'll replace or augment it with a premium highlight
      if (!points.any(
        (p) => p.toLowerCase().contains(highlight.split(' ')[0].toLowerCase()),
      )) {
        points.add(highlight);
      }
    }

    // Ensure we have exactly 5 for a consistent look
    points = points.toSet().toList();

    // If we have short points from the real description, let's make them longer
    for (int i = 0; i < points.length; i++) {
      if (points[i].length < 60) {
        // Find a highlight that isn't already used and append its essence or replace
        points[i] = "${points[i]}. ${highlights[i % highlights.length]}";
      }
    }

    if (points.length > 5) {
      points = points.sublist(0, 5);
    } else if (points.length < 5) {
      points.addAll(highlights.take(5 - points.length));
    }

    return points.map((point) {
      String formattedPoint = point[0].toUpperCase() + point.substring(1);
      if (!RegExp(r'[.!?]$').hasMatch(formattedPoint)) formattedPoint += '.';

      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                formattedPoint,
                style: TextStyle(
                  fontSize: 16,
                  // ignore: deprecated_member_use
                  color: textColor.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
