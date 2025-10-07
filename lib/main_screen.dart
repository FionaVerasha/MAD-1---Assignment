import 'package:assignment_2/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_manager.dart';
import 'cart_page.dart' as pages;
import 'home_page.dart';
import 'category_page.dart';
import 'about_us_page.dart';

class MainScreen extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    // Define all pages and pass theme props
    final List<Widget> pagesList = [
      HomePage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      CategoryPage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      const pages.CartPage(),
      const AboutUsPage(),
      const ProfilePage(),
    ];

    // Colors based on dark mode
    final backgroundColor =
        widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final selectedColor =
        widget.isDarkMode ? Colors.tealAccent[200] : Colors.blueGrey[900];
    final unselectedColor =
        widget.isDarkMode ? Colors.white70 : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,

      // Display current page content
      body: pagesList[_selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        backgroundColor:
            widget.isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'Categories',
          ),

          // 🛒 Cart icon with live badge
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartManager.totalItems > 0)
                  Positioned(
                    right: -6,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
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
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
