import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_manager.dart';
import 'auth_provider.dart';
import 'providers/product_provider.dart';
import 'login_page.dart';
import 'main_screen.dart';
import 'about_us_page.dart';
import 'services/connectivity_service.dart';
import 'providers/featured_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("🚀 App started successfully");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => FeaturedProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whisker Cart',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: _AuthGate(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      routes: {
        '/login': (_) => const LoginPage(),
        '/main': (_) =>
            MainScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        '/about': (_) =>
            AboutUsPage(isDarkMode: _isDarkMode, onToggleTheme: _toggleTheme),
      },
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAF8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D5A27),
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D5A27),
        primary: const Color(0xFF2D5A27),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F1A0F),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1B331B),
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D5A27),
        brightness: Brightness.dark,
        primary: const Color(0xFF4CAF50),
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const _AuthGate({required this.onToggleTheme, required this.isDarkMode});

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late Future<bool> _authCheckFuture;

  @override
  void initState() {
    super.initState();
    _authCheckFuture = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isAuthenticated = snapshot.data ?? false;
        return isAuthenticated
            ? MainScreen(
                onToggleTheme: widget.onToggleTheme,
                isDarkMode: widget.isDarkMode,
              )
            : const LoginPage();
      },
    );
  }
}
