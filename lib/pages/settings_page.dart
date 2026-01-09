import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key,});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final currentUserId = _auth.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //dark mode
          Text('Dark Mode'),

          //switch toggle
          CupertinoSwitch(
            value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(currentUserId),
          ),
        ],
      ),
    );
  }
}
