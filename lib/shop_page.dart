import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'providers/product_provider.dart';
import 'cart_page.dart';
import 'productdetail_page.dart';
import 'models/product.dart';

class ShopPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;
  final String? initialCategory;

  const ShopPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    this.initialCategory,
  });

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _selectedCategory = 'Everything';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'Everything',
    'Premium Products',
    'CAT Products',
    'DOG Products',
    'PET Accessories',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      // Find the best match for the initial category
      final matchingCategory = _categories.firstWhere(
        (cat) => cat.toLowerCase() == widget.initialCategory!.toLowerCase(),
        orElse: () => 'Everything',
      );
      _selectedCategory = matchingCategory;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  List<Product> _getFilteredProducts(List<Product> allProducts) {
    List<Product> filtered = allProducts;

    // Filter by category
    if (_selectedCategory != 'Everything') {
      switch (_selectedCategory) {
        case 'Premium Products':
          final premiumNames = [
            'premium kitty',
            'classic cat cuisine',
            'premium dog food',
            'premium puppy',
            'elite wellness',
            'gourmet feast',
          ];
          filtered = filtered.where((p) {
            final name = p.name.toLowerCase();
            return premiumNames.any((pn) => name.contains(pn));
          }).toList();
          break;
        case 'CAT Products':
          filtered = filtered.where((p) {
            final name = p.name.toLowerCase();
            final cat = p.category?.toLowerCase() ?? '';
            return name.contains('cat') ||
                name.contains('kitten') ||
                name.contains('meow') ||
                name.contains('whisker') ||
                name.contains('felix') ||
                cat.contains('cat');
          }).toList();
          break;
        case 'DOG Products':
          filtered = filtered.where((p) {
            final name = p.name.toLowerCase();
            final cat = p.category?.toLowerCase() ?? '';
            return name.contains('dog') ||
                name.contains('puppy') ||
                name.contains('pedigree') ||
                name.contains('purina') ||
                name.contains('drools') ||
                name.contains('royal canin') ||
                name.contains('iams') ||
                cat.contains('dog');
          }).toList();
          break;
        case 'PET Accessories':
          filtered = filtered.where((p) {
            final name = p.name.toLowerCase();
            final cat = p.category?.toLowerCase() ?? '';
            return name.contains('accessory') ||
                name.contains('leash') ||
                name.contains('collar') ||
                name.contains('bowl') ||
                name.contains('toy') ||
                name.contains('bed') ||
                name.contains('kit') ||
                name.contains('first aid') ||
                name.contains('care') ||
                name.contains('grooming') ||
                cat.contains('accessory');
          }).toList();
          break;
      }
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartManager = Provider.of<CartManager>(context);
    final isDark = widget.isDarkMode;

    final Color primaryGreen = isDark
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2D5A27);
    final Color backgroundColor = isDark
        ? const Color(0xFF0F1A0F)
        : const Color(0xFFF9FBF9);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color cardColor = isDark ? const Color(0xFF1B2B1B) : Colors.white;

    final filteredProducts = _getFilteredProducts(productProvider.products);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Search and Cart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF253525) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          Icon(Icons.search, color: textColor.withOpacity(0.5)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  // ignore: deprecated_member_use
                                  color: textColor.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          Container(
                            height: 20,
                            width: 1,
                            // ignore: deprecated_member_use
                            color: textColor.withOpacity(0.1),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          // ignore: deprecated_member_use
                          Icon(Icons.tune, color: textColor.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF253525)
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: textColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartPage(
                                  isDarkMode: widget.isDarkMode,
                                  onToggleTheme: widget.onToggleTheme,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (cartManager.totalItems > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cartManager.totalItems}',
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
                  ),
                ],
              ),
            ),

            // Horizontal Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  ..._categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryGreen
                                : (isDark
                                      ? const Color(0xFF253525)
                                      : Colors.white),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark
                                        ? Colors.white10
                                        : Colors.grey[200]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : textColor,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              if (cat != 'Everything') ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: isSelected
                                      ? Colors.white
                                      // ignore: deprecated_member_use
                                      : textColor.withOpacity(0.5),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 4),
                ],
              ),
            ),

            // Products Grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Provider.of<ProductProvider>(
                  context,
                  listen: false,
                ).fetchProducts(),
                child: productProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productProvider.errorMessage != null
                    ? _buildErrorView(productProvider, textColor)
                    : filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          "No products found.",
                          style: TextStyle(color: textColor),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(
                            context,
                            filteredProducts[index],
                            cardColor,
                            textColor,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(ProductProvider provider, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(provider.errorMessage!, style: TextStyle(color: textColor)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.fetchProducts(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    Color cardColor,
    Color textColor,
  ) {
    final cart = Provider.of<CartManager>(context, listen: false);
    final isDark = widget.isDarkMode;
    final primaryGreen = isDark
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2D5A27);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              slug: product.slug,
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF253525)
                          : const Color(0xFFF0F4F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Hero(
                        tag: product.slug,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: product.image != null
                              ? Image.network(
                                  product.image!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (ctx, _, __) =>
                                      const Icon(Icons.broken_image, size: 40),
                                )
                              : const Icon(Icons.image, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(
                      Icons.favorite_border,
                      // ignore: deprecated_member_use
                      color: textColor.withOpacity(0.3),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // ignore: deprecated_member_use
                            color: textColor.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rs. ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      cart.addToCart(
                        CartItem(
                          name: product.name,
                          image: product.image ?? '',
                          price: product.price,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${product.name} added to cart!"),
                          duration: const Duration(seconds: 2),
                          backgroundColor: primaryGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.grey[200]!,
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 20,
                        // ignore: deprecated_member_use
                        color: textColor.withOpacity(0.8),
                      ),
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
}
