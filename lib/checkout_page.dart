import 'package:flutter/material.dart';
import 'cart_manager.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const CheckoutPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : Colors.grey[200];
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final appBarColor =
        isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFADBFC8);
    final accentColor =
        isDarkMode ? Colors.tealAccent[700]! : const Color(0xFF707C82);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => onToggleTheme(!isDarkMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // Order items
            Expanded(
              child: ListView.builder(
                itemCount: cartManager.items.length,
                itemBuilder: (context, index) {
                  final item = cartManager.items[index];
                  return Card(
                    color: cardColor,
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                    child: ListTile(
                      leading: Image.asset(item.image, width: 50, height: 50),
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        "Qty: ${item.quantity}",
                        // ignore: deprecated_member_use
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                      trailing: Text(
                        "Rs. ${(item.price * item.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Total
            Row(
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
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Checkout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Order Placed Successfully!",
                      style: TextStyle(color: textColor),
                    ),
                    backgroundColor: appBarColor,
                  ),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  cartManager.clearCart();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                });
              },
              child: Text(
                "Place Order",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
