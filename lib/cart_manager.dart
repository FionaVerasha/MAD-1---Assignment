import 'package:flutter/material.dart';

//Model class for Cart Items
class CartItem {
  final String name;
  final String image;
  double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

//  Cart Manager using ChangeNotifier
class CartManager extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Expose the cart items
  List<CartItem> get items => _items;

  //  Add an item to the cart (keeps correct price and prevents duplicates)
  void addToCart(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.name == item.name);

    if (existingIndex >= 0) {
      // If item already exists, increase quantity and keep latest price
      _items[existingIndex].quantity++;
      _items[existingIndex].price = item.price;
    } else {
      
      _items.add(item);
    }

    notifyListeners();
  }

  //Increase quantity
  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  // Decrease quantity or remove if 0
  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  // Remove a specific item completely
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  //Clear entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Calculate total price
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Total number of items (for badge count)
  int get totalItems {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }
}
