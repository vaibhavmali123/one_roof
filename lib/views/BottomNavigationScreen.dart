import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/one__roof_icons.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/HomePage.dart';
import 'package:one_roof/views/NotificationsPage.dart';
import 'package:one_roof/views/ProfilePage.dart';
import 'package:one_roof/views/SearchPage.dart';
import 'package:one_roof/main.dart';
class BottomNavigationScreen extends StatefulWidget{

  BottomNavigationScreenState createState()=>BottomNavigationScreenState();
}

class BottomNavigationScreenState extends State<BottomNavigationScreen>
{


  List<BottomNavigationBarItem>bottomNavItems=[
    BottomNavigationBarItem(
        icon: Icon(
          One_Roof.home_icon,
          size:20,
          /*Icons.home_outlined,
          size:30,*/
        ),
        title: Text(
          '',
          style: TextStyle(
              fontSize: 2, fontWeight: FontWeight.w400),
        )
        ),
    BottomNavigationBarItem(
      icon: Icon(
        One_Roof.search_icon,
        size:20,
      ),
        title: Text(
          '',
          style: TextStyle(
              fontSize: 2, fontWeight: FontWeight.w400),
        )
    ),
    BottomNavigationBarItem(
      icon: Icon(
        One_Roof.notification_icon,
        size:20,
      ),
        title: Text(
          '',
          style: TextStyle(
              fontSize: 2, fontWeight: FontWeight.w400),
        )
    ),
    BottomNavigationBarItem(
      icon: Icon(
        One_Roof.profile_icon,
        size:20,
      ),
        title: Text(
          '',
          style: TextStyle(
              fontSize: 2, fontWeight: FontWeight.w400),
        )
    ),
  ];

  List<Widget>_children=[
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    ProfilePage()
  ];
  Box<String> appDb;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.configureNotification();

    appDb = Hive.box(ApiKeys.appDb);
print("FLAG ${appDb.get(ApiKeys.fromNotification)}");
    setState(() {
      appDb.get(ApiKeys.fromNotification)=="true"?currentIndex=2:0;
    });
    print("FLAG ${appDb.get(ApiKeys.fromNotification)}");

  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      bottomNavigationBar:getBottomNav(),
      body:_children[currentIndex]
    );
    }

  getBottomNav() {
    return Container(
      child:BottomNavigationBar(
        elevation: 14,

        selectedItemColor: color.colorConvert(color.primaryColor),
        showSelectedLabels: false,   // <-- HERE
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(
            fontSize:14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
            fontSize:14, fontWeight: FontWeight.w600),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items:bottomNavItems,
        onTap: onTapBottomNav,
        currentIndex: currentIndex,
      ),
    );
  }

  void onTapBottomNav(int value) {
    setState(() {
      currentIndex=value;
    });
  }
}