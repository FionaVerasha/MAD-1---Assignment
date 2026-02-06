import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
  }

  Future<void> _getBatteryInfo() async {
    final level = await _battery.batteryLevel;
    final state = await _battery.batteryState;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
        _batteryState = state;
      });
    }
  }

  String _getBatteryStateString(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return "Charging";
      case BatteryState.discharging:
        return "Discharging";
      case BatteryState.full:
        return "Full";
      case BatteryState.unknown:
        return "Unknown";
      default:
        return "Unknown";
    }
  }

  IconData _getBatteryIcon(BatteryState state, int level) {
    if (state == BatteryState.charging) return Icons.battery_charging_full;
    if (level <= 10) return Icons.battery_alert;
    if (level <= 30) return Icons.battery_3_bar;
    if (level <= 60) return Icons.battery_5_bar;
    return Icons.battery_full;
  }

  Color _getBatteryColor(int level) {
    if (level <= 20) return Colors.redAccent;
    if (level <= 50) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : Colors.grey[200];
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final cardColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final subTextColor = widget.isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("App Settings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: widget.isDarkMode
            ? const Color(0xFF1B3022)
            : const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Appearance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(
                  widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: const Color(0xFF4CAF50),
                ),
                title: Text("Dark Mode", style: TextStyle(color: textColor)),
                trailing: Switch(
                  value: widget.isDarkMode,
                  onChanged: (val) {
                    widget.onToggleTheme(val);
                  },
                  activeColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "System Info",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(
                      widget.isDarkMode ? 0.3 : 0.05,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.battery_std,
                            color: Color(0xFF4CAF50),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Battery Status",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20),
                        onPressed: _getBatteryInfo,
                        color: subTextColor,
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildInfoItem(
                        icon: _getBatteryIcon(_batteryState, _batteryLevel),
                        color: _getBatteryColor(_batteryLevel),
                        label: "Level",
                        value: "$_batteryLevel%",
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      _buildInfoItem(
                        icon: Icons.power,
                        color: _batteryState == BatteryState.charging
                            ? Colors.green
                            : Colors.grey,
                        label: "State",
                        value: _getBatteryStateString(_batteryState),
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: subTextColor, fontSize: 12)),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
