import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_roof/main.dart';

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging();

  static var androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_ID', 'channel_name', 'channel description',
      importance: Importance.max,
      playSound: true,
      // sound: 'sound',
      showProgress: true,
      //priority: Priority.max,
      ticker: 'test ticker');

  static Future<void> configureNotification() {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> map) async {
      // print("Notification ${map['notification']}");
      Map<String, dynamic> mapData;
      mapData = {"title": map['notification']['title'], "body": map['notification']['body']};
      /* print("Notification ${map['notification'].toString()}");
      print("Notification ${map['notification']['title']}");
      print("Notification ${map['notification']['body']}");

     */
      print("Notification ${mapData.toString()}");

      showNotification(mapData);
    }, onLaunch: (Map<String, dynamic> map) async {
      print("Notification OnLaunch${map.toString()}");
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //Get.to(BottomNavigationScreen());
      });
    },
        //onBackgroundMessage:myBackgroundHandler,
        onResume: (Map<String, dynamic> map) async {
      print("Notification OnResume${map.toString()}");

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        // Get.to(BottomNavigationScreen());
      });
      print("Notification r ${map.toString()}");
    });
  }

  static Future<void> init() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  static Future showNotification(Map<String, dynamic> mesage) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_ID', 'channel_name', 'channel description',
        importance: Importance.high,
        playSound: true,
        // sound: 'sound',
        showProgress: true,
        // priority: Priority.high,
        ticker: 'test ticker');

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    print("Channel :${platformChannelSpecifics.android.channelId}");
    await flutterLocalNotificationsPlugin.show(0, mesage['title'], mesage['body'], platformChannelSpecifics, payload: 'Default_Sound');
  }
}
