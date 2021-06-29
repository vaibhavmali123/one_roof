import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/models/WorkerSelector.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/ContractorDetails.dart';

class OrderDetails extends StatefulWidget {
  String srNo, status, projectName;

  OrderDetails(this.srNo, this.status, this.projectName);

  OrderDetailsState createState() => OrderDetailsState(srNo, status, projectName);
}

class OrderDetailsState extends State<OrderDetails> {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  String srNo, status;
  String firstname, lastName, email, mno, userType, projectName;
  OrderDetailsState(this.srNo, this.status, this.projectName);
  List<dynamic> list = [];
  List<dynamic> listSelection = [];
  bool showLoader = true;
  double constraintHeight;
  String isSelectedFlag, isRejectedFlag;

  String id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.configureNotification();

    initNotification();

    getUserDetails();
    userType == Constants.hire ? getHireOrderDetails() : getWorkOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    constraintHeight = MediaQuery.of(context).size.height;

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
                  elevation: 0.4,
                  title: Text(
                    'My Orders',
                    style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  centerTitle: true,
                  leading: GestureDetector(
                    child: Image.asset(
                      'assets/images/back_icon.png',
                      scale: 1.8,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  )),
            ],
          )),
      body: showLoader == false
          ? SingleChildScrollView(
              child: IntrinsicHeight(
                // height:constraintHeight<=725?Get.size.height+85:Get.size.height,
                // margin:EdgeInsets.only(left:14,right:14,top:15),
                child: Container(
                  margin: EdgeInsets.only(left: 14, right: 14, top: 15),
                  child: Column(
                    children: [
                      /*Expanded(
                  flex:2,
                  child:
                  getHeaderColumn()
              )*/
                      getHeaderColumn(),
                      SizedBox(
                        height: 10,
                      ),
                      userType == Constants.hire
                          ? Container(
                              height: list != null ? list.length * 75.toDouble() : 10,
                              child: getContactList(),
                            )
                          : Container(
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 55,
                                      margin: EdgeInsets.only(top: 20),
                                      width: Get.size.width / 1.2,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.0), border: Border.all(width: 1, color: Colors.black45)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: Container(
                                                width: 90,
                                                child: Center(
                                                  child: Text(
                                                    list[0]['name'],
                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: color.colorConvert('#6B6977')),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(14.0), bottomRight: Radius.circular(14.0)),
                                                    color: color.colorConvert('#0457BE'),
                                                  ),
                                                  child: Center(
                                                    child: Text('Contact', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                                                  )))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  print("NAME ${list[0]['name']}");
                                  Get.to(WorkerDetails(
                                    workerId: list[0]['id'],
                                    srNo: list[0]['sr_no'],
                                    name: list[0]['name'],
                                    email: list[0]['email'],
                                    mno: list[0]['mobile_number'],
                                  ));
                                },
                              ),
                            ),
                      SizedBox(
                        height: 25,
                      ),
                      userType == Constants.hire ? getForgetColumn() : Container(),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: list != null ? list.length * 70.toDouble() : 10,
                        child: userType == Constants.hire ? getSelectionList() : Container(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(flex: 1, child: userType == Constants.hire ? getBottomColumn() : Container()),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : displayLoader(),
    );
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    firstname = appDb.get(ApiKeys.first_name);
    lastName = appDb.get(ApiKeys.last_name);
    userType = appDb.get(ApiKeys.type);
  }

  void getHireOrderDetails() {
    var map = {"sr_no": srNo};
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.assignedWork, map).then((value) {
      print("RES ${value.toString()}");
      setState(() {
        showLoader = false;
        list = value['result'];
      });
      for (int i = 0; i < list.length; i++) {
        listSelection.add(WorkerSelector<String>("item $i"));
        if (list[i]['complete_with'] == '1') {
          listSelection[i].isSelected = true;
        } else {
          listSelection[i].isSelected = false;
        }
      }
      print("RES LIST ${list.toString()}");
    });
  }

  getContactList() {
    return list != null
        ? ListView.builder(
            itemCount: list.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 55,
                      margin: EdgeInsets.only(top: 20),
                      width: Get.size.width / 1.2,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.0), border: Border.all(width: 1, color: Colors.black45)),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Container(
                                width: 90,
                                child: Center(
                                  child: Text(
                                    list[index]['assigned_work_user_name'],
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: color.colorConvert('#6B6977')),
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(14.0), bottomRight: Radius.circular(14.0)),
                                    color: color.colorConvert('#0457BE'),
                                  ),
                                  child: Center(
                                    child: Text('Contact', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                                  )))
                        ],
                      ),
                    )
                  ],
                ),
                onTap: () {
                  if (userType == Constants.hire) {
                    //updateStatus();
                  }
                  print("UUUUUUUUUUUUUUUUUUUUUUUUU ${list[index]['assign_to_user_id']}");
                  Get.to(WorkerDetails(
                    workerId: list[index]['assign_to_user_id'],
                    srNo: srNo,
                  ));
                },
              );
            },
          )
        : Container();
  }

  getForgetColumn() {
    return list != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t forget to update your status.',
                    style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' Select from the below options to update',
                    style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }

  getSelectionList() {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: list != null
          ? ListView.builder(
              itemCount: list.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 95,
                            child: Text(
                              list[index]['assigned_work_user_name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: color.colorConvert('#6B6977')),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 100,
                              height: 38,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(width: 1.4, color: listSelection[index].isSelected == false && list[index]['complete_with'] != '2' ? color.colorConvert(color.primaryColor) : Colors.black45)),
                              child: Center(
                                child: Text('Rejected', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: listSelection[index].isSelected == false && list[index]['complete_with'] != '2' ? color.colorConvert(color.primaryColor) : Colors.black45)),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                rejectConfirmDialog(index);
                              });
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: 100,
                              height: 38,
                              child: Center(
                                child: Text('Selected', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: listSelection[index].isSelected == false ? Colors.black45 : color.colorConvert(color.primaryColor))),
                              ),
                              decoration: BoxDecoration(
                                  //color:listSelection[index].isSelected==false?Colors.red:Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(width: 1.4, color: listSelection[index].isSelected == false ? Colors.black45 : color.colorConvert(color.primaryColor))),
                            ),
                            onTap: () {
                              setState(() {
                                isSelectedFlag = '1';
                                isRejectedFlag = "0";
                                listSelection[index].isSelected == false ? listSelection[index].isSelected = true : listSelection[index].isSelected = false;
                                showDialogBox(index);
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: Get.size.width - 70,
                        height: 1,
                        color: Colors.black12,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                );
              },
            )
          : Container(),
    );
  }

  getBottomColumn() {
    return list != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not satisfied?',
                    style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Request admin to share more vendor',
                    style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                  ),
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 160,
                    child: list != null
                        ? RaisedButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: color.colorConvert(color.primaryColor),
                            child: Text(
                              'Request Admin',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(),
                  )
                ],
              )
            ],
          )
        : Container();
  }

  getHeaderColumn() {
    return Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  firstname != null ? "Hello  " + firstname : "Hello",
                  style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#0D082B'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(text: 'SR no. ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54), children: <InlineSpan>[
                    TextSpan(
                      text: srNo,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87),
                    )
                  ]),
                ),
                Text(
                  status == '1'
                      ? 'In Progress'
                      : status == '3'
                          ? 'Open'
                          : 'Completed',
                  style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#EBA729'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  'Job Description',
                  style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  userType == 'hire' ? 'Here are some vendors for your ' + projectName + ' project.' : 'You got an enquiry/ oroer/lead from ' + projectName + ' project',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w700, letterSpacing: 0.0)),
                )),
              ],
            ),
          ],
        ));
  }

  void showDialogBox(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Vendor Selected"),
            content: Text("Do you want to select vendor"),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Yes',
                  style: TextStyle(color: color.colorConvert(color.primaryColor)),
                ),
                onPressed: () {
                  setState(() {
                    isSelectedFlag = '1';
                    id = list[index]['assign_to_user_id'];
                  });
                  addSelectedApi();
                  userType == Constants.hire ? getHireOrderDetails() : getWorkOrderDetails();
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('No', style: TextStyle(color: color.colorConvert(color.primaryColor))),
                onPressed: () {
                  userType == Constants.hire ? getHireOrderDetails() : getWorkOrderDetails();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void addSelectedApi() {
    List<String> idList = [];
    //listSelection[index].isSelected==false
    for (int i = 0; i < list.length; i++) {
      if (listSelection[i].isSelected == true) {
        idList.add(list[i]['assign_to_user_id']);
      }
    }

    var map = {'sr_no': srNo, 'is_selected': isSelectedFlag, 'worker_id': id};
    print("REQUEST ${map.toString()}");
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.selectWorker, map).then((value) {
      if (value['Status_code'] == "200" || value['Status_code'] == "201") {
        userType == Constants.hire ? getHireOrderDetails() : getWorkOrderDetails();

        ToastMessages.showToast(message: 'Updated successfully', type: true);
      } else {
        ToastMessages.showToast(message: 'Not Updated successfully', type: false);
      }
    });
  }

  displayLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  getWorkOrderDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);
    var map = {"sr_no": srNo, 'user_id': userId};
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.singleRequestWorker, map).then((value) {
      print("RES ${value.toString()}");
      setState(() {
        showLoader = false;
        list = value['result'];
      });
      for (int i = 0; i < list.length; i++) {
        listSelection.add(WorkerSelector<String>("item $i"));
        if (list[i]['status'] == '1') {
          listSelection[i].isSelected = true;
        } else {
          listSelection[i].isSelected = false;
        }
      }
      print("RES LIST ${list.toString()}");
    });
  }

  void initNotification() async {
    /*_firebaseMessaging.configure(onMessage: (Map<String, dynamic> map) async {
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
    });*/
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

  void rejectConfirmDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Vendor Rejection"),
            content: Text("Do you want to reject vendor"),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Yes',
                  style: TextStyle(color: color.colorConvert(color.primaryColor)),
                ),
                onPressed: () {
                  setState(() {
                    isSelectedFlag = '0';
                    id = list[index]['assign_to_user_id'];
                    addSelectedApi();
                    userType == Constants.hire ? getHireOrderDetails() : getWorkOrderDetails();
                    //  listSelection[index].isSelected == true ? listSelection[index].isSelected = false : listSelection[index].isSelected = true;
                    Get.back();
                  });
                  userType == Constants.hire ? getHireOrderDetails() : getWorkOrderDetails();
                  setState(() {
                    userType == Constants.hire ? getHireOrderDetails() : getWorkOrderDetails();
                  });
                },
              ),
              CupertinoDialogAction(
                child: Text('No', style: TextStyle(color: color.colorConvert(color.primaryColor))),
                onPressed: () {
                  setState(() {
                    id = list[index]['assign_to_user_id'];
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
