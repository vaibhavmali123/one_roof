import 'dart:io';
import 'dart:isolate';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/views/BottomNavigationScreen.dart';
import 'package:one_roof/views/WelcomeScreen.dart';
import 'package:path_provider/path_provider.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
  );*/

  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>(ApiKeys.appDb);
  await Hive.openBox<String>(Constants.countList);

  runApp(
      /*DevicePreview(
    builder: (context) => DeviceView(),
  )*/
      MyApp());
}

Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) async {
  print("notification SELECTED");
  await Firebase.initializeApp();

  onSelectNotification(" str");
  currentIndex = 0;
  Box<String> appDb;
  appDb = Hive.box(ApiKeys.appDb);

  await appDb.put(ApiKeys.fromNotification, "true");

  return NotificationService.showNotification(message);
}

var currentIndex = 0;

class DeviceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      home: MyApp(),
    );
  }
}

String fcmToken;

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Box<String> appDb;
  String logedIn;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
    NotificationService.init();
    appDb = Hive.box(ApiKeys.appDb);
    logedIn = appDb.get(Constants.logedInFlag);
    NotificationService.init();
    NotificationService.configureNotification();

    getTocken();
    /*IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
*/
    //initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: DevicePreview.appBuilder,
        title: 'Flutter Demo',
        /*initialRoute: '/',
      routes:{
        '/':(context)=>WelcomeScreen(),
        'login':(context)=>LoginScreen(),
      },*/
        home: logedIn != Constants.logedInFlag ? WelcomeScreen() : BottomNavigationScreen());
  }

  /*
  logedIn!=Constants.logedInFlag?WelcomeScreen():BottomNavigationScreen()*/
  void initNotification() async {
    Future.delayed(Duration(seconds: 1), () {
      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> map) async {
            print("Notification ${map['notification']}");
            Map<String, dynamic> mapData;
            setState(() {
              mapData = {"title": map['notification']['title'], "body": map['notification']['body']};
            });
            print("Notification ${map['notification'].toString()}");
            print("Notification ${map['notification']['title']}");
            print("Notification ${map['notification']['body']}");

            print("Notification ${mapData.toString()}");

            return NotificationService.showNotification(mapData);
            print("Notification mapData ${mapData.toString()}");

            // _showNotification(message);
          },
          onLaunch: (Map<String, dynamic> message) async {
            print("Notification OnLaunch${message.toString()}");
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Get.to(BottomNavigationScreen());
            }); //_showNotification(map);
          },
          onBackgroundMessage: myBackgroundHandler,
          onResume: (Map<String, dynamic> map) async {
            print("Notification OnResume${map.toString()}");
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Get.to(BottomNavigationScreen());
            });
            print("Notification onResume ${map.toString()}");
          });
    });
  }

  void getTocken() {
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        fcmToken = value;
      });
      print("TOKEN ${value.toString()}");
      print("TOKEN ${fcmToken.toString()}");
    });
  }
/*  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }*/

}

Future<void> onSelectNotification(String payload) {
  print("FLAG payload${payload.toString()}");

  currentIndex = 0;
  if (payload != null) {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);

    appDb.put(ApiKeys.fromNotification, "true");
  }
  Get.to(BottomNavigationScreen());
}
