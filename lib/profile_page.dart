import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:geolocator/geolocator.dart';
import 'settings_page.dart';
import 'auth_provider.dart';

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
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  // Location State
  double? _latitude;
  double? _longitude;
  double? _accuracy;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSavedLocation();
    _handleLostData(); // Handle Android activity being killed
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      debugPrint("Attempting to pick image from: $source");
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        debugPrint("Image picked successfully: ${pickedFile.path}");
        await _saveImagePermanently(pickedFile);
      } else {
        debugPrint("Image picking cancelled or returned null");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Camera/Gallery was closed without taking a photo"),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error in _pickImage: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _saveImagePermanently(XFile pickedFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final String permanentPath = path.join(directory.path, fileName);

      // Copy the file to a permanent location
      final File savedFile = await File(pickedFile.path).copy(permanentPath);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', savedFile.path);

      setState(() {
        _imagePath = savedFile.path;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile image updated successfully!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error saving image: $e");
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo (Camera)'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _saveImagePermanently(response.file!);
    } else {
      debugPrint("Lost data error: ${response.exception}");
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPath = prefs.getString('profile_image_path');

    // Verify file exists if path is not null
    if (savedPath != null) {
      if (!File(savedPath).existsSync()) {
        savedPath = null;
      }
    }

    setState(() {
      email = prefs.getString('user_email') ?? "";
      username = prefs.getString('user_name') ?? "User";
      _imagePath = savedPath;
    });
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(
      text: username,
    );
    final TextEditingController emailController = TextEditingController(
      text: email,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('user_name', nameController.text);
                await prefs.setString('user_email', emailController.text);
                setState(() {
                  username = nameController.text;
                  email = emailController.text;
                });
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully!"),
                      backgroundColor: Color(0xFF2E7D32),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadSavedLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _latitude = prefs.getDouble('last_lat');
      _longitude = prefs.getDouble('last_lng');
      _accuracy = prefs.getDouble('last_accuracy');
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_lat', position.latitude);
      await prefs.setDouble('last_lng', position.longitude);
      await prefs.setDouble('last_accuracy', position.accuracy);

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _accuracy = position.accuracy;
        _isLoadingLocation = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Location updated!")));
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : Colors.grey[200];
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;
    final cardColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final appBarColor = widget.isDarkMode
        ? const Color(0xFF1B3022)
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar / Header
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: appBarColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [appBarColor, appBarColor.withOpacity(0.8)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileHeader(appBarColor),
                    const SizedBox(height: 10),
                    Text(
                      username.isNotEmpty ? username : "User",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      email.isNotEmpty ? email : "Loading...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable List
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListSection("Customer Details", [
                      _buildMenuTile(
                        Icons.person_outline,
                        "Edit Profile",
                        textColor,
                        cardColor,
                        onTap: _showEditProfileDialog,
                      ),
                      _buildMenuTile(
                        Icons.payment_outlined,
                        "Payment Method",
                        textColor,
                        cardColor,
                      ),
                      _buildMenuTile(
                        Icons.language_outlined,
                        "Language",
                        textColor,
                        cardColor,
                      ),
                      _buildMenuTile(
                        Icons.history_outlined,
                        "Order History",
                        textColor,
                        cardColor,
                      ),
                      _buildMenuTile(
                        Icons.help_outline_rounded,
                        "Help Center",
                        textColor,
                        cardColor,
                      ),
                    ], textColor),
                    const SizedBox(height: 25),
                    _buildListSection("Other Options", [
                      _buildLocationTile(textColor, cardColor, subTextColor),
                      _buildMenuTile(
                        Icons.settings_outlined,
                        "App Settings",
                        textColor,
                        cardColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(
                                isDarkMode: widget.isDarkMode,
                                onToggleTheme: widget.onToggleTheme,
                              ),
                            ),
                          );
                        },
                      ),
                    ], textColor),
                    const SizedBox(height: 40),
                    _buildLogoutButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Color appBarColor) {
    return Hero(
      tag: 'profile_pic',
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: _imagePath != null
                  ? FileImage(File(_imagePath!))
                  : const AssetImage('assets/images/logo.png') as ImageProvider,
            ),
          ),
          GestureDetector(
            onTap: _showPickerOptions,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit_rounded, size: 18, color: appBarColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<Widget> items, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    Color textColor,
    Color cardColor, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4CAF50), size: 22),
        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: textColor.withOpacity(0.3),
        ),
        onTap:
            onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$title feature coming soon!")),
              );
            },
      ),
    );
  }

  Widget _buildLocationTile(
    Color textColor,
    Color cardColor,
    Color subTextColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        leading: const Icon(
          Icons.location_on_outlined,
          color: Color(0xFF4CAF50),
          size: 22,
        ),
        title: Text(
          "Location Details",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          _latitude != null
              ? Icons.check_circle_outline
              : Icons.add_circle_outline,
          color: _latitude != null ? Colors.green : Colors.grey,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                if (_latitude != null) ...[
                  _buildLocationRow(
                    "Latitude",
                    _latitude!.toStringAsFixed(6),
                    textColor,
                    subTextColor,
                  ),
                  const SizedBox(height: 5),
                  _buildLocationRow(
                    "Longitude",
                    _longitude!.toStringAsFixed(6),
                    textColor,
                    subTextColor,
                  ),
                  const SizedBox(height: 5),
                  _buildLocationRow(
                    "Accuracy",
                    "${_accuracy!.toStringAsFixed(1)}m",
                    textColor,
                    subTextColor,
                  ),
                ] else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "No location detected",
                      style: TextStyle(color: subTextColor, fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    icon: _isLoadingLocation
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.my_location, size: 18),
                    label: Text(
                      _isLoadingLocation ? "Detecting..." : "Update Location",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    String label,
    String value,
    Color textColor,
    Color subTextColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          "Sign Out",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
          foregroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
