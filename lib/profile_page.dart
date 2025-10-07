import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('user_email') ?? "";
      username = prefs.getString('user_name') ?? "User";
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.isDarkMode ? const Color(0xFF121212) : Colors.grey[200];
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor =
        widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final appBarColor = widget.isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color.fromARGB(255, 93, 107, 152);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: appBarColor,
        centerTitle: true,
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            tooltip: widget.isDarkMode
                ? "Switch to Light Mode"
                : "Switch to Dark Mode",
            onPressed: () => widget.onToggleTheme(!widget.isDarkMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(height: 20),

            // Display registered username
            Text(
              username.isNotEmpty ? username : "User",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),

            // Display registered email
            Text(
              email.isNotEmpty ? email : "Loading email...",
              style: TextStyle(
                fontSize: 16,
                color: subTextColor,
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Edit profile coming soon!")),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isDarkMode
                    ? Colors.blueGrey[700]
                    : const Color.fromARGB(255, 160, 164, 179),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
