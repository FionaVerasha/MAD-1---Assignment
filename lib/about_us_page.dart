import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Whisker Cart!\n\nWe provide the best pet products for dogs and cats with love and care.",
            style: TextStyle(fontSize: 18, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
