import 'package:flutter/material.dart';
import 'dogs_page.dart' show DogsPage;
import 'cats_page.dart' show CatsPage;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 229, 235),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 52, 68, 122), // dark blue-gray
        title: const Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // Search Icon
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
          // Cart Icon
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cart feature coming soon!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
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

      // Category Content
      body: TabBarView(
        controller: _tabController,
        children: const [
          DogsPage(),
          CatsPage(),
        ],
      ),
    );
  }
}
