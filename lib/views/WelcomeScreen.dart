import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_roof/blocs/DeviceTypeBloc.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/AccountSelection.dart';
import 'package:one_roof/views/LoginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String deviceType;
  DeviceTypeBloc deviceTypeBloc;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    deviceTypeBloc = DeviceTypeBloc();

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      /*onSelectNotification: onSelectNotification*/
    );
    Map<String, dynamic> mapData = {"title": "test", "body": "test"};

    //_showNotification(mapData);
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            print("HEIGHT ${constraints.maxHeight}");
            if (constraints.maxHeight <= 725) {
              deviceType = 'smallScreen';
              deviceTypeBloc.deviceChanged(AppStrings.sdpi);
            }
            print("HEIGHT ${deviceType}");

            return StreamBuilder<String>(
              stream: deviceTypeBloc.deviceType,
              builder: (context, snapshot) => Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: snapshot.data == AppStrings.sdpi ? 2 : 1, child: Container()),
                    getAppLogo(),
                    Expanded(flex: 2, child: Container()),
                    getImageAndText(context),
                    Expanded(flex: 1, child: Container()),
                    getWelcomeText(),
                    Expanded(flex: 2, child: Container()),
                    getButtons(context),
                    Expanded(flex: 2, child: Container()),
                  ],
                ),
              ),
            );
          },
        )
        /*Column(
         crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          Expanded(
              flex:2,
              child:Container()),
           getAppLogo(),
          Expanded(
              flex:2,
              child:Container()),
          getImageAndText(context),
          Expanded(
              flex:1,
              child: Container()),
          getWelcomeText(),
          Expanded(
              flex:2,
              child:Container()),
      getButtons(context),
          Expanded(
              flex:2,
              child:Container()),

        ],
       )*/
        ,
      ),
    );
  }

  Widget getAppLogo() {
    return StreamBuilder<String>(
        stream: deviceTypeBloc.deviceType,
        builder: (context, snapshot) {
          print("HEIGHT FROM BLOC ${snapshot.data}");
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/app_icon.jpeg',
                    scale: 1.7,
                  )
                  /*Icon((Icons.camera),size:snapshot.data!=AppStrings.sdpi?100:80,color:color.colorConvert(color.primaryColor),)*/
                ],
              ),
              SizedBox(
                height: 5,
              ),
              AutoSizeText(AppStrings.appName, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: snapshot.data == AppStrings.sdpi ? 20 : 24, color: color.colorConvert('#231F20'), fontWeight: FontWeight.w700, letterSpacing: 0.0, height: 1.2)))
            ],
          );
        });
  }

  getImageAndText(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/engineers.png',
          width: MediaQuery.of(context).size.width - 80,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  getButtons(BuildContext context) {
    return StreamBuilder(
      stream: deviceTypeBloc.deviceType,
      builder: (context, snapshot) => Column(
        children: [
          ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 2,
              height: snapshot.data != AppStrings.sdpi ? 55 : 50,
              child: RaisedButton(
                  child: Text(
                    AppStrings.login,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  color: color.colorConvert(color.primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () {
                    Get.to(LoginScreen());
                  })),
          SizedBox(
            height: snapshot.data != AppStrings.sdpi ? 25 : 14,
          ),
          GestureDetector(
            onTap: () => Get.to(AccountSelection())
            /*Get.to(BottomNavigationScreen())*/,
            child: Container(
              height: snapshot.data != AppStrings.sdpi ? 55 : 50,
              width: MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Text(
                  AppStrings.createAccount,
                  style: TextStyle(fontSize: 16, color: color.colorConvert(color.primaryColor)),
                ),
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(width: 1.8, color: color.colorConvert(color.primaryColor))),
            ),
          )
        ],
      ),
    );
  }

  Widget getWelcomeText() {
    return StreamBuilder<String>(
        stream: deviceTypeBloc.deviceType,
        builder: (context, snapshot) => Column(
              children: [
                Text(AppStrings.welcomeText, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: snapshot.data != AppStrings.sdpi ? 20 : 18, color: Colors.black87, fontWeight: FontWeight.w800, letterSpacing: 0.0))),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppStrings.welcomeSubtitle,
                  style: TextStyle(fontSize: 15, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600),
                ),
              ],
            ));
  }

  void initNotification() async {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> map) async {
      print("Notification ${map['notification']}");
      Map<String, dynamic> mapData;
      setState(() {
        mapData = {"title": map['notification']['title'], "body": map['notification']['body']};
      });
      print("Notification ${map['notification'].toString()}");
      print("Notification ${map['notification']['title']}");
      print("Notification ${map['notification']['body']}");

      print("Notification ${mapData.toString()}");

      _showNotification(mapData);
    }, onLaunch: (Map<String, dynamic> map) async {
      print("Notification l${map.toString()}");
      //_showNotification(map);
    },
        //onBackgroundMessage:myBackgroundHandler,
        onResume: (Map<String, dynamic> map) async {
      print("Notification r ${map.toString()}");
    });
  }

  var androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_ID', 'channel_name', 'channel description',
      importance: Importance.high,
      playSound: true,
      // sound: 'sound',
      showProgress: true,
      priority: Priority.high,
      ticker: 'test ticker');

  Future _showNotification(Map<String, dynamic> mesage) async {
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    print("Channel :${platformChannelSpecifics.android.channelId}");
    await flutterLocalNotificationsPlugin.show(0, mesage['title'], mesage['body'], platformChannelSpecifics, payload: 'Default_Sound');
  }
}
