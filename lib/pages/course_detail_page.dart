import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hiq/content/content.dart';
import 'package:hiq/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseDetailPage extends StatefulWidget {
  final String imgDetail;
  final String title;
  final User user;
  CourseDetailPage({this.imgDetail = "", this.title = "", required this.user});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  String? grade;

  @override
  void initState() {
    super.initState();
    loadDataFromFirestore();
  }
 Future<void> loadDataFromFirestore() async {
    try {
      // Reference your Firestore document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.email)
          .get();

      // Update the variable with the data retrieved
      setState(() {
        grade = snapshot['grade'];
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              // Image in the background
              Positioned.fill(
                bottom: 260,
                child: Container(
                  height: size.height * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.imgDetail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Content and Course Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon:
                              SvgPicture.asset("assets/images/arrow_icon.svg"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: SvgPicture.asset("assets/images/more_icon.svg"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            buildInfoRow("assets/images/user_icon.svg", "18k"),
                            SizedBox(width: 25),
                            buildInfoRow("assets/images/star_icon.svg", "4.8"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Course Content Section
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.40),
                    width: size.width,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Course Content",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 40),
                          // Fetch Course Data from Firestore
                          FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection(grade!+" "+widget.title)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data == null) {
                                return Center(child: Text('No data found'));
                              }

                              var documents = snapshot.data!.docs;
                              return SizedBox(
                                height: 300, // Adjusted to fit content properly
                                child: ListView.builder(
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    var data = documents[index].data()
                                        as Map<String, dynamic>;

                                    return ListTile(
                                      title: Text(data['topic'] ?? 'No title'),
                                      subtitle: Text((data['content'].toString().split(' ').length / 150).round().toString() + ' min'),
                                      onTap: (){
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => ContentPage(
                                            title: data['topic'],
                                            description: data['description'],
                                            item: data['content'],
                                            user: widget.user,
                                          ))
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String iconPath, String text) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(iconPath),
        SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(text),
        ),
      ],
    );
  }
}
