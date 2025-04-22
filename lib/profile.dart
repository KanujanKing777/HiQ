import 'package:flutter/material.dart';
import 'package:hiq/progress.dart';
import 'package:hiq/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profilePicture;
  User user;
  final List<String> courses = ["1"]; // List of courses being learned

  ProfilePage({
    required this.userName,
    required this.userEmail,
    required this.profilePicture,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF121212), // Dark background
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 50, // Adjust the size of the profile picture
            backgroundImage: NetworkImage(profilePicture), // Using NetworkImage
          ),
          SizedBox(height: 16),

          // User Name
          Text(
            userName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text for dark theme
            ),
          ),
          SizedBox(height: 8),

          // User Email
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70, // Slightly lighter color for email
            ),
          ),
          SizedBox(height: 32),

          // Courses Box
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1F1F1F), // Dark background for the courses box
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // shadow position
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title for Courses Section
                Text(
                  'Courses You Are Learning',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for dark theme
                  ),
                ),
                SizedBox(height: 10),
                // List of Courses
                for (var course in courses)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: StudentProgress(subjectID: course, progress: 0.75, user: user,),
                  ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // Edit Profile Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(userEmail)));
            },
            child: Text('Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Blue background for button
              foregroundColor: Colors.white, // White text for button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
          SizedBox(height: 16),

          // Logout Button
          ElevatedButton(
            onPressed: () {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Color(0xFF1F1F1F), // Dark background for dialog
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white), // White text
                    ),
                    content: Text(
                      'Are you sure you want to log out?',
                      style: TextStyle(color: Colors.white70), // Slightly lighter text
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blueAccent), // Blue button color
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add logout functionality here
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red), // Red text for logout
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red background for logout button
              foregroundColor: Colors.white, // White text for button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    ),
  );
}

}
