import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add course data to Firestore
  Future<void> addCourse() async {
    try {
      // Define the course data
      Map<String, dynamic> course = {
        "id": "",
        "subjectname": "",
        "studentemail":"",
        "chapterno":""
      };

      // Add the course to Firestore (collection name: 'courses')
      await _firestore.collection('courses').add(course);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Course added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add course: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          onPressed: addCourse,
          child: Text('Enroll Course'),
      
    );
  }
}
