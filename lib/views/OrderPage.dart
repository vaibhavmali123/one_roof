import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/AllOrders.dart';
import 'package:one_roof/views/BottomNavigationScreen.dart';
import 'package:one_roof/views/CompletedOrders.dart';
import 'package:one_roof/views/InProgressOrders.dart';
import 'package:one_roof/views/OpenOrders.dart';

class OrderPage extends StatefulWidget {
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage> {
//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  String userType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotification();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(75),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      elevation: 0.3,
                      centerTitle: false,
                      actions: [
                        Container(
                          width: Get.size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Image.asset(
                                      'assets/images/back_icon.png',
                                      scale: 1.8,
                                    ),
                                    onTap: () {
                                      Get.to(BottomNavigationScreen());
                                    },
                                  )),
                              Expanded(
                                flex: 5,
                                child: Text(AppStrings.myOrders, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700)),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
            body: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Container(
                    width: Get.context.width,
                    height: 50,
                    color: Colors.white,
                    child: TabBar(
                        unselectedLabelStyle: TextStyle(fontSize: 15),
                        labelStyle: TextStyle(fontSize: 15, color: Colors.red),
                        indicatorColor: color.colorConvert('#0457BE').withOpacity(0.8),
                        indicatorWeight: 0,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5),
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: color.colorConvert('#0457BE').withOpacity(0.8),
                            ),
                            insets: EdgeInsets.symmetric(horizontal: 10.0)),
                        labelColor: Colors.red,
                        tabs: [
                          Text(
                            AppStrings.all,
                            style: TextStyle(fontSize: 12, color: color.colorConvert('9F9DAA').withOpacity(1), fontWeight: FontWeight.w900),
                          ),
                          Text(
                            AppStrings.open,
                            style: TextStyle(fontSize: 12, color: color.colorConvert('9F9DAA').withOpacity(1), fontWeight: FontWeight.w900),
                          ),
                          Text(
                            AppStrings.inProgress,
                            style: TextStyle(fontSize: 12, color: color.colorConvert('9F9DAA').withOpacity(1), fontWeight: FontWeight.w900),
                          ),
                          Text(
                            userType == Constants.hire ? AppStrings.completed : 'Assigned',
                            style: TextStyle(fontSize: 12, color: color.colorConvert('9F9DAA').withOpacity(1), fontWeight: FontWeight.w900),
                          ),
                        ]),
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [AllOrders(), OpenOrders(), InProgressOrders(), CompletedOrders()],
                  ))
                ],
              ),
            )),
        onWillPop: () {
          Get.offAll(BottomNavigationScreen());
        });
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    setState(() {
      userType = appDb.get(ApiKeys.type);
    });
  }

  void initNotification() async {
/*
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> map) async {
      print("Notification ${map['notification']}");
      Map<String, dynamic> mapData;
      setState(() {
        mapData = {
          "title": map['notification']['title'],
          "body": map['notification']['body']
        };
      });
      print("Notification ${map['notification'].toString()}");
      print("Notification ${map['notification']['title']}");
      print("Notification ${map['notification']['body']}");

      print("Notification ${mapData.toString()}");

      _showNotification(mapData);
    }, onLaunch: (Map<String, dynamic> map) async {
      print("Notification l${map.toString()}");
      _showNotification(map);
    },
        //onBackgroundMessage:myBackgroundHandler,
        onResume: (Map<String, dynamic> map) async {
          print("Notification r ${map.toString()}");
        });
*/
  }
  Future _showNotification(Map<String, dynamic> mesage) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_ID', 'channel_name', 'channel description',
        importance: Importance.high,
        playSound: true,
        // sound: 'sound',
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    print("Channel :${platformChannelSpecifics.android.channelId}");
    await flutterLocalNotificationsPlugin.show(0, mesage['title'], mesage['body'], platformChannelSpecifics, payload: 'Default_Sound');
  }
}
