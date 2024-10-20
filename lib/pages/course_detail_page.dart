import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:hiq/theme/colors.dart';

class CourseDetailPage extends StatefulWidget {
   String imgDetail = "";
   String title = "";

   CourseDetailPage({this.imgDetail = "", this.title = ""})
      ;

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }
  Widget getFooter(){
     var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 100,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(
          color: black.withOpacity(0.05),
          spreadRadius: 5,
          blurRadius: 10
        )]
      ),
      
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned.fill(
                bottom: 260,
                child: Container(
                  height: size.height * 0.45,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.imgDetail),
                          fit: BoxFit.cover)),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: SvgPicture.asset(
                                  "assets/images/arrow_icon.svg"),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          IconButton(
                              icon: SvgPicture.asset(
                                  "assets/images/more_icon.svg"),
                              onPressed: () {})
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
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                      "assets/images/user_icon.svg"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text("18k"),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                      "assets/images/star_icon.svg"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text("4.8"),
                                  )
                                ],
                              ),
                            ],
                          ),
                          
                          
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.40),
                width: size.width,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Course Content",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: List.generate(course_content.length, (index){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              course_content[index]['id'],
                              style: TextStyle(
                                  fontSize: 30, color: black.withOpacity(0.3)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  course_content[index]['duration'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: black.withOpacity(0.5),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  course_content[index]['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: course_content[index]['isWatched'] ? green : green,
                               shape: BoxShape.circle
                              ),
                              child: Center(
                                child: SvgPicture.asset("assets/images/play_icon.svg"),
                              ),
                            )
                          ],
                      ),
                        );
                      }))
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
