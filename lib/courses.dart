import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:hiq/pages/course_detail_page.dart';
import 'package:line_icons/line_icons.dart';
import 'package:hiq/pages/home_page.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:hiq/theme/colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesPage extends StatefulWidget {
  final User user;
  CoursesPage({required this.user});

  @override
  _CoursesPageState createState() => _CoursesPageState(user: user,);
}

class _CoursesPageState extends State<CoursesPage> {
  User user;
  _CoursesPageState({required this.user});

  List<dynamic> realdata = [];
  String grade = "";
  // Sample course data
  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Physics',
      'description': 'Learn the basics of Flutter, a UI toolkit for building natively compiled applications.',
      'image': 'assets/images/marketing.png', // Replace with your course image URLs
    },
    {
      'title': 'Chemistry',
      'description': 'Deepen your Python skills with advanced concepts and applications.',
      'image': 'assets/images/photography.png', // Replace with your course image URLs
    },
    {
      'title': 'Web Development',
      'description': 'Become a full-stack web developer with this comprehensive course.',
      'image': 'assets/images/ux.png', // Replace with your course image URLs
    },
  ];
  Future<void> loadDataFromFirestore() async {
    try {
      // Reference your Firestore document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      // Update the variable with the data retrieved
      setState(() {
        grade = snapshot['grade'];
      });
      List<dynamic> filteredJsons = online_data_one
      .where((json) => json['grades'] != null && json['grades'].contains(grade))
      .toList();
      setState((){
        realdata = filteredJsons;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }
  TextEditingController _searchController = TextEditingController();
 void initState() {
    loadDataFromFirestore();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Dark background color
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 150, 150, 150).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for anything",
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Course List
          Expanded(
            child: ListView.builder(
              itemCount: realdata.length,
              itemBuilder: (context, index) {
                final course = realdata[index];
                return Card(
                  color: Color.fromARGB(255, 45, 45, 45), // Card background color
                  
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Image
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.asset(
                          course['img']!,
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Course Title
                            Text(
                              course['title']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Course Description
                            Text(
                              course['courses']!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 16),
                            // Enroll Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                enableFeedback: false
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseDetailPage(
                                      imgDetail: course['img_detail']!,
                                      title: course['title']!,
                                      user: user,
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Enroll Now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
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
              },
            ),
          ),
        ],
      ),
    );
  }
}