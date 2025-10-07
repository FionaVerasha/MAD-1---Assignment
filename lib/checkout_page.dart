import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: Image.asset(item.image, width: 50, height: 50),
                        title: Text(item.name),
                        subtitle: Text(
                            "${item.quantity} × Rs. ${item.price.toStringAsFixed(2)}"),
                        trailing: Text(
                          "Rs. ${(item.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs. ${cart.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 170, 178, 182),
                    ),
                    onPressed: () {
                      // Clear the cart
                      cart.clearCart();

                      // Show confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Order placed successfully!")),
                      );

                      // Return to home page
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Confirm Order",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
