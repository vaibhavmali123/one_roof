import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/ThankYouScreen.dart';

class MoreAbout extends StatefulWidget {
  final String accountType;

  MoreAbout(this.accountType);

  MoreAboutState createState() => MoreAboutState(accountType);
}

class MoreAboutState extends State<MoreAbout> {
  final String accountType;

  MoreAboutState(this.accountType);

  final List<String> _cityDropdownValues = [
    "Pune",
    "Mumbai",
    "Delhi",
  ];
  final List<String> _designationDropdownValues = [];
  var selectedDesignation;
  List<String> _buildersDropdownValues = [];
  var selectedLoc;
  var selectedBuilders;
  TextEditingController directorNameCtrl, orgNameCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    directorNameCtrl = TextEditingController();
    orgNameCtrl = TextEditingController();
    loadData();
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
                  title: Text(AppStrings.tell_us, style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
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
          child: IntrinsicHeight(
            //height:Get.size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    flex: 4,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(AppStrings.serveText, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black38, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 14,
                              child: Column(
                                children: [
                                  Container(
                                    height: 54,
                                    width: Get.size.width / 1.2,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
                                    child: Center(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            canvasColor: Colors.white, // background color for the dropdown items
                                            buttonTheme: ButtonTheme.of(context).copyWith(
                                              alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
                                            )),
                                        child: DropdownButton<String>(
                                          underline: Container(
                                            height: 1.0,
                                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))),
                                          ),
                                          isExpanded: true,
                                          focusColor: Colors.white,
                                          value: selectedLoc,
                                          style: TextStyle(color: Colors.white),
                                          iconEnabledColor: Colors.black,
                                          icon: Image.asset(
                                            'assets/images/dropDown_icon.png',
                                            height: 22,
                                            width: 22,
                                          ),
                                          items: _cityDropdownValues.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                              ),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            "Select your city",
                                            style: TextStyle(color: selectedLoc != null ? Colors.black : Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                          onChanged: (String value) {
                                            setState(() {
                                              selectedLoc = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28,
                                  ),
                                  Container(
                                    height: 54,
                                    width: Get.size.width / 1.2,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
                                    child: Center(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            canvasColor: Colors.white, // background color for the dropdown items
                                            buttonTheme: ButtonTheme.of(context).copyWith(
                                              alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
                                            )),
                                        child: DropdownButton<String>(
                                          underline: Container(
                                            height: 1.0,
                                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))),
                                          ),
                                          isExpanded: true,
                                          focusColor: Colors.white,
                                          value: selectedBuilders,
                                          style: TextStyle(color: Colors.white),
                                          iconEnabledColor: Colors.black,
                                          icon: Image.asset(
                                            'assets/images/dropDown_icon.png',
                                            height: 22,
                                            width: 22,
                                          ),
                                          items: _buildersDropdownValues.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                              ),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            'Select Business Type',
                                            style: TextStyle(color: selectedBuilders != null ? Colors.black : Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                          onChanged: (String value) {
                                            setState(() {
                                              selectedBuilders = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Container(
                                      width: Get.size.width / 1.2,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            width: MediaQuery.of(context).size.width - 50,
                                            child: TextField(
                                              keyboardType: TextInputType.text,
                                              showCursor: true,
                                              cursorWidth: 2,
                                              controller: orgNameCtrl,
                                              autofocus: false,
                                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: 'Enter Organization Name',
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                ),
                                                contentPadding: EdgeInsets.only(top: 18, left: 16, bottom: 18),
                                                errorStyle: TextStyle(height: 0),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
                                              ),
                                              //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  getDesignationDropDown(),
                                ],
                              ))
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width / 2.4,
                            height: 52,
                            child: RaisedButton(
                                child: Text(
                                  AppStrings.submit,
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                color: color.colorConvert(color.primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                onPressed: () {
                                  /* selectedLoc,
                              "hiring_type":selectedBuilders,
                              "director":directorNameCtrl.value.text,
                              'hire_designation':selectedDesignation,
                              "organization_name_hire":orgNameCtrl.value.text,
*/
                                  if (selectedLoc != null && selectedBuilders != null && selectedDesignation != null) {
                                    submitDetails();
                                  } else {
                                    ToastMessages.showToast(message: 'All Fields Compulsory', type: false);
                                  }
                                }),
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadData() {
    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.hiringType).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        listRes = mapData[ApiKeys.result];
        print("DATA ${mapData.toString()}");
        print("DATA ${listRes.toString()}");
        for (int i = 0; i < listRes.length; i++) {
          _buildersDropdownValues.add(listRes[i][ApiKeys.type]);
        }
        print("DATA d ${_buildersDropdownValues.toString()}");
      });
    });

    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.cities).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        listRes = mapData[ApiKeys.citiesList];
        print("DATA ${mapData.toString()}");
        print("DATA ${listRes.toString()}");
        _cityDropdownValues.clear();
        for (int i = 0; i < listRes.length; i++) {
          _cityDropdownValues.add(listRes[i][ApiKeys.cityName]);
        }
        print("DATA cityID ${_cityDropdownValues.toString()}");
      });
    });

    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.hireDesignation).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        listRes = mapData[ApiKeys.result];
        print("DATA ${mapData.toString()}");
        print("DATA ${listRes.toString()}");
        for (int i = 0; i < listRes.length; i++) {
          _designationDropdownValues.add(listRes[i][ApiKeys.designationName]);
        }
        print("DATA d ${_designationDropdownValues.toString()}");
      });
    });
  }

  getDesignationDropDown() {
    return Container(
      height: 54,
      width: Get.size.width / 1.2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
              )),
          child: DropdownButton<String>(
            underline: Container(
              height: 1.0,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))),
            ),
            isExpanded: true,
            focusColor: Colors.white,
            value: selectedDesignation,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            icon: Image.asset(
              'assets/images/dropDown_icon.png',
              height: 22,
              width: 22,
            ),
            items: _designationDropdownValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            hint: Text(
              AppStrings.selectDesignation,
              style: TextStyle(fontSize: 14, color: selectedDesignation != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedDesignation = value;
              });
            },
          ),
        ),
      ),
    );
  }

  void submitDetails() {
    print("orgNameCtrl ${directorNameCtrl.value.text}");

    print("orgNameCtrl ${orgNameCtrl.value.text}");
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);
    var map = {"id": userId,
      "location": selectedLoc,
      "hiring_type": selectedBuilders,
      "director": directorNameCtrl.value.text,
      'hire_designation': selectedDesignation,
      "organization_name_hire": orgNameCtrl.value.text, "types": 'hire'};
    print("orgNameCtrl ${map.toString()}");

    ApiHandler.putApi(ApiProvider.baseUrl, EndApi.hireDetailsUpdate, map).then((value) {
      Map<String, dynamic> mapData;
      setState(() {
        mapData = value;
        print("categoryse ${mapData['category_name']}");
        Box<String> appDb;
        appDb = Hive.box(ApiKeys.appDb);
        appDb.put(ApiKeys.assignedCatList, mapData['category_name']);
      });
      print("RESPONSE ${mapData.toString()}");
      if (mapData['result'] == true) {
        ToastMessages.showToast(message: 'Updated successfully', type: true);

        Get.to(ThankYouScreen(accountType));
      }
    });
  }
}
