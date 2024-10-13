import 'package:flutter/material.dart';
import 'package:hiq/constant/data_json.dart';

class StudentProgress extends StatelessWidget {
  final String studentName;
  final double progress; // Progress should be between 0.0 and 1.0

  StudentProgress({required this.studentName, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Container(
            width: 60, // Adjust width as needed
            height: 60, // Adjust height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(online_data_one[0]['img']), // Ensure this path is correct
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(30), // Circular image
              border: Border.all(color: Colors.blue, width: 2), // Optional border around image
            ),
          ),
          SizedBox(width: 16), // Space between image and text

          // Column for student name and progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                // Progress indicator row
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%', // Display progress percentage
                      style: TextStyle(fontWeight: FontWeight.bold),
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
}
