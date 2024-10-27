import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:hiq/pages/course_detail_page.dart';
import 'package:line_icons/line_icons.dart';
import 'package:hiq/pages/home_page.dart';
import 'package:hiq/theme/colors.dart';

class CoursesPage extends StatelessWidget {
  User user;
  CoursesPage({required this.user});
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

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          // Search Bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: TextField(
                controller: _searchController,
                cursorColor: black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search for anything",
                  hintStyle: TextStyle(color: black.withOpacity(0.4)),
                  prefixIcon: Icon(
                    LineIcons.search,
                    color: black.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10), // Add spacing between the search bar and the list
          // Course List
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Image
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          course['image'],
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
                              course['title'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Course Description
                            Text(
                              course['description'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 16),
                            // Enroll Button
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to the course detail page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseDetailPage(
                                      imgDetail: course['image'],
                                      title: course['title'],
                                      user: user,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Enroll Now'),
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

class CourseDetailPage2 extends StatelessWidget {
  final String imgDetail;
  final String title;
  final String description;

  CourseDetailPage2({required this.imgDetail, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Image.asset(
              imgDetail,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            SizedBox(height: 16),
            // Course Title
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Course Description
            Text(
              description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            // Additional content can go here
            Text(
              'Additional course content can be added here.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
