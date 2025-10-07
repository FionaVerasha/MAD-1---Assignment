import 'package:assignment_2/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // Ensure the main function runs MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Use lowerCamelCase for class names, so 'MyApp' is acceptable here
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Ensure you have a HomePage widget to serve as the home screen
    );
  }
}
