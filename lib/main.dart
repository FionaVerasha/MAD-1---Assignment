// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'main_screen.dart';

void main() {
  bool isLoggedIn = false; // ✅ Initialize properly

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartManager(),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; // ✅ Store it as a field

  const MyApp({super.key, required this.isLoggedIn}); // ✅ Fixed constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
