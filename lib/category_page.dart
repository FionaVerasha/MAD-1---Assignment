import 'package:flutter/material.dart';
import 'dogs_page.dart' show DogsPage;
import 'cats_page.dart' show CatsPage;

class CategoryPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const CategoryPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final Color scaffoldBg =
        isDark ? const Color(0xFF121212) : const Color.fromARGB(255, 228, 229, 235);
    final Color appBarBg =
        isDark ? const Color(0xFF2C2C2C) : const Color.fromARGB(255, 52, 68, 122);
    const Color appBarFg = Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBg,
        foregroundColor: appBarFg,
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Search
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Search feature coming soon!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          // Cart
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cart feature coming soon!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          // 🌗 Theme toggle (same behavior as Home)
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
            onPressed: () => widget.onToggleTheme(!isDark),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Dogs"),
            Tab(text: "Cats"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          DogsPage(isDarkMode: isDark),
          CatsPage(isDarkMode: isDark),
        ],
      ),
    );
  }
}