import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/ChatPage.dart';
import 'package:one_roof/views/OrderPage.dart';
import 'package:one_roof/views/SubcategoryPage.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<dynamic> _categoryList = [];
  final List<String> catIdList = [];
  bool showLoader = true, hasRequestAvailable;
  String userType, firstname;
  List<dynamic> listWorkerOrders = [];
  List<dynamic> listAds = [];
  List<String> listImages = [];
//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  String fcmToken;
  bool isAssigned;
  List<String> assignedCategoryNameList = [];
  double dimens;
  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
    NotificationService.configureNotification();
    // initNotification();

    super.initState();
    getToken();

    getUserDetails();
    getAdvertises();
    loadData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    dimens = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: Column(
            children: [
              SizedBox(
                height: dimens >= 725 ? 15 : 10,
              ),
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 8,
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
                                'assets/images/app_icon.jpeg',
                                scale: 6,
                              ),
                            )),
                        Expanded(
                          flex: 5,
                          child: Text(AppStrings.appName, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700)),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(ChatPage());
                            },
                            child: SvgPicture.asset(
                              'assets/images/chatt icon.svg',
                              color: Colors.black38,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
      body: userType == Constants.hire
          ? SafeArea(
              child: showLoader != true
                  ? CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                        width: Get.size.width / 1.1,
                                        decoration: BoxDecoration(
                                            // color: color.colorConvert('#B3D88A'),
                                            borderRadius: BorderRadius.circular(14.0)),
                                        height: dimens >= 725 ? 130 : 110,
                                        child: getSlider()),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text(AppStrings.selectBelowCat, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w700, letterSpacing: 0.0)))],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(left: 12.0, right: 14.0),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8.0, crossAxisSpacing: 6.0),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (assignedCategoryNameList.toString().trim().contains(_categoryList[index][ApiKeys.categoryName].toString().trim())) {
                                      Get.to(SubcategoryPage(_categoryList[index][ApiKeys.id], _categoryList[index][ApiKeys.categoryName], true));
                                    } else {
                                      Get.to(SubcategoryPage(_categoryList[index][ApiKeys.id], _categoryList[index][ApiKeys.categoryName], false));
                                    }
                                  },
                                  child: Container(
                                    width: Get.size.width / 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Card(
                                      elevation: 2,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 6,
                                              child: Container(
                                                  child: Image.network(
                                                _categoryList[index]['image'],
                                                //scale:0.4,
                                                //fit: BoxFit.fill,
                                              ))),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                margin: EdgeInsets.only(left: 2, right: 3, bottom: 3),
                                                decoration: BoxDecoration(color: color.colorConvert(_categoryList[index]['color_code']).withOpacity(0.2), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                                                child: Center(
                                                  child: Container(
                                                      child: Text(_categoryList[index][ApiKeys.categoryName],
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: false,
                                                          style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert(_categoryList[index]['color_code']).withOpacity(1)), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: _categoryList.length,
                            ),
                          ),
                        )
                      ],
                    )
                  : displayLoader())
          : SafeArea(
              child: Container(
              width: Get.size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                                width: Get.size.width / 1.1,
                                decoration: BoxDecoration(
                                    // color: color.colorConvert('#B3D88A'),
                                    borderRadius: BorderRadius.circular(14.0)),
                                height: dimens >= 725 ? 130 : 110,
                                child: getSlider()),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      flex:dimens<700?4:6,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/Empty state.png',
                            scale: 0.8,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(firstname != null ? 'Hello ' + firstname : "", style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                        ],
                      )),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Text(AppStrings.relaxStr, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                        Text(AppStrings.getBackStr, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                        SizedBox(
                          height: 30,
                        ),
                        Text('OR', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                        SizedBox(
                          height: 30,
                        ),
                        Text(AppStrings.postingAdd, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                        Text(AppStrings.meanwhile, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                        SizedBox(
                          height: 24,
                        ),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width / 2.4,
                          height: 52,
                          child: RaisedButton(
                              child: Text(
                                listWorkerOrders != null ? 'Go to orders' : AppStrings.createAd,
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              color: color.colorConvert(color.primaryColor),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              onPressed: () {
                                if (listWorkerOrders != null) {
                                  Get.to(OrderPage());
                                }
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
    );
  }

  void loadData() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);

    setState(() {
      var cat = appDb.get(ApiKeys.assignedCatList);
      print("DATA LIST ${cat.toString()}");
      for (int i = 0; i < 1; i++) {
        assignedCategoryNameList.add(cat);
      }
      print("DATA LIST A ${assignedCategoryNameList.toString()}");
    });

    if (userType == Constants.hire) {
      ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.category).then((value) {
        Map<String, dynamic> mapData;
        List<dynamic> listRes;
        setState(() {
          mapData = value;
          listRes = mapData[ApiKeys.categoryList];
          print("DATA ${mapData.toString()}");
          print("DATA ${listRes.toString()}");
          _categoryList.clear();

          for (int i = 0; i < listRes.length; i++) {
            _categoryList.add(listRes[i]);
            catIdList.add(listRes[i][ApiKeys.id]);
          }
          showLoader = false;
          print("DATA _categoryList${_categoryList.toString()}");
          print("DATA d ${catIdList.toString()}");
        });
      });
    } else {
      Box<String> appDb;
      appDb = Hive.box(ApiKeys.appDb);
      String userId = appDb.get(ApiKeys.userId);
      var map = {'user_id': userId};
      ApiHandler.postApi(ApiProvider.baseUrl, EndApi.workerAssignedCat, map).then((value) {
        print("VALUE ${value.toString()}");

        setState(() {
          Map<String, dynamic> map = value;
          if (value.containsKey('result')) {
            listWorkerOrders = map['result'];
          }
          listWorkerOrders = map['result'];
        });
        print("VALUE list ${listWorkerOrders.length}");
      });
      setState(() {});
    }
  }

  displayLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    setState(() {
      firstname = appDb.get(ApiKeys.first_name);

      userType = appDb.get(ApiKeys.type);
    });
  }

  void getAdvertises() {
    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.addvertising).then((value) {
      print("RES BANNER ${value.toString()}");
      listAds = value['Category_list'];
      print("RES BANNER ${listAds.toString()}");

      for (int i = 0; i < listAds.length; i++) {
        listImages.add(listAds[i]['slider_image']);
      }
      print("IIIIIIIIIIIIIII ${listImages.toString()}");
    });
  }

  void initNotification() async {
   /* _firebaseMessaging.configure(onMessage: (Map<String, dynamic> map) async {
      debugPrint("Notification T ${map.toString()}", wrapWidth: 1024);

      // print("Notification ${map['notification']}");
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
    });*/
  }

  Future _showNotification(Map<String, dynamic> mesage) async {
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

  void getToken() async {
/*
    await _firebaseMessaging.getToken().then((value) async {
      setState(() {
        fcmToken = value;
      });
    });
*/
    print("fcmToken ${fcmToken}");
  }

  getSlider() {
    print("dimens ${dimens}");

    return CarouselSlider(
      //CarouselSlider  FOR HIRE
      options: CarouselOptions(
          height: 400.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
          pauseAutoPlayOnTouch: true,
          aspectRatio: 2.4,
          autoPlay: true,
          pageSnapping: false,
          autoPlayInterval: Duration(seconds: 3),
          viewportFraction: 6,
          autoPlayAnimationDuration: Duration(milliseconds: 100),
          enlargeCenterPage: false),
      items: listImages.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Stack(
                children: [
                  Image.network(
                    i,
                    width: Get.size.width,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 80,
                    right: 80,
                    top: 115,
                    child: Container(
                      //width:Get.size.width/4.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: listImages.map((e) {
                          int index = listImages.indexOf(e);
                          return Container(
                            height: 6,
                            margin: EdgeInsets.only(left: 8),
                            width: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index ? color.colorConvert(color.primaryColor) : Color.fromRGBO(0, 0, 0, 0.2),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
/*
Container(
width:Get.size.width/2.4,
child:Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children:listImages.map((e) {
int index=listImages.indexOf(e);
return Container(height:8,
width:8,
decoration:BoxDecoration(
shape:BoxShape.circle,
color:_current==index?Color.fromRGBO(0, 0, 0, 0.9)
    : Color.fromRGBO(0, 0, 0, 0.4),
),);
}).toList(),
),
),*/
