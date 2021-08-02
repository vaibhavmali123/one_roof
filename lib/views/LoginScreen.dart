import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/blocs/DeviceTypeBloc.dart';
import 'package:one_roof/blocs/bloc.dart';
import 'package:one_roof/models/LoginModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/Database.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/AccountSelection.dart';
import 'package:one_roof/views/BottomNavigationScreen.dart';
import 'package:one_roof/views/ForgotPasswordScreen.dart';
import 'package:one_roof/views/MoreAbout.dart';
import 'package:one_roof/views/MoreAboutWorker.dart';
import 'package:one_roof/views/OtpScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bloc block;
  DeviceTypeBloc deviceTypeBloc;
  TextEditingController mobileController;
  TextEditingController passwordController;
  FirebaseMessaging _firebaseMessaging;
  String fcmToken;
  List<String> assignedCategoryNameList = [];

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging();

    getToken();

    super.initState();
    initControllers();
    deviceTypeBloc = DeviceTypeBloc();
    _firebaseMessaging.getToken().then((value) {});
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    block = bloc();
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
                    title: Text("Welcome back!", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
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
          child: SingleChildScrollView(
            child: Container(
              child: StreamBuilder<String>(
                stream: deviceTypeBloc.deviceType,
                builder: (context, snapshot) => Column(
                  children: [
                    SizedBox(
                      height: snapshot.data != AppStrings.sdpi ? 0 : 40,
                    ),
                    Column(
                      children: [
                        getImage(),
                        getForm(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget getImage() {
    double constraints = MediaQuery.of(context).size.height;

    return Image.asset(
      'assets/images/buildings_image.png',
      height: constraints >= 800 ? 300 : 200,
      width: Get.size.width,
      scale: 0.8,
    );
  }

  Widget getForm() {
    return Container(
      width: Get.size.width - 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Mobile Number', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.bold, letterSpacing: 0.0))),
            ],
          ),
          StreamBuilder<String>(
              stream: block.email,
              builder: (context, snapshot) => TextFormField(
                    autofocus: false,
                    controller: mobileController,
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    cursorHeight: 24,
                    onChanged: block.emailController.sink.add,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                        isDense: false,
                        helperStyle: TextStyle(fontSize: 0),
                        contentPadding: EdgeInsets.only(bottom: 0, top: 15, left: 0),
                        prefixIconConstraints: BoxConstraints(maxHeight: 8, minHeight: 4, minWidth: 30, maxWidth: 40),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: Colors.black54,
                          size: 24,
                        ),
                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                  )),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Password', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.bold, letterSpacing: 0.0))),
            ],
          ),
          StreamBuilder<String>(
              stream: block.password,
              builder: (context, snapshot) => TextFormField(
                    cursorHeight: 24,
                    controller: passwordController,
                    autofocus: false,
                    onChanged: block.passwordController.sink.add,
                    obscureText: isVisible == true ? true : false,
                    //onChanged:block.passwordChanged,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        errorText: snapshot.error,
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                        isDense: true,
                        contentPadding: EdgeInsets.only(bottom: 0, top: 18, left: 0),
                        prefixIconConstraints: BoxConstraints(maxHeight: 8, minHeight: 4, minWidth: 30, maxWidth: 40),
                        suffixIcon: IconButton(
                            icon: Icon(isVisible == false ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isVisible == true ? isVisible = false : isVisible = true;
                              });
                            }),
                        prefixIcon: Icon(
                          Icons.lock_open_outlined,
                          color: Colors.black54,
                          size: 24,
                        ),
                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                  )),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(ForgotPasswordScreen());
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 16, color: color.colorConvert('#0457BE'), fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: StreamBuilder<bool>(
                stream: block.submitCheck,
                builder: (context, AsyncSnapshot<bool> snapshot) => RaisedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    color: color.colorConvert(color.primaryColor),
                    /*color:snapshot.hasError==false?color.colorConvert(color.primaryColor):Colors.black12,*/
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    onPressed: () {
                      var objRequest = {"mobile_number": mobileController.value.text, 'fcm_token': "fcmToken", "password": passwordController.value.text};
                      print('RES MAP ${objRequest.toString()}');
                      ApiHandler.postApi(ApiProvider.baseUrl, EndApi.login, objRequest).then((value) {
                        LoginModel loginModel = LoginModel();
                        Result result = Result();
                        Map<String, dynamic> mapData;
                        setState(() {
                          loginModel = LoginModel.fromJson(value);
                          result = LoginModel.fromJson(value).result;
                        });
                        print('MMMMMMMMM${loginModel.result.swithchedRole}');
                        if (loginModel.statusCode == "200") {
                          saveAndNavigate(result);
                        } else {
                          ToastMessages.showToast(message: 'Wrong mobile number or password', type: false);
                        }
                      });
                    }),
              )),
          Container(
            height: 28,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(TextSpan(text: 'Don’t have an account? ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54), children: <InlineSpan>[
                TextSpan(
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      print('Terms and Conditions Single Tap');
                      Get.to(AccountSelection());
                    },
                  text: 'Create account',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color.colorConvert('#0457BE')),
                )
              ])),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  void initControllers() {
    mobileController = TextEditingController();
    passwordController = TextEditingController();
  }

  void getToken() async {
    await _firebaseMessaging.getToken().then((value) async {
      setState(() {
        fcmToken = value;
      });
    });
    print("fcmToken ${fcmToken}");
  }

  void saveAndNavigate(Result result) {
    Box<String> appDb;

    setState(() {});
    if (result.verification != '0') {
      appDb = Hive.box(ApiKeys.appDb);
      appDb.put(ApiKeys.assignedCatList, result.categoryName);
      Database.setUserId(result.userId);
      appDb.put(ApiKeys.first_name, result.firstName);
      appDb.put(ApiKeys.last_name, result.lastName);
      appDb.put(ApiKeys.mobile_number, result.mobileNumber);
      appDb.put(ApiKeys.email, result.email);
      appDb.put(ApiKeys.switchedRole, result.swithchedRole);
      print('RES userId ${result.categoryName}');

      appDb.put(ApiKeys.type, result.types);

      appDb = Hive.box(ApiKeys.appDb);
      appDb.put(Constants.logedInFlag, Constants.logedInFlag);

      if (result.types == 'hire') {
        if (result.hireDesignation == null) {
          Get.to(MoreAbout('hire'));
        } else {
          Get.offAll(BottomNavigationScreen());
        }
      } else if (result.types == 'work') {
        if (result.profileIncomplete == "true") {
          Get.to(MoreAboutWorker('work'));
        } else {
          Get.offAll(BottomNavigationScreen());
        }
      }
    } else {
      Get.to(OtpScreen(
        accountType: result.types,
        mNo: result.mobileNumber,
        user_id: result.userId,
      ));
    }
  }
}
