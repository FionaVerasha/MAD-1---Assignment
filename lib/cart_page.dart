import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const CartPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    //Dark mode colors
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : Colors.grey[200];
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final accentColor =
        isDarkMode ? Colors.tealAccent[700]! : const Color(0xFF707C82);
    final appBarColor =
        isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFADBFC8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        centerTitle: true,
        actions: [
          //Theme toggle button
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip:
                isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
            onPressed: () => onToggleTheme(!isDarkMode),
          ),
        ],
      ),

      body: cartManager.items.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartManager.items.length,
                    itemBuilder: (context, index) {
                      final item = cartManager.items[index];
                      return Card(
                        color: cardColor,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Rs. ${item.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity controls  , delete
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black87),
                                    onPressed: () =>
                                        cartManager.decreaseQuantity(item),
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black87),
                                    onPressed: () =>
                                        cartManager.increaseQuantity(item),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () =>
                                        cartManager.removeItem(item),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total Section
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  color: cardColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Rs. ${cartManager.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkout button
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (cartManager.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Your cart is empty!",
                              style: TextStyle(color: textColor),
                            ),
                            backgroundColor: appBarColor,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutPage(
                              isDarkMode: isDarkMode,
                              onToggleTheme: onToggleTheme,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
