import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hiq/content/viewerpdf.dart';
import 'package:hiq/pages/course_detail_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final apiKey = 'AIzaSyAMr6gYkI6ZAqSdAAz67xRtfogvYJbALTw';

class ContentPage extends StatefulWidget {
  final String title;
  final User user;
  final String url;
  ContentPage({
    required this.title,
    required this.url,
    required this.user,
  });

  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<ContentPage> {
  List<String> newItem = [""];
  bool isLoading = true; // To track loading state
  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: PDFViewerPage(url: widget.url), 
      
      floatingActionButton: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 8,
        offset: Offset(0, 4), // Shadow position
      ),
    ],
  ),
  child: InkWell(
    borderRadius: BorderRadius.circular(30),
    onTap: () {
                
                Navigator.pop(context);
              },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        'Next',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)

    );
  }
}
