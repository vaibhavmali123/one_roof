import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_roof/blocs/DeviceTypeBloc.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/CreateAccount.dart';

class AccountSelection extends StatefulWidget {
  AccountSelectionState createState() => AccountSelectionState();
}

class AccountSelectionState extends State<AccountSelection> {
  DeviceTypeBloc deviceTypeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceTypeBloc = DeviceTypeBloc();
  }

  String deviceType;

  double textSize = 14.0;
  @override
  Widget build(BuildContext context) {
    double dimens = MediaQuery.of(context).size.height;

    if (dimens <= 725) {
      deviceType = 'smallScreen';
    } else if (dimens < 750) {
      textSize = 13;
    }

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: Get.size.height,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(AppStrings.selectAccount, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w900))],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.canChange, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w800, letterSpacing: 0.0))),
                ],
              ),
              LayoutBuilder(builder: (BuildContext context, constraints) {
                if (constraints.maxHeight <= 725) {
                  deviceTypeBloc.deviceChanged(AppStrings.sdpi);
                  /*setState(() {
                        deviceType='smallScreen';
                      });*/
                }
                print("HEIGHT ${constraints.maxHeight}");

                return StreamBuilder<String>(
                    stream: deviceTypeBloc.deviceType,
                    builder: (context, snapshot) => Container(
                          height: Get.size.height / 1.2,
                          child: Column(
                            //mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                            children: [
                              dimens >= 720
                                  ? Expanded(
                                      flex: 1,
                                      child: Container(),
                                    )
                                  : Container(
                                      height: 2,
                                    ),
                              Expanded(
                                  flex: 8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(children: [
                                        Container(
                                          width: dimens >= 780 ? Get.size.width / 1.3 : Get.size.width / 1.3,
                                          margin: EdgeInsets.only(top: 48),
                                          height: 300,
                                          decoration: BoxDecoration(
                                            color: color.colorConvert('#EBF2FA'), //2AAD9C1A  0457BE14
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        Positioned(
                                            left: 100,
                                            right: 100,
                                            //alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  child: CircleAvatar(
                                                      radius: 40.0,
                                                      backgroundColor: color.colorConvert(color.accountCardColor),
                                                      //backgroundColor:Colors.black87,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(4),
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.white,
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/images/hire icons.png',
                                                              scale: 2.2,
                                                            ),
                                                          ),
                                                          radius: 40.0,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )),
                                        Positioned(
                                            top: dimens >= 728 ? 110 : 100,
                                            left: 50,
                                            right: 50,
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Text(AppStrings.consultantText, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: textSize, fontWeight: FontWeight.w600, color: color.colorConvert('#0D082B'), letterSpacing: 0.0, height: 1.4))),
                                                ),
                                                Text('Contractors, Materials,', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: textSize, fontWeight: FontWeight.w600, color: color.colorConvert('#0D082B'), letterSpacing: 0.0, height: 1.4))),
                                                Text('Machinery & more…', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: textSize, fontWeight: FontWeight.w600, color: color.colorConvert('#0D082B'), letterSpacing: 0.0, height: 1.4))),
                                                SizedBox(
                                                  height: dimens >= 725 ? 36 : 26,
                                                ),
                                                Container(
                                                  width: Get.size.width / 2,
                                                  height: 50,
                                                  child: RaisedButton(
                                                      child: Text(
                                                        AppStrings.hireBtnTitle,
                                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                                      ),
                                                      color: color.colorConvert(color.primaryColor),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                      onPressed: () {
                                                        Get.to(CreateAccount("hire") /*MoreAbout("hire")*/);
                                                      }),
                                                )
                                              ],
                                            )),
                                      ])
                                    ],
                                  )),
                              //SizedBox(height:24,),
                              dimens > 720
                                  ? Expanded(flex: 1, child: Container())
                                  : Container(
                                      height: 5,
                                    ),
                              Expanded(
                                  flex: 8,
                                  child: StreamBuilder<String>(
                                    stream: deviceTypeBloc.deviceType,
                                    builder: (context, snapshot) {
                                      print('D HEIGHT ${snapshot.data}');
                                      return Stack(children: [
                                        Container(
                                          width: dimens >= 780 ? Get.size.width / 1.3 : Get.size.width / 1.3,
                                          margin: EdgeInsets.only(top: 48),
                                          height: 300,
                                          decoration: BoxDecoration(
                                            color: color.colorConvert(color.accountCardColor),
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        Positioned(
                                            //alignment: Alignment.center,
                                            left: 100,
                                            right: 100,
                                            child: SizedBox(
                                              child: CircleAvatar(
                                                  radius: 40.0,
                                                  backgroundColor: color.colorConvert(color.accountCardColor),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      child: Center(
                                                        child: Image.asset(
                                                          'assets/images/work icons.png',
                                                          scale: 2,
                                                        ),
                                                      ),
                                                      radius: 50.0,
                                                    ),
                                                  )),
                                            )),
                                        Positioned(
                                            top: dimens >= 800 ? 110 : 100,
                                            left: 50,
                                            right: 50,
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Text('List your business here,', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: textSize, fontWeight: FontWeight.w600, color: color.colorConvert('#0D082B'), letterSpacing: 0.0, height: 1.4))),
                                                ),
                                                Text('to find more suitable', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: textSize, fontWeight: FontWeight.w600, color: color.colorConvert('#0D082B'), letterSpacing: 0.0, height: 1.4))),
                                                Text('work for you', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: textSize, fontWeight: FontWeight.w600, color: color.colorConvert('#0D082B'), letterSpacing: 0.0, height: 1.4))),
                                                SizedBox(
                                                  height: dimens >= 725 ? 36 : 26,
                                                ),
                                                Container(
                                                  width: Get.size.width,
                                                  height: 50,
                                                  child: RaisedButton(
                                                      child: Text(
                                                        AppStrings.workBtnTitle,
                                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                                      ),
                                                      color: color.colorConvert('#2AAD9C'),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                      onPressed: () {
                                                        Get.to(/*MoreAboutWorker('work')*/ CreateAccount('work'));
                                                      }),
                                                )
                                              ],
                                            )),
                                      ]);
                                    },
                                  ))
                            ],
                          ),
                        ));
              })
            ],
          ),
        ),
      ),
    ));
  }

  int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }
}
