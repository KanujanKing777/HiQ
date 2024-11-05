import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hiq/pages/course_detail_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final apiKey = 'AIzaSyAMr6gYkI6ZAqSdAAz67xRtfogvYJbALTw';

class ContentPage extends StatefulWidget {
  final String title;
  final String description;
  final String item;
  final dynamic data; // Changed to dynamic for better flexibility
  final User user;

  ContentPage({
    required this.title,
    required this.description,
    required this.item,
    required this.data,
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
    splitText();
  }

  Future<void> splitText() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    String text = "Separate this content into meaningful chunks (paragraphs): ${widget.item}"; // Fixed prompt
    final prompt = text;

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        newItem = response.text!.split('\n');
        isLoading = false; // Update loading state after data is fetched
      });
    } catch (error) {
      print('Error generating content: $error'); // Error handling
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
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
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(
                  widget.description,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            
            SizedBox(height: 20),
            // Show loading indicator or list items
            isLoading
                ? Center(child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 200,
      ),
    ) // Loading indicator
                : newItem.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true, // Prevent infinite height
                        physics: NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: newItem.length,
                        itemBuilder: (context, index) {
                          return SelectableText(
                            newItem[index],
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                            textAlign: TextAlign.justify,
                          );
                        },
                      )
                    : Text("No content available"), // Handle empty content case
            TextButton(
              child: Text("Next"),
              onPressed: () {
                setState(() {
                  widget.data.update({
                    'status':"finished"
                  });
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
