import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/blocs/NotificationsBloc.dart';
import 'package:one_roof/models/NotificationsModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/repository/Repository.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/OrderPage.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  var showLoader = false;
  List<Result> notificationsList = [];
  NotificationsBloc notificationsBloc = NotificationsBloc();
  NotificationRepo notificationRepo = NotificationRepo();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNotifications();
    showLoader = true;

    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);

    appDb.put(ApiKeys.fromNotification, "false");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    title: Text(AppStrings.notifications, style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
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
        body: Container(
          height: Get.size.height,
          width: Get.size.width,
          child: showLoader == false
              ? notificationsList.length != 0
                  ? Container(
                      child: ListView.builder(
                          itemCount: notificationsList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map = json.decode(notificationsList[index].notification);
                            print("XXXXXXXXXXXXXXXXXXX${notificationsList[index].type}");
                            return GestureDetector(
                              onTap: () {
                                if (notificationsList[index].type != 'login') {
                                  Get.to(OrderPage());
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    width: Get.size.width,
                                    height: 90,
                                    child: Container(
                                      height: 90,
                                      width: Get.size.width,
                                      color: color.colorConvert('#EBF2FA').withOpacity(1),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            height: 46,
                                            width: 46,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                            child: Center(
                                              child: Image.asset(getIcon(index)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    map['title'],
                                                    style: TextStyle(fontSize: 13, color: Colors.black87.withOpacity(0.8), fontWeight: FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    map['body'],
                                                    style: TextStyle(fontSize: 13, color: Colors.black87.withOpacity(0.7), fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              )),
                                          Expanded(flex: 2, child: notificationsList[index].date != null ? Text(notificationsList[index].date, style: TextStyle(fontSize: 12, color: Colors.black87.withOpacity(0.7), fontWeight: FontWeight.w500)) : Container())
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }))
                  : Center(
                      child: Text("You dont have notifications"),
                    )
              : Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ));
  }

  void loadNotifications() async {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);
    var map = {
      'user_id': userId,
    };

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.notification, map).then((value) {
      print("RESp ${value.toString()}");
      setState(() {
        showLoader = false;
      });
      if (value['Status_code'] == '200') {
        showLoader = false;
        print("RES ${value.toString()}");
        setState(() {
          notificationsList = NotificationsModel.fromJson(value).result.toList();
          showLoader = false;
        });
      }
    });
  }

  String getIcon(int index) {
    switch (notificationsList[index].type) {
      case 'login':
        return 'assets/images/Icon material-thumb-up.png';
        break;
      case 'signup':
        return 'assets/images/Icon material-thumb-up.png';
        break;
      case 'order':
        return 'assets/images/Icon awesome-ticket-alt.png';
        break;
      case 'service_access':
        return 'assets/images/contact admin_icon.png';
        break;
      case 'order_select':
        return 'assets/images/Congrats_icon.png';
        break;
      case 'order_assigned':
        return 'assets/images/Congrats_icon.png';
        break;
      case 'order_processed':
        return 'assets/images/process successfully_icon.png';
        break;
      default:
        return 'assets/images/process successfully_icon.png';
    }
  }
}
