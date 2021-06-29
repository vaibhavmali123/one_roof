import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/blocs/BlocValidation.dart';
import 'package:one_roof/models/SignupModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Database.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/LoginScreen.dart';
import 'package:one_roof/views/OtpScreen.dart';

class CreateAccount extends StatefulWidget {
  String acountType;

  CreateAccount(this.acountType);

  CreateAccountState createState() => CreateAccountState(acountType);
}

class CreateAccountState extends State<CreateAccount> {
  final String acountType;

  var showvalue = false;
  BlocValidation blocValidation;
  TextEditingController fNameController;
  TextEditingController lNameController;
  TextEditingController mnoController;
  TextEditingController emailController;
  String userId;
  TextEditingController passwordController;
  bool isFnameValid = true, isLnameValid = true, isMnoValid = true, isEmailValid = true, isPasswordValid = true;
  bool isVisible = true;
  FirebaseMessaging _firebaseMessaging;
  String fcmToken;

  CreateAccountState(this.acountType);

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging();
    // TODO: implement initState
    getToken();

    super.initState();
    initControllers();
    blocValidation = BlocValidation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Image.asset(
                          'assets/images/back_icon.png',
                          scale: 1.8,
                        ),
                        onTap: () {
                          Get.back();
                        },
                      )),
                  Expanded(flex: 2, child: Container()),
                  Expanded(flex: 3, child: Text("Create Account", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w900))),
                  Expanded(flex: 2, child: Container())
                ],
              ),
              SizedBox(
                height: 40,
              ),
              getForm(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget getForm() {
    return Container(
      width: Get.size.width - 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('First Name'),
            ],
          ),
          StreamBuilder<String>(
              stream: blocValidation.fNameStream,
              builder: (context, snapshot) {
                print("DATA s ${snapshot.data}");

                return TextFormField(
                  autofocus: false,
                  controller: fNameController,
                  cursorHeight: 24,
                  decoration: InputDecoration(
                      // errorText:isFnameValid==false,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                      isDense: false,
                      contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                      prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                      prefixIcon: Image.asset('assets/images/Icon feather-user.png'),
                      focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                );
              }),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Last Name'),
            ],
          ),
          StreamBuilder<String>(
              // stream:block.password,
              builder: (context, snapshot) => TextFormField(
                    cursorHeight: 24,
                    controller: lNameController,
                    autofocus: false,
                    //onChanged:block.passwordChanged,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        errorText: snapshot.error,
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                        isDense: true,
                        contentPadding: EdgeInsets.only(bottom: 6, top: 14, left: 30),
                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                        prefixIcon: Image.asset('assets/images/Icon feather-user.png'),
                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                  )),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Mobile Number'),
            ],
          ),
          StreamBuilder<String>(
              //stream:block.email,
              builder: (context, snapshot) => TextFormField(
                    autofocus: false,
                    maxLength: 10,

                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    controller: mnoController,
                    cursorHeight: 24,
                    // onChanged:block.emailChanged,
                    decoration: InputDecoration(
                        errorText: snapshot.error,
                        helperStyle: TextStyle(fontSize: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                        isDense: false,
                        contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                        prefixIcon: Image.asset('assets/images/Icon_feather_phone_call.png'),
                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                  )),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Email'),
            ],
          ),
          StreamBuilder<String>(
              //stream:block.email,
              builder: (context, snapshot) => TextFormField(
                    autofocus: false,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorHeight: 24,
                    // onChanged:block.emailChanged,
                    decoration: InputDecoration(
                        errorText: snapshot.error,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                        isDense: false,
                        contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black54,
                          size: 24,
                        ),
                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                  )),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Password'),
            ],
          ),
          StreamBuilder<String>(
              //stream:block.email,
              builder: (context, snapshot) => TextFormField(
                    autofocus: false,
                    obscureText: isVisible == true ? true : false,
                    controller: passwordController,
                    cursorHeight: 24,
                    // onChanged:block.emailChanged,
                    decoration: InputDecoration(
                        errorText: snapshot.error,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                        isDense: false,
                        suffixIcon: IconButton(
                            icon: Icon(isVisible == false ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isVisible == true ? isVisible = false : isVisible = true;
                              });
                            }),
                        contentPadding: EdgeInsets.only(bottom: 6, top: 14, left: 30),
                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                        prefixIcon: Image.asset('assets/images/Icon_feather_unlock.png'),
                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                  )),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: this.showvalue,
                onChanged: (bool value) {
                  setState(() {
                    this.showvalue = value;
                    //displayTermsDialog();
                  });
                },
              ),
              GestureDetector(
                child: Text(AppStrings.agreeTerms, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#0457BE'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                onTap: () {
                  this.showvalue = true;
                  displayTermsDialog();
                },
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: StreamBuilder<bool>(
                //stream:block.submitCheck,
                builder: (context, snapshot) => RaisedButton(
                    child: Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    color: snapshot.hasError == false ? color.colorConvert(color.primaryColor) : Colors.black12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    onPressed: () {
                      print("ACCOUNTTYPE ${acountType}");
                      if (fNameController.value.text.length > 0 && lNameController.value.text.length > 0 && mnoController.value.text.length > 0 && emailController.value.text.length > 0 && passwordController.value.text.length > 0) {
                        if (showvalue == true) {
                          var map = {
                            /*'first_name': fNameController.value.text,
                            'last_name': lNameController.value.text,
                            'fcm_token': fcmToken, */
                            'mobile_number': mnoController.value.text,
/*                            'email': emailController.value.text,
                            'password': passwordController.value.text,
                            'types': acountType*/
                          };

                          Map<String, dynamic> mapData;

                          ApiHandler.postApi(ApiProvider.baseUrl, EndApi.createAccount, map).then((value) {
                            SignupModel signUpmodel = SignupModel();
                            setState(() {
                              signUpmodel = SignupModel.fromJson(value);
                              mapData = value;
                            });
                            if (signUpmodel.statusCode == "200") {
                              saveAndNavigate(signUpmodel);
                              if (signUpmodel.isExist == "true") {
                                ToastMessages.showToast(message: mapData['message'], type: false);
                              } else {
                                Get.to(OtpScreen(
                                  accountType: acountType,
                                  mNo: mnoController.value.text,
                                  user_id: signUpmodel.result.userId,
                                  firstName: fNameController.text,
                                  lastName: lNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                              }
                              //acountType,mnoController.value.text
                            } else {
                              ToastMessages.showToast(message: mapData['Message'], type: false);
                            }
                          });
                        } else {
                          ToastMessages.showToast(message: "Please accept terms", type: false);
                        }
                      } else {
                        ToastMessages.showToast(message: "All Fields Compulsory", type: false);
                      }
                    }),
              )),
          Container(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(TextSpan(text: 'Already have an account? ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54), children: <InlineSpan>[
                TextSpan(
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      print('Terms and Conditions Single Tap');
                      Get.to(LoginScreen());
                    },
                  text: 'Log in',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color.colorConvert('#0457BE')),
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
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    mnoController = TextEditingController();
    emailController = TextEditingController();
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

  void saveAndNavigate(SignupModel signUpmodel) {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    Database.setUserId(signUpmodel.result.userId.toString());

    print("userid ${signUpmodel.result.userId.toString()}");
  }

  void displayTermsDialog() async {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
            child: Material(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('Terms & Conditions', style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w800)),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Html(
                              data: AppStrings.termsString,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              width: Get.size.width / 1.2,
                              height: 50,
                              child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width / 2.4,
                                height: 52,
                                child: RaisedButton(
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                    color: color.colorConvert(color.primaryColor),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                                    onPressed: () {
                                      setState(() {
                                        Get.back();
                                      });
                                    }),
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
}
