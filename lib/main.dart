import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_manager.dart';
import 'login_page.dart';
import 'main_screen.dart';
import 'about_us_page.dart';
// import 'contact_us_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whisker Cart',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blueGrey,
      ),
      home: const _AuthGate(),
      routes: {
        '/login': (_) => LoginPage(), 
        '/main': (_) => const MainScreen(),
        '/about': (_) => const AboutUsPage(),
       
      },
    );
  }
}

/// Checks SharedPreferences to decide which page to show first.
class _AuthGate extends StatefulWidget {
  const _AuthGate({super.key});

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late final Future<bool> _isLoggedInFuture;

  @override
  void initState() {
    super.initState();
    _isLoggedInFuture = _checkLogin();
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedInFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isLoggedIn = snapshot.data!;
        // Delay navigation until after first frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed(
            isLoggedIn ? '/main' : '/login',
          );
        });

        return const SizedBox.shrink();
      },
    );
  }
}
