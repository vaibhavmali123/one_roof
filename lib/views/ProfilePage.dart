import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/main.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/EditProfile.dart';
import 'package:one_roof/views/FaqScreen.dart';
import 'package:one_roof/views/LoginScreen.dart';
import 'package:one_roof/views/OrderPage.dart';
import 'package:one_roof/views/PaymentScreen.dart';
import 'package:one_roof/views/PostAnAdvertise.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';

class ProfilePage extends StatefulWidget {
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String firstname, lastName, email, mno, address;
  List<String> listTitles = [AppStrings.postAdvertisement, AppStrings.myOrders, AppStrings.payment, AppStrings.giveFeedback, AppStrings.faqs, AppStrings.rate, AppStrings.logOut];

  List<String> listIcons = ['assets/images/Icon-ad.png', 'assets/images/Icon-my orders.png', 'assets/images/Icon-payment.png', 'assets/images/Icon-feedback.png', 'assets/images/Icon ionic-md-help-circle.png', 'assets/images/Icon awesome-star.png', 'assets/images/Icon open-account-logout.png'];
  final TextEditingController textEditingControllerFeedback = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.configureNotification();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    double dimens = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(dimens > 725 ? 75 : 58),
          child: Column(
            children: [
              /*SizedBox(
                height: 15,
              ),*/
              AppBar(
                backgroundColor: Colors.white,
                elevation: 2,
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: [
                  Container(
                    width: Get.size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          flex: 8,
                          child: Text('Profile', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700)),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                color: Colors.black87,
                                size: 23,
                              ),
                              onPressed: () {
                                Share.share('https://play.google.com/store/apps/details?id=com.construction.oneroof');
                                //showSearch(context: context, delegate:SearchSubCategories());
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
      body: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                /*height: dimens >= 725 ? address!=null?dimens / 4:dimens/5 : dimens / 4,*/
                width: Get.size.width / 1.1,
                decoration: BoxDecoration(color: color.colorConvert('EBF2FA').withOpacity(1), borderRadius: BorderRadius.circular(14.0)),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Image.asset(
                                'assets/images/profile pic.png',
                                scale: 1,
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(firstname != null && lastName != null ? firstname + " " + lastName : "",
                                            overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert('#343048'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(mno != null ? mno : "", overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(email != null ? email : " ", overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Route route = MaterialPageRoute(builder: (context) => EditProfile());
                                      Navigator.push(context, route).then((onGoBack));
                                      //  Get.to(EditProfile());
                                    },
                                    child: Container(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 14, color: color.colorConvert(color.primaryColor), fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                  )
                                ],
                              ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          Container(
                            width: Get.size.width / 1.4,
                            child:
                                Text(address != null ? 'Address:  ' + address : "", overflow: TextOverflow.ellipsis, softWrap: false, maxLines: 2, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            height: dimens <= 725 ? 330 : dimens / 2,
            child: ListView.builder(
                itemCount: listTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      navigate(index);
                    },
                    leading: Image.asset(listIcons[index]),
                    title: Text(listTitles[index], style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#343048').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                    trailing: Image.asset('assets/images/next.png'),
                  );
                })
            /*Container(
                height:327,
                margin:EdgeInsets.only(left:12,right:12,top:12),
                child:Column(
                  children: [
                    ListTile(
                      leading:Image.asset('assets/images/Icon-ad.png'),
                      title:Text(AppStrings.postAdvertisement,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize:15,
                                  color:color.colorConvert('#343048').withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0))),
                      trailing:Image.asset('assets/images/next.png'),
                    ),
                    SizedBox(height:0,),
                    ListTile(
                      onTap:(){
                        Get.to(OrderPage());
                      },
                      leading:Image.asset('assets/images/Icon-my orders.png'),
                      title:Text(AppStrings.myOrders,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize:15,
                                  color:color.colorConvert('#343048').withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0))),
                      trailing:Image.asset('assets/images/next.png'),
                    ),
                    SizedBox(height:0,),

                    ListTile(
                      leading:Image.asset('assets/images/Icon-payment.png'),
                      title:Text(AppStrings.payment,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize:15,
                                  color:color.colorConvert('#343048').withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0))),
                      trailing:Image.asset('assets/images/next.png'),
                    ),
                    ListTile(
                      leading:Image.asset('assets/images/Icon-feedback.png'),
                      title:Text(AppStrings.giveFeedback,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize:15,
                                  color:color.colorConvert('#343048').withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0))),
                      trailing:Image.asset('assets/images/next.png'),
                    ),
                    SizedBox(height:0,),

                    ListTile(
                      leading:Image.asset('assets/images/Icon ionic-md-help-circle.png'),
                      title:Text(AppStrings.faqs,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize:15,
                                  color:color.colorConvert('#343048').withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0))),
                      trailing:Image.asset('assets/images/next.png'),
                    ),
                    SizedBox(height:0,),

                    ListTile(
                      leading:Image.asset('assets/images/Icon awesome-star.png'),
                      title:Text(AppStrings.rate,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize:14,
                                  color:color.colorConvert('#343048').withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0))),
                      trailing:Image.asset('assets/images/next.png'),
                    ),
                    SizedBox(height:0,),

                    ListTile(
                      onTap:(){
                        logout();
                      },
                      leading:Image.asset('assets/images/Icon open-account-logout.png'),
                      title:Text(AppStrings.logOut,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize:14,
                                  color:color.colorConvert('#343048').withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.0))),
                      trailing:Image.asset('assets/images/next.png'),
                    ),

                  ],
                ),
              )*/
            ,
          )
        ],
      )),
    );
  }

  void logout() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    appDb.compact();
    appDb.clear();
    currentIndex = 0;
    Get.offAll(LoginScreen());
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    firstname = appDb.get(ApiKeys.first_name);
    lastName = appDb.get(ApiKeys.last_name);
    mno = appDb.get(ApiKeys.mobile_number);
    email = appDb.get(ApiKeys.email);
    address = appDb.get(ApiKeys.address);
    print("DATA ${email}");
  }

