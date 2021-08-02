import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';

class FeedbackPage extends StatefulWidget {
  String srNo;

  FeedbackPage(this.srNo);

  FeedbackPageState createState() => FeedbackPageState(srNo);
}

class FeedbackPageState extends State<FeedbackPage> {
  List<String> listFeedback = ['Communication', 'Work Details', 'Co-ordination', 'Job Skills', 'Support'];
  String srNo;

  FeedbackPageState(this.srNo);

  List<String> ratingList = new List(5);
  Map<String, dynamic> mapRatingObj = {};
  int totalRating = 0;
  String firstname;
  double constraintsWidth, constraintHeight;
  final comentEditingCtrl = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.configureNotification();
    getFeedbackName();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    constraintsWidth = Get.size.width;
    constraintHeight = MediaQuery.of(context).size.height;
    print("height ${constraintHeight}");
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  actions: [
                    Container(
                      width: Get.size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                  'assets/images/back_icon.png',
                                  scale: 1.8,
                                ),
                              )),
                          Expanded(
                              flex: 5,
                              child: Container(
                                child: Text('Feedback Form', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert('#343048'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                              )),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: constraintHeight > 725 ? Get.size.height + 30 : Get.size.height + 80,
              width: Get.size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: constraintHeight <= 725 ? 4 : 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text('Hello' + firstname, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#343048'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Image.asset(
                            'assets/images/feedback_graphic.png',
                            scale: 1,
                          ),
                          Text('Tell us about your experience with', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#343048').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                          Text('the agency', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#343048').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: listFeedback.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 55,
                              margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white, boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: const Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 0.2,
                                  spreadRadius: 0.1,
                                )
                              ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(listFeedback[index], style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#343048').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: RatingBar.builder(
                                      initialRating: 1,
                                      minRating: 1,
                                      itemSize: constraintHeight > 725
                                          ? 28
                                          : constraintHeight < 720
                                              ? 26
                                              : 30,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        size: 5,
                                        color: Colors.orangeAccent,
                                      ),
                                      onRatingUpdate: (rating) {
                                        int tempRating = rating.round();
                                        print("rating ${listFeedback.toString()} ${index}");

                                        mapRatingObj[listFeedback[index]] = tempRating.toString();

                                        ratingList[index] = tempRating.toString();
                                        print("rating ${rating} ${mapRatingObj}");
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          })),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            width: Get.size.width / 1.1,
                            child: TextField(
                              controller: comentEditingCtrl,
                              keyboardType: TextInputType.text,
                              showCursor: true,
                              cursorWidth: 2,
                              maxLines: 4,
                              autofocus: false,
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                isDense: true,
                                hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                                hintText: "Type your comments here…",
                                errorStyle: TextStyle(height: 0),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
                              ),
                              //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width / 2.4,
                            height: 55,
                            child: RaisedButton(
                                child: Text(
                                  AppStrings.submit,
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                color: color.colorConvert(color.primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                onPressed: () {
                                  totalRating = 0;
                                  for (int i = 0; i < ratingList.length; i++) {
                                    if (ratingList[i] != null) {
                                      totalRating = int.parse(ratingList[i]) + totalRating;
                                    } else {
                                      totalRating = totalRating + 1;
                                    }
                                  }
                                  print("totalRating ${totalRating}");

                                  List<dynamic> feedbackList = [];

                                  Box<String> appDb;
                                  appDb = Hive.box(ApiKeys.appDb);
                                  String userId = appDb.get(ApiKeys.userId);
                                  String userType = appDb.get(ApiKeys.type);

                                  print("RESPONSE feedbackList ${userType}");

                                  if (userType == 'work') {
                                    print("RESPONSE feedbackList ${feedbackList}");
                                    var map = {'sr_no': srNo, 'user_id': userId, 'worker_feedback_comments': comentEditingCtrl.text.toString(), 'worker_feedback': totalRating.toString()};

                                    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.workerFeedback, json.encode(map)).then((value) {
                                      print("RESPONSE worker ${value['result']}");
                                      if (value['result'] == true) {
                                        ToastMessages.showToast(message: 'Feedback updated', type: true);
                                        Get.back();
                                      } else {
                                        ToastMessages.showToast(message: 'Feedback not updated', type: false);
                                      }
                                    });
                                  } else {
                                    print("RESPONSE feedbackList ${feedbackList}");
                                    var map = {'sr_no': srNo, 'feedback_comments': comentEditingCtrl.text.toString(), 'feedback_rating': json.encode(mapRatingObj)};
                                    print("REQUEST ${map.toString()}");

                                    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.feedback, json.encode(map)).then((value) {
                                      print("RESPONSE ${value['result']}");
                                      if (value['result'] == true) {
                                        ToastMessages.showToast(message: 'Feedback updated', type: true);
                                        Get.back();
                                      } else {
                                        ToastMessages.showToast(message: 'Feedback not updated', type: false);
                                      }
                                    });
                                  }
                                }),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    firstname = appDb.get(ApiKeys.first_name);
  }

  String getFeedbackName() {
    //listFeedback[index]
//    return listFeedback[index].substring(0,2);
    String initialLetters = srNo.substring(0, 2);
    switch (initialLetters) {
      case 'CT':
        break;
      case 'CR':
        listFeedback.clear();
        setState(() {
          listFeedback = [
            'Communication',
            'Work Quality',
            'House keeping',
            'Safty Awareness',
            'Work Speed',
          ];
        });
        break;
      case 'CM':
        listFeedback.clear();
        setState(() {
          listFeedback = [
            'Communication',
            'Material Quality',
            'Timely Delivery',
            'Value for Money',
            'Support',
          ];
        });

        break;
      case 'ME':
        listFeedback.clear();
        setState(() {
          listFeedback = [
            'Communication',
            'Work Quality',
            'Punctuality',
            'Safety Awareness',
            'Work Speed',
          ];
        });
        break;
      case 'PV':
        listFeedback.clear();
        setState(() {
          listFeedback = [
            'Communication',
            'Product Quality',
            'Timely Delivery',
            'Value for Money',
            'Support',
          ];
        });

        break;
      case 'MS':
        break;
      case 'HM':
        break;
      case 'PM':
        break;
    }
  }
}
