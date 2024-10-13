import 'package:flutter/material.dart';
import 'package:hiq/progress.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profilePicture;
  final List<String> courses = ["Physics"]; // List of courses being learned

  ProfilePage({
    required this.userName,
    required this.userEmail,
    required this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
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
              ),
            ),
            SizedBox(height: 8),

            // User Email
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32),

            // Courses Box
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Courses You Are Learning',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // List of Courses
                  for (var course in courses)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: StudentProgress(studentName: course, progress: 0.75)
                    ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Add edit profile functionality here
              },
              child: Text('Edit Profile'),
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
                      title: Text('Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add logout functionality here
                            Navigator.of(context).pop();
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Logout', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          
          ],
        ),
      );
  }
}
