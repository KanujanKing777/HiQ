import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hiq/courses.dart';
import 'package:hiq/ecommerce/productdisplay.dart';
import 'package:hiq/pages/infoPage.dart';
import 'package:hiq/pages/course_detail_page.dart';
import 'package:hiq/custom_drawer/home_drawer.dart';
import 'package:hiq/help_screen.dart';
import 'package:hiq/invite_friend_screen.dart';
import 'package:hiq/profile.dart';
import 'package:hiq/screens/Login/login_screen.dart';
import 'package:hiq/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<dynamic> realdata = [];

class HomePage extends StatefulWidget {
  final User user;
  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

int _currentIndex = 0;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    loadDataFromFirestore();
  }

  String grade = "";

  List<dynamic> selectedCourses = [];

  TextEditingController _searchController = TextEditingController();
  DrawerIndex screenIndex = DrawerIndex.HOME;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true; // Loading state

  // Fetch data from Firestore
  Future<void> loadDataFromFirestore() async {
    try {

      // Get user document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.email)
          .get();

      if (!snapshot.exists) {
        print("User document does not exist!");
        return;
      }

      // Update grade
      setState(() {
        grade = snapshot['grade'];
      });

      // Update selected courses
      setState(() {
        selectedCourses = snapshot['selectedCourse'];
      });

      // Fetch subjects collection
      QuerySnapshot subjectsSnapshot =
          await FirebaseFirestore.instance.collection('subjects').get();


      List<dynamic> filteredSubjects = [];
      for (var subject in subjectsSnapshot.docs) {
        var subjectData = subject.data() as Map<String, dynamic>?;
        if (subjectData != null) {

          // Try different possible field names for subject ID
          var idid = subjectData['subjectId']?.toString();


          if (selectedCourses.contains(idid)) {
            filteredSubjects.add({
              'title': subjectData['name'],
              'img': subjectData['img'],
            });
          } else {
            print(
                "No match for ID: $idid in selectedCourses: $selectedCourses");
          }
        } else {
          print("Warning: Subject data is null for document: ${subject.id}");
        }
      }


      setState(() {
        realdata = filteredSubjects;
      });
      print("realdata updated successfully");
    } catch (e, stackTrace) {
      print("Error in loadDataFromFirestore: $e");
      print("Stack trace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => InfoPage()));
            },
          )
        ],
        elevation: 10,
        backgroundColor: Colors.black,
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
        child: TextButton(
          child: Container(
            width: 110,
            child: Row(children: [
              Icon(
                Icons.chat,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Ai ChatBot",
                style: TextStyle(color: Colors.white),
              )
            ]),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HelpScreen()));
          },
        ),
      ),
    
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1F1F1F),
                    Color(0xFF121212),
                    Color(0xFF2C1F4A),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: _currentIndex == 0
                  ? getBody()
                  : _currentIndex == 1
                      ? CoursesPage(user: widget.user)
                      : _currentIndex == 2
                          ? ProductListPage()
                          : ProfilePage(
                              userName: widget.user.displayName!,
                              userEmail: widget.user.email!,
                              profilePicture: widget.user.photoURL!,
                              user: widget.user),
              ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 220, 97, 242),
        selectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 220, 97, 242)),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.shifting,
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
            icon: Icon(Icons.shop),
            label: 'Shop',
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // Welcome Section with gradient text
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ).createShader(bounds),
          child: Text(
            "Hey ${widget.user.displayName ?? 'Guest'},",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),

        // Search Bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search courses...",
              hintStyle: TextStyle(color: Colors.grey[400]),
              icon: Icon(Icons.search, color: Colors.grey[400]),
            ),
          ),
        ),
        SizedBox(height: 30),

        // Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buildCategoryChip("All", true),
              buildCategoryChip("Popular", false),
              buildCategoryChip("Newest", false),
              buildCategoryChip("Advanced", false),
            ],
          ),
        ),
        SizedBox(height: 30),

        // Continue Learning Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Continue Learning",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "See All",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Existing GridView with enhanced card design
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Changed to 1 for bigger cards
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.2, // Adjusted aspect ratio
          ),
          itemCount: realdata.length,
          itemBuilder: (context, index) {
            return buildCourseCard(context, index);
          },
        ),

        SizedBox(height: 20),

        // Explore Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recommended for You",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "See All",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),

        // Second GridView with the same enhanced card design
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Changed to match first section
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.2, // Match first section's aspect ratio
          ),
          itemCount: realdata.length,
          itemBuilder: (context, index) {
            return buildCourseCard(context, index);
          },
        ),
      ],
    );
  }

  Widget buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (bool value) {},
        backgroundColor: Colors.grey[850],
        selectedColor: Colors.blue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[400],
        ),
      ),
    );
  }

  Widget buildCourseCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailPage(
              imgDetail: realdata[index]['img'],
              title: realdata[index]['title'],
              user: widget.user,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C2C2C),
              Color(0xFF1A1A1A),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(realdata[index]['img']),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            realdata[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26, // Increased font size
                              foreground: Paint()..shader = LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.purple,
                                ],
                              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor:
          const Color(0xFF121212), // Dark background for the Drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.user.displayName ?? '',
              style: const TextStyle(
                color: Colors.white, // White text for account name
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              widget.user.email ?? '',
              style: const TextStyle(
                color: Colors.white70, // Slightly lighter text for email
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
              backgroundColor:
                  Colors.grey[800], // Dark background for profile picture
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1F1F1F), // Darker shade for the drawer header
            ),
          ),
          // Settings
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.white, // White icon for better contrast
            ),
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.white, // White text for items
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SettingsPage(widget.user.email ?? '')),
              );
            },
          ),
          // Help & Support
          ListTile(
            leading: Icon(
              Icons.help,
              color: Colors.white, // White icon
            ),
            title: const Text(
              "Help & Support",
              style: TextStyle(
                color: Colors.white, // White text
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HelpScreen()),
              );
            },
          ),
          // Invite Friends
          ListTile(
            leading: Icon(
              Icons.people,
              color: Colors.white, // White icon
            ),
            title: const Text(
              "Invite Friends",
              style: TextStyle(
                color: Colors.white, // White text
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InviteFriend()),
              );
            },
          ),
          // Logout
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white, // White icon
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white, // White text
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
