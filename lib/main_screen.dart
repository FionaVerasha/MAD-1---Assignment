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

  List<Widget> get _pages => [
        HomePage(
          isDarkMode: widget.isDarkMode,
          onToggleTheme: widget.onToggleTheme,
        ),
        const CategoryPage(),
        const pages.CartPage(),
        const AboutUsPage(),
        const ProfilePage(),
      ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    // colors for the bottom nav depending on theme
    final bool isDark = widget.isDarkMode;
    final Color navBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final Color selected = isDark ? Colors.white : (Colors.blueGrey[900]!);
    final Color unselected = isDark ? Colors.white70 : (Colors.grey[600]!);

    return Scaffold(
      // No AppBar here (avoid duplicate top bars)
      body: _pages[_selectedIndex],

      bottomNavigationBar: Theme(
        // ensure the nav uses the correct icon/text colors
        data: Theme.of(context).copyWith(
          canvasColor: navBg,
          iconTheme: IconThemeData(color: unselected),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: unselected,
                displayColor: unselected,
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: navBg,
          selectedItemColor: selected,
          unselectedItemColor: unselected,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.pets_outlined),
              label: 'Categories',
            ),

            // 🛒 Cart right after Categories, with live badge
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
      ),
    );
  }
}
