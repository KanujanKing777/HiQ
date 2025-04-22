import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


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
  String grade = "";
  // Get the user ID from Firebase Auth
  @override
  void initState() {
    super.initState();
    userId = widget.email.toString(); // Call this in initState to load data
    _loadUserPreferences("load");
  }

Future<void> _loadUserPreferences(String matter) async {
  DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if(matter=="load"){
    if (doc.exists) {
      setState(() {
        _isDarkMode = doc['darkMode'] ?? false;
        _notificationsEnabled = doc['notificationsEnabled'] ?? true;
        _selectedLanguage = doc['selectedLanguage'] ?? 'English';
        grade = doc['grade'] ?? "";
      });
    }
  }else if(matter=="darkmode"){
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'darkMode':_isDarkMode
    });
  }else if(matter=="notifications"){
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'notificationsEnabled':_notificationsEnabled
    });
  }else if(matter=="language"){
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'selectedLanguage':_selectedLanguage
    });
  }else if(matter=="grade"){
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'grade':grade
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
                _loadUserPreferences("darkmode");
              });
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
                _loadUserPreferences("notifications");
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
              _loadUserPreferences("language");
            },
            leading: Icon(Icons.language),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),

          // Grade Selection
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Grade",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: grade,
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      grade = value;
                    });
                  },
                ),
              ],
            ),
          ),
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
