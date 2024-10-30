import 'package:flutter/material.dart';
import 'package:hiq/courses.dart';
import 'package:hiq/theme/colors.dart';
import 'package:hiq/pages/course_detail_page.dart';
import 'package:hiq/custom_drawer/home_drawer.dart';
import 'package:hiq/help_screen.dart';
import 'package:hiq/invite_friend_screen.dart';
import 'package:hiq/profile.dart';
import 'package:hiq/progress.dart';
import 'package:hiq/screens/Login/login_screen.dart';
import 'package:hiq/settings.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

int _currentIndex = 0;

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  DrawerIndex screenIndex = DrawerIndex.HOME;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("About Us"),
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child:Column(
                      children: [
                        Text("This is a Mobile application developed inorder to digitalize and modernize education with Artificial Intelligence.\n\nDevelopers:- Kanujan & Karthigan"),
                      ]
                    )
                  )
                ),
              );
            },
          )
        ],
        elevation: 10,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Container(
            margin: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(widget.user.photoURL!),
                    fit: BoxFit.cover)),
          ),
        ),
      ),
      drawer: buildDrawer(context),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: IconButton(
          icon: Icon(
            Icons.chat,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HelpScreen()));
          },
        ),
      ),
      body: _currentIndex == 0
          ? getBody()
          : _currentIndex == 1
              ? CoursesPage(user: widget.user)
              : ProfilePage(
                  userName: widget.user.displayName!,
                  userEmail: widget.user.email!,
                  profilePicture: widget.user.photoURL!,
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    return ListView(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
      children: [
        Text("Hey ${widget.user.displayName ?? 'Guest'},",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        SizedBox(height: 15),
        Text("Continue your courses", style: TextStyle(fontSize: 18)),
        SizedBox(
          height: 15,
        ),
        StudentProgress(studentName: "Physics", progress: 0.75),
        SizedBox(height: 40),
        Text("Find a course you want to learn", style: TextStyle(fontSize: 18)),
        SizedBox(height: 15),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search for anything",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Categories",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            TextButton(
              child: Text(
                "See All",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: primary),
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            )
          ],
        ),
        SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true, // Makes GridView fit in ListView
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: online_data_one.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(
                          imgDetail: online_data_one[index]['img_detail'],
                          title: online_data_one[index]['title'],
                          user: widget.user,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(online_data_one[index]['img']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(online_data_one[index]['title'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(online_data_one[index]['courses']),
                    ],
                  ),
                ));
          },
        ),
      ],
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.displayName ?? ''),
            accountEmail: Text(widget.user.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
            ),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SettingsPage(widget.user.email ?? '')));
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help & Support"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HelpScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Invite Friends"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => InviteFriend()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
