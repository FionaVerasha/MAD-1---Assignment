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
        ? const Color(0xFF2C2C2C)
        : const Color.fromARGB(255, 52, 68, 122);
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final cardColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Product Details"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onToggleTheme(!widget.isDarkMode),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
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
                      color: Colors.redAccent,
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
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productProvider.errorMessage!,
                    style: TextStyle(color: textColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        productProvider.fetchProductDetail(widget.slug),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : productProvider.selectedProduct == null
          ? Center(
              child: Text(
                "Product not found",
                style: TextStyle(color: textColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(color: cardColor),
                    child: productProvider.selectedProduct!.image != null
                        ? Image.network(
                            productProvider.selectedProduct!.image!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                '--- ERROR: Failed to load image: ${productProvider.selectedProduct!.image}',
                              );
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productProvider.selectedProduct!.name,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Rs. ${productProvider.selectedProduct!.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          productProvider.selectedProduct!.description ??
                              "No description available.",
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final product = productProvider.selectedProduct!;
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
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
