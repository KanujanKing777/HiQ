import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


final apiKey = 'AIzaSyAMr6gYkI6ZAqSdAAz67xRtfogvYJbALTw';

class ContentPage extends StatefulWidget {
  final String title;
  final String description;
  final String item;
  String itemcontent = "";
  final User user;
  ContentPage(
      {required this.title,
      required this.description,
      required this.item,
      required this.user});
  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<ContentPage> {
  @override
  void initState() {
    super.initState();
    splitText();
  }
  Future<void> splitText()async{
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
    String text = "Separate this content into meaningful chunks(paragraphs).'${widget.item}";
    final prompt = text;
    final response = await model.generateContent([Content.text(prompt)]);
    setState(() {
      widget.itemcontent = response.text!;
    });
  
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.description,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.itemcontent,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