  void navigate(int index) {
    switch (index) {
      case 0:
        Get.to(PostAnAdvertise());
        break;
      case 1:
        Get.to(OrderPage());
        break;
      case 2:
        Get.to(PaymentScreen());
        break;
      case 3:
        displayFeedbackDialog();
        break;
      case 6:
        showDialogBox();
        break;
      case 4:
        Get.to(FaqScreen());
        break;
      case 5:
        StoreRedirect.redirect(androidAppId: "com.construction.oneroof");
        break;
    }
  }

  Future onGoBack(dynamic value) {
    getUserDetails();
    setState(() {});
  }

  void showDialogBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Logout"),
            content: Text("Do you want to logout"),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'Yes',
                  style: TextStyle(color: color.colorConvert(color.primaryColor)),
                ),
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                  logout();
                },
              ),
              CupertinoDialogAction(
                child: Text('No', style: TextStyle(color: color.colorConvert(color.primaryColor))),
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void displayFeedbackDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Container(
            width: Get.size.width,
            height: Get.size.height / 2.8,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text('Give us feedback', style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w800)),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: Get.size.width / 1.3,
                      height: 55,
                      child: TextFormField(
                        controller: textEditingControllerFeedback,
                        maxLines: 3,
                        decoration: InputDecoration(hintText: 'Type Feedback', focusedBorder: fieldBorder, enabledBorder: fieldBorder, border: fieldBorder),
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.size.width / 3,
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              Get.back();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: color.colorConvert(color.primaryColor),
                            child: Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                        ),
                        SizedBox(
                          width: Get.size.width / 3,
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              postFeedback();
                              Get.back();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: color.colorConvert(color.primaryColor),
                            child: Text('Submit', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                        )
                      ],
                    )),
                /*Expanded(
                  flex:1,child:Container(),
                )*/
              ],
            ),
          ),
        );
      },
    );
  }

  var fieldBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(width: 1, color: Colors.black87));

  void postFeedback() {
    print("value ${textEditingControllerFeedback.text.toString()}");

    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);

    var map = {'user_id': userId, 'feedback': textEditingControllerFeedback.text.toString()};
    textEditingControllerFeedback.clear();

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.appFeedback, map).then((value) {
      print("value ${value}");
      textEditingControllerFeedback.clear();
      ToastMessages.showToast(message: 'Feedback updated successfuly');
    });
  }
}
