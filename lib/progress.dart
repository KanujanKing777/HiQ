import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiq/pages/course_detail_page.dart';
class StudentProgress extends StatefulWidget{
  User user;
  final String subjectID;
  final double progress;
  StudentProgress({required this.subjectID, required this.progress, required this.user});
  @override
  _StudentProgress createState() => _StudentProgress();

}
class _StudentProgress extends State<StudentProgress> {
  String subjectID = "";
  double progress = 0.0; // Progress should be between 0.0 and 1.0;

  String imgData = "";
  String title = "";
  void loadData(){
    subjectID = widget.subjectID;
    progress = widget.progress;
    if(subjectID == "1"){
      setState(() {
        imgData = "assets/images/marketing_detail.png";
        title = "Physics";
      });
    }
  }
  void initState() {
    loadData();
  }
  Widget funny(){
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.1), // Translucent background
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Image with Glass Effect
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(online_data_one[0]['img']), // Ensure this path is correct
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blueAccent, width: 3),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),

          // Column for Name and Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),

                // Progress Bar with Percentage
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => CourseDetailPage(
                      imgDetail: imgData,
                      title: title,
                      user: widget.user,
                      
                    ))
      ),
      child:funny(),

    );
    
  }
}
