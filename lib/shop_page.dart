import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'providers/product_provider.dart';
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
  String _selectedCategory = 'All Products';
  final List<String> _categories = [
    'All Products',
    'Premium Products',
    'CAT Products',
    'DOG Products',
    'PET Accessories',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null &&
        _categories.contains(widget.initialCategory)) {
      _selectedCategory = widget.initialCategory!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  List<Product> _getFilteredProducts(List<Product> allProducts) {
    switch (_selectedCategory) {
      case 'Premium Products':
        return allProducts.where((p) {
          final name = p.name.toLowerCase();
          return name.contains('premium') ||
              name.contains('royal') ||
              p.price > 2500;
        }).toList();
      case 'CAT Products':
        return allProducts.where((p) {
          final name = p.name.toLowerCase();
          final cat = p.category?.toLowerCase() ?? '';
          return name.contains('cat') ||
              name.contains('kitten') ||
              name.contains('meow') ||
              cat.contains('cat');
        }).toList();
      case 'DOG Products':
        return allProducts.where((p) {
          final name = p.name.toLowerCase();
          final cat = p.category?.toLowerCase() ?? '';
          return name.contains('dog') ||
              name.contains('puppy') ||
              name.contains('pedigree') ||
              cat.contains('dog');
        }).toList();
      case 'PET Accessories':
        return allProducts.where((p) {
          final name = p.name.toLowerCase();
          final cat = p.category?.toLowerCase() ?? '';
          return name.contains('accessory') ||
              name.contains('leash') ||
              name.contains('collar') ||
              name.contains('bowl') ||
              name.contains('toy') ||
              cat.contains('accessory');
        }).toList();
      default:
        return allProducts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final isDark = widget.isDarkMode;

    final Color scaffoldBg = isDark
        ? const Color(0xFF121212)
        : const Color.fromARGB(255, 240, 242, 245);
    final Color appBarBg = isDark
        ? const Color(0xFF2C2C2C)
        : const Color.fromARGB(255, 52, 68, 122);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color buttonBg = isDark
        ? Colors.blueGrey[400]!
        : Colors.blueGrey[800]!;

    final filteredProducts = _getFilteredProducts(productProvider.products);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBg,
        centerTitle: true,
        title: const Text(
          "Whisker Shop",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => widget.onToggleTheme(!isDark),
          ),
        ],
      ),
      body: Column(
        children: [
          // Elegant Dropdown Filter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: textColor.withOpacity(0.6)),
                const SizedBox(width: 10),
                Text(
                  "Category:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white24 : Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        dropdownColor: isDark
                            ? const Color(0xFF2C2C2C)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        icon: Icon(Icons.expand_more, color: textColor),
                        items: _categories.map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product List
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
                        "No products found for this selection.",
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
                        final product = filteredProducts[index];
                        return _buildProductCard(
                          context,
                          product,
                          cardColor,
                          textColor,
                          buttonBg,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(ProductProvider provider, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage!,
              style: TextStyle(color: textColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.fetchProducts(),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    Color cardColor,
    Color textColor,
    Color buttonBg,
  ) {
    final cart = Provider.of<CartManager>(context, listen: false);

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
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
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
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rs. ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
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
                            backgroundColor: buttonBg,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBg,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 11),
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
