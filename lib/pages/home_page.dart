import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hiq/custom_drawer/home_drawer.dart';
import 'package:line_icons/line_icons.dart';
import 'package:hiq/constant/data_json.dart';
import 'package:hiq/pages/course_detail_page.dart';
import 'package:hiq/theme/colors.dart';
import 'package:hiq/fitness_app/fitness_app_home_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
  int _currentIndex = 0;


class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  DrawerIndex screenIndex = DrawerIndex.HOME;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    
  }



   @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void drawerCallback(DrawerIndex index) {
    setState(() {
      screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
              
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"),fit: BoxFit.cover)
              ),
            )
          ],
        ),
      ),
      drawer: buildDrawer(context),
      body: getBody(),
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
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    )
    );
  }
  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("john.doe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"), // Add a profile picture here
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          // Drawer Items
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text("Courses"),
            onTap: () {
              // Navigate to Courses page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              // Navigate to Profile page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              // Navigate to Settings page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help & Support"),
            onTap: () {
              // Navigate to Help & Support page
              Navigator.pop(context);
            },
          ),
          Divider(), // Adds a divider line
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              // Logout action
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  Widget getBody(){
    return ListView(
      padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 40),
      children: <Widget>[
        Text("Hey SopheaMen,",style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600
        ),),
        SizedBox(height: 15,),
        Text("Find a course you want to learn",style: TextStyle(
          fontSize: 18
        ),),
        SizedBox(height: 40,),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextField(
                controller: _searchController,
                cursorColor: black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search for anything",
                  hintStyle: TextStyle(
                    color: black.withOpacity(0.4)
                  ),
                  prefixIcon: Icon(LineIcons.search,color: black.withOpacity(0.8),)
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Categories",style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
            ),),
            Text("See All",style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primary
            ),)
          ],
        ),
        SizedBox(height: 30,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(online_data_one.length, (index){
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(
                  imgDetail: online_data_one[index]['img_detail'],
                  title: online_data_one[index]['title'],
                )));
              },
                          child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Stack(
                      children: <Widget>[
                        Container(
                           width: (MediaQuery.of(context).size.width - 60 ) / 2,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(online_data_one[index]['img']),fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20))
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25,right: 18,left: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(online_data_one[index]['title'],style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 8,),
                               Text(online_data_one[index]['courses'],style: TextStyle(
                                fontSize: 14,
                                color: black.withOpacity(0.6)
                              ),)
                            ],
                          ),
                        )
                      ],
                    ),
              ),
            );
          }),
        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(online_data_two.length, (index){
            return GestureDetector(
              onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(
                  imgDetail: online_data_two[index]['img_detail'],
                  title: online_data_one[index]['title'],
                )));
              },
                          child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Stack(
                      children: <Widget>[
                        Container(
                           width: (MediaQuery.of(context).size.width - 60 ) / 2,
                          height: 240,
                          decoration: BoxDecoration(
                            color: primary,
                            image: DecorationImage(image: AssetImage(online_data_two[index]['img']),fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20))
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25,right: 18,left: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(online_data_two[index]['title'],style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 8,),
                               Text(online_data_two[index]['courses'],style: TextStyle(
                                fontSize: 14,
                                color: black.withOpacity(0.6)
                              ),)
                            ],
                          ),
                        )
                      ],
                    ),
              ),
            );
          }),
        ),
        ],)
        
        
      ],
    );
  }
}