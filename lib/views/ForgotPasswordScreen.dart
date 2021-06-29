import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/LoginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController mnoController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mnoController = TextEditingController();
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
                  title: Text('Forgot Password', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
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
        child: Center(
          child: Container(
            //height:Get.size.height,
            width: Get.width / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                              hintText: 'Enter mobile number',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                              isDense: false,
                              contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                              prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                              prefixIcon: Image.asset('assets/images/Icon_feather_phone_call.png'),
                              focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                        )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 48,
                  width: 100,
                  child: RaisedButton(
                      child: Text(
                        'Send',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      color: color.colorConvert(color.primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () {
                        if (mnoController.text.toString().length == 10) {
                          forgotApi();
                        } else {
                          ToastMessages.showToast(message: 'Invalid mobile number', type: false);
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void forgotApi() {
    var map = {
      "mobile": mnoController.text.toString(),
    };
    print("Request ${map.toString()}");

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.forgotPassword, map).then((value) {
      print("SST ${value.toString()}");

      if (value['data_code'] == '200') {
        print("SST ${value.toString()}");
        ToastMessages.showToast(message: 'Password sent to registered mobile number', type: true);
        Get.to(LoginScreen());
      } else {
        ToastMessages.showToast(message: 'Unable to reset password', type: false);
      }
    });
  }
}
