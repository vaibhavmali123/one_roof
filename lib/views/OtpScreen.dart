import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/blocs/DeviceTypeBloc.dart';
import 'package:one_roof/main.dart';
import 'package:one_roof/models/VerifyOtpModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/Database.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/MoreAbout.dart';
import 'package:one_roof/views/MoreAboutWorker.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String accountType, mNo, user_id, firstName, lastName, email, password;

  OtpScreen({this.accountType, this.mNo, this.user_id, this.firstName, this.lastName, this.email, this.password});

  OtpScreenState createState() => OtpScreenState(accountType, mNo, user_id, firstName, lastName, email, password);
}

class OtpScreenState extends State<OtpScreen> {
  final String accountType, mNo, user_id, firstName, lastName, email, password;
  String otpText;
  OtpScreenState(this.accountType, this.mNo, this.user_id, this.firstName, this.lastName, this.email, this.password);
  FirebaseMessaging _firebaseMessaging;

  Timer _timer;
  int _start = 60;

  TextEditingController controller = TextEditingController(text: "");
  DeviceTypeBloc deviceTypeBloc;
  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging();
    super.initState();
    startTimer();
    deviceTypeBloc = DeviceTypeBloc();
    initNotification();
    print("DDDbbDDDD ${user_id.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text("Verify mobile no.", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w900)),
                  leading: GestureDetector(
                    child: Image.asset(
                      'assets/images/back_icon.png',
                      scale: 1.8,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ))
            ],
          )),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Text('OTP is sent to +' + mNo, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black38, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Text("Enter 4 digit OTP", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
                          SizedBox(
                            height: 18,
                          ),
                          PinCodeTextField(
                            autofocus: false,
                            hideCharacter: false,
                            highlight: true,
                            pinBoxOuterPadding: EdgeInsets.symmetric(horizontal: 14),
                            highlightColor: Colors.black,
                            defaultBorderColor: Colors.black38,
                            hasTextBorderColor: Colors.black38,
                            highlightPinBoxColor: Colors.white,
                            maxLength: 4,
                            // maskCharacter: "*",
                            onTextChanged: (text) {
                              setState(() {
                                otpText = text.toString();
                              });
                              print("DONE CONTROLLER ${controller.text}");
                            },
                            pinBoxWidth: 50,
                            pinBoxHeight: 55,
                            hasUnderline: false,
                            wrapAlignment: WrapAlignment.spaceAround,
                            pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                            pinTextStyle: TextStyle(fontSize: 22.0),
                            pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                            pinBoxColor: Colors.white,
                            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                            pinBoxRadius: 10.0,
//                    highlightAnimation: true,
                            highlightAnimationBeginColor: Colors.black,
                            highlightAnimationEndColor: Colors.white12,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text.rich(
                            TextSpan(text: AppStrings.didntReceiveOtp, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0)), children: <InlineSpan>[
                              TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    print('_start value before ${_start}');
                                    if (_start <= 0) {
                                      print('_start value ${_start}');

                                      resendOtp();
                                    } else {
                                      ToastMessages.showToast(message: 'Please wait', type: false);
                                    }
                                  },
                                text: " " + AppStrings.requestAgain + " " + _start.toString(),
                                style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#0457BE'), letterSpacing: 0.0)),
                              )
                            ]),
                          )
                        ],
                      ))
                ],
              ),
            )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 2.4,
                    height: 52,
                    child: RaisedButton(
                        child: Text(
                          AppStrings.verify,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: color.colorConvert(color.primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        onPressed: () {
                          print("ACC ${accountType}");

                          if (otpText.toString().length > 0) {
                            verifyOtp();
                          } else {
                            ToastMessages.showToast(message: 'Please enter OTP', type: false);
                          }
                        }),
                  ),
                ))
          ],
        ),
      ),
    );
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
      _showNotification(map);
    },
        //onBackgroundMessage:myBackgroundHandler,
        onResume: (Map<String, dynamic> map) async {
      print("Notification r ${map.toString()}");
    });
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

  void verifyOtp() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = Database.getUserId();

    var obj = {'id': userId != null ? userId : user_id,
      'otp': otpText.toString(), "first_name": firstName,
      'last_name': lastName, 'fcm_token': "fcmToken", 'mobile_number': mNo, 'email': email, 'password': password, 'types': accountType};
    print("DDDDDDDDDD ${obj.toString()}");
    ApiHandler.postApi(ApiProvider.baseUrl,EndApi.verifyOtp, obj).then((value) {
      print("XXXXXXXXXXXXXXXXX ${value.toString()}");
      VerifyOtpModel verifyOtp;
      setState(() {
        verifyOtp = VerifyOtpModel.fromJson(value);
      });
      if (verifyOtp.statusCode == '200') {
        Box<String> appDb;
        appDb = Hive.box(ApiKeys.appDb);

        //appDb.put(ApiKeys.assignedCatList, result.categoryName);
        Database.setUserId(verifyOtp.result.id);
        appDb.put(ApiKeys.first_name, verifyOtp.result.firstName);
        appDb.put(ApiKeys.last_name, verifyOtp.result.firstName);
        appDb.put(ApiKeys.mobile_number, verifyOtp.result.mobileNumber);
        appDb.put(ApiKeys.email, verifyOtp.result.email);

        appDb.put(ApiKeys.type, verifyOtp.result.types);

        appDb = Hive.box(ApiKeys.appDb);
        appDb.put(Constants.logedInFlag, Constants.logedInFlag);

        accountType == "hire" ? Get.to(MoreAbout(accountType)) : Get.to(MoreAboutWorker(accountType));
      } else {
        ToastMessages.showToast(message: 'Invalid OTP', type: false);
      }
    });
  }

  void resendOtp() async {
    var map = {'mobile_number': mNo, 'user_id': user_id};
    print("DDDDDDD ${map.toString()}");

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.resendOt, map).then((value) {
      print("DDDDDDD ${value.toString()}");
      ToastMessages.showToast(message: 'Otp Sent Please Wait', type: true);

      setState(() {
        _start = 0;
      });
      startTimer();
      ToastMessages.showToast(message: 'Otp Sent Please Wait', type: true);
    });
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }
}
