import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'cart_page.dart' as pages;
import 'home_page.dart';
import 'category_page.dart';
import 'about_us_page.dart';
import 'profile_page.dart';

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

    final backgroundColor =
        widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    final selectedColor =
        widget.isDarkMode ? Colors.white : Colors.blueGrey[900];
    final unselectedColor =
        widget.isDarkMode ? Colors.grey[400] : Colors.grey[600];

    // Pages list (with dark mode + toggle passed)
    final List<Widget> pagesList = [
      HomePage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      CategoryPage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      pages.CartPage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      AboutUsPage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: pagesList[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor:
            widget.isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartManager.totalItems > 0)
                  Positioned(
                    right: 0,
                    top: 0,
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
                          fontWeight: FontWeight.bold,
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
