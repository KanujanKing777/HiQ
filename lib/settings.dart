import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SettingsPage extends StatefulWidget {
  String email = "";

  SettingsPage(this.email);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String userId = ""; 
  // Get the user ID from Firebase Auth
  @override
  void initState() {
    super.initState();
    userId = widget.email.toString(); // Call this in initState to load data
    _loadUserPreferences();
  }

Future<void> _loadUserPreferences() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        _isDarkMode = doc['darkMode'] ?? false;
        _notificationsEnabled = doc['notificationsEnabled'] ?? true;
        _selectedLanguage = doc['selectedLanguage'] ?? 'English';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Theme switch
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
              // Implement dark mode switching logic
            },
            secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          Divider(),
          
          // Notification switch
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: Icon(_notificationsEnabled ? Icons.notifications_active : Icons.notifications_off),
          ),
          Divider(),

          // Language selection
          ListTile(
            title: Text('Language'),
            subtitle: Text(_selectedLanguage),
            onTap: () {
              _showLanguageDialog();
            },
            leading: Icon(Icons.language),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          
          // Other settings can be added here
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('English'),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text('Spanish'),
                value: 'Spanish',
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text('French'),
                value: 'French',
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
