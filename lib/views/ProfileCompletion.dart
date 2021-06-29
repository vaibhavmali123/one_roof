import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_roof/models/SubCategoryModel.dart';
import 'package:one_roof/models/WorkerProfileModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/ThankYouScreen.dart';

class ProfileCompletion extends StatefulWidget {
  String categoryId, categoryName, accountType;

  ProfileCompletion(this.categoryId, this.categoryName, this.accountType);

  ProfileCompletionState createState() => ProfileCompletionState(categoryId, categoryName, accountType);
}

class ProfileCompletionState extends State<ProfileCompletion> {
  String categoryId, categoryName, accountType;
  List<Machine> listMachine = [];
  ProfileCompletionState(this.categoryId, this.categoryName, this.accountType);
  WorkerProfileModel workerProfileModel;
  Machine machine;
  List<String> listItems = ['Bob cat', 'JCB', 'Ex 60'];
  var selectedSkilledLabour, selectedUnSkilledLabour, selectedTechnicalLabour, skilledCount, unSkilledCount, technicalCount, selectedTurnOver;
  final List<String> labourCountList = ['0-10', '10-20', '20-50', '50-100', '100-200', '200-500', '500-1000'];
  final List<String> technicallabourCountList = ['0-10', '10-20', '20-50', '50-100'];
  final List<String> _skilledLabourDropDownValues = [
    "Skilled Labour 1",
    "Skilled Labour 2",
    "Skilled Labour 3",
  ];
  final List<String> _turnOverDropDownValues = ["0-50Lakh", "50Lakh-1Cr", "1Cr-5.0Cr", "5.0Cr-10.0Cr", "10.0Cr-50.0Cr", "50.0Cr-100Cr"];
  final List<String> _unSkilledLabourDropDownValues = [
    "Unskilled Labour 1",
    "Unskilled Labour 2",
    "Unskilled Labour 3",
  ];
  final List<String> _technicalLabourDropDownValues = [
    "Technical Labour 1",
    "Technical Labour 2",
    "Technical Labour 3",
  ];
  final picker = ImagePicker();
  File image, croppedImage;

  var counterList = [];

  var selectedSubCategory;
  List<SubcategoryList> _subCategoryDropdownValues = [];
  final List<String> _specializationList = [];
  final List<String> _categoryList = [];
  final List<String> catIdList = [];
  final List<String> subCatIdList = [];
  String subCatID, subCatIdTemp;
  Map<String, dynamic> idCounterMap = {};
  bool showLoader = true;
  Box<String> appDb;
  String fileStr, fileName;
  static String uploadedFileUrl;
  List<dynamic> listEqipment = [];
  Map<String, dynamic> equipmentsObj;
  List<dynamic> listOldData = [];

  List<dynamic> listMachinery = [];
  Map<String, dynamic> mapMachinery = {};
  Equipments equipments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workerProfileModel = WorkerProfileModel();
    machine = Machine();
    equipments = Equipments();
    appDb = Hive.box(Constants.countList);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double dimens = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        appDb.clear();
        Get.back();
      },
      child: Scaffold(
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
                      title: Text(AppStrings.completeProfile, style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
                      leading: GestureDetector(
                        child: Image.asset(
                          'assets/images/back_icon.png',
                          scale: 1.8,
                        ),
                        onTap: () {
                          appDb.clear();
                          Get.back();
                        },
                      ))
                ],
              )),
          body: SingleChildScrollView(
            child: Container(
              height: dimens <= 750
                  ? Get.size.height + 260
                  : selectedSubCategory != null
                      ? Get.size.height + 130
                      : Get.size.height,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                getHeaderColumn(),
                SizedBox(
                  height: 8,
                ),
                categoryName == 'Contractors' || categoryName == Constants.machineryAndEquipment ? getSubCategoryDropDown() : Container(),
                //TODO
                SizedBox(
                  height: 15,
                ),
                selectedSubCategory != null
                    ? Container(
                        height: _specializationList.length * 50.toDouble(),
                        width: Get.size.width - 45,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black45)),
                        child: ListView.builder(
                          itemCount: _specializationList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10, right: 4),
                                    //height:34,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              _specializationList[index],
                                              style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                                            )),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(55.0), border: Border.all(width: 2, color: Colors.black54)),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        if (counterList[index] >= 1) {
                                                          counterList[index] = --counterList[index];
                                                          print("TEST ${appDb.get('Listdata')}");
                                                          appDb.put(subCatID, counterList.toString());

                                                          /*subCatIdTemp!=null?
                                                            appDb.put(subCatIdTemp,counterList.toString()):
                                                            appDb.put(subCatID,counterList.toString());
*/
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(counterList[index].toString()),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(55.0), border: Border.all(width: 2, color: Colors.black54)),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      initCountData(index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    width: Get.size.width - 45,
                                    height: 1.4,
                                    color: Colors.black26,
                                  )
                                ],
                              )),
                            );
                          },
                        ),
                      )
                    : Container(),
                getFooterColumn()
              ]),
            ),
          )),
    );
  }

  getSkilledLabourDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 55,
          width: Get.size.width / 2,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  AppStrings.skilledLabour,
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 55,
          width: Get.size.width / 3,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
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
                value: skilledCount,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                icon: Image.asset(
                  'assets/images/dropDown_icon.png',
                  height: 22,
                  width: 22,
                ),
                items: labourCountList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  '0-10',
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    skilledCount = value;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  getUnSkilledLabourDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 55,
          width: Get.size.width / 2,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
          child: Center(
            child: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  // background color for the dropdown items
                  buttonTheme: ButtonTheme.of(context).copyWith(
                    alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
                  )),
              child: IgnorePointer(
                ignoring: true,
                child: DropdownButton<String>(
                  underline: Container(
                    height: 1.0,
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))),
                  ),
                  isExpanded: true,
                  focusColor: Colors.white,
                  value: selectedUnSkilledLabour,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                  //icon:Image.asset('assets/images/dropDown_icon.png',height:22,width:22,),
                  items: _unSkilledLabourDropDownValues.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    'Unskilled Labour',
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      selectedUnSkilledLabour = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 55,
          width: Get.size.width / 3,
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
                value: unSkilledCount,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                icon: Image.asset(
                  'assets/images/dropDown_icon.png',
                  height: 22,
                  width: 22,
                ),
                items: labourCountList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  '0-10',
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    unSkilledCount = value;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  getTechnicalLabourDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 55,
          width: Get.size.width / 2,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  AppStrings.technicalLabour,
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 55,
          width: Get.size.width / 3,
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
                value: technicalCount,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                icon: Image.asset(
                  'assets/images/dropDown_icon.png',
                  height: 22,
                  width: 22,
                ),
                items: technicallabourCountList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  '0-10',
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    technicalCount = value;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  turnover() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            height: 55,
            width: Get.size.width / 2,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    AppStrings.anual,
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )),
        Container(
          height: 55,
          width: Get.size.width / 3,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
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
                value: selectedTurnOver,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                icon: Image.asset(
                  'assets/images/dropDown_icon.png',
                  height: 22,
                  width: 22,
                ),
                items: _turnOverDropDownValues.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  '25L-50L',
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    selectedTurnOver = value;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

//  categoryName=='Contractors'
  getFooterColumn() {
    return Column(
      children: [
        SizedBox(
          height: 14,
        ),
        categoryName == 'Contractors'
            ? Column(
                children: [
                  Text(AppStrings.teamStrength, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0457BE'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                  SizedBox(
                    height: 14,
                  ),
                  getSkilledLabourDropDown(),
                  SizedBox(
                    height: 14,
                  ),
                  getUnSkilledLabourDropDown(),
                  SizedBox(
                    height: 14,
                  ),
                  getTechnicalLabourDropDown(),
                  SizedBox(
                    height: 19,
                  ),
                ],
              )
            : Container(),
        Text(AppStrings.turnOver, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0457BE'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
        SizedBox(
          height: 10,
        ),
        turnover(),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          child: Container(
              width: Get.size.width - 50,
              height: 56,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(width: 2, color: color.colorConvert('#0457BE'))),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(fileStr == null ? AppStrings.attachProfile : fileStr, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0457BE'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                  Icon(
                    Icons.attach_file,
                    color: color.colorConvert('#0457BE'),
                  )
                ],
              ))),
        ),
        SizedBox(
          width: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(AppStrings.maxSize, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
            SizedBox(
              width: 25,
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width / 2.4,
          height: 52,
          child: RaisedButton(
              child: Text(
                AppStrings.submit,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              color: color.colorConvert(color.primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                if (categoryName == Constants.contractors) {
                  if (skilledCount != null && unSkilledCount != null && technicalCount != null && selectedTurnOver != null) {
                    submitDetails();
                  } else {
                    ToastMessages.showToast(message: 'All fields are compulsory', type: false);
                  }
                } else if (categoryName == Constants.machineryAndEquipment) {
                  if (idCounterMap.length <= 0) {
                    ToastMessages.showToast(message: 'Please selsect machinery', type: false);
                  } else {
                    submitDetails();
                  }
                }
              }),
        ),
      ],
    );
  }

  getHeaderColumn() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(AppStrings.serveText, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black38, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                SizedBox(
                  height: 8,
                ),
                Text(AppStrings.resAvailableText, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w800, letterSpacing: 0.0))),
                SizedBox(
                  height: 8,
                ),
                Text('Machinery & Equipments', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0457BE'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
              ],
            )
          ],
        )
      ],
    );
  }

  getSubCategoryDropDown() {
    return Container(
      height: 54,
      width: Get.size.width - 45,
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
            value: selectedSubCategory,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            icon: Image.asset(
              'assets/images/dropDown_icon.png',
              height: 22,
              width: 22,
            ),
            items: _subCategoryDropdownValues.map<DropdownMenuItem<String>>((SubcategoryList value) {
              return DropdownMenuItem<String>(
                value: value.subcategory,
                child: Text(
                  value.subcategory,
                  style: TextStyle(color: subCatIdList.contains(value.subcstegoryId) ? Colors.green : Colors.black87, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            hint: Text(
              AppStrings.subCategory,
              style: TextStyle(fontSize: 14, color: selectedSubCategory != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedSubCategory = value;
                print('CNTLIST ${counterList.toString()}');
                for (int i = 0; i < _subCategoryDropdownValues.length; i++) {
                  if (_subCategoryDropdownValues[i].subcategory == value) {
                    subCatID = _subCategoryDropdownValues[i].subcstegoryId;
                    subCatIdList.add(_subCategoryDropdownValues[i].subcstegoryId);
                  }
                }
                setState(() {
                  listOldData.add(mapMachinery);
                  idCounterMap[subCatID] = counterList;
                  subCatIdTemp = subCatID;
                });
                print('subCatID ${subCatID.toString()}');

                getSpecializations();

                print('CNTLIST MAp${idCounterMap.toString()}');
              });
            },
          ),
        ),
      ),
    );
  }

  void getSpecializations() {
    String catId;
    setState(() {
      _specializationList.clear();
    });
    /* int index;
    String catId;
    for (int i = 0; i < _subCategoryDropdownValues.length; i++) {
      if (_subCategoryDropdownValues[i].subcategory == selectedSubCategory) {
        index = i;
      }
      print("INDEX ${index}");
    }
    for (int i = 0; i < subCatIdList.length; i++) {
      catId = subCatIdList[index];
    }*/
    setState(() {
      catId = subCatID;
      // catIdList.clear();
      //subCatID=catId;
      _specializationList.clear();
      // _specializationList=null;
    });
    if (subCatID != null && subCatID != '') {
      var map = {'subcategory_id': subCatID};
      ApiHandler.postApi(ApiProvider.baseUrl, EndApi.specialization, map).then((value) {
        Map<String, dynamic> mapData;
        List<dynamic> listRes;
        setState(() {
          mapData = value;
          listRes = mapData[ApiKeys.specialisationList];
          print("DATA ${mapData.toString()}");
          print("DATA ${listRes.toString()}");
          _specializationList.clear();

          counterList.clear();
          for (int i = 0; i < listRes.length; i++) {
            _specializationList.add(listRes[i][ApiKeys.specialisation]);
            //counterList.add(0);
            // subCatIdList.add(listRes[i][ApiKeys.subCategoryId]);
          }
        });

        print("TEST subCatIdTemp ${subCatIdTemp}");
        print("TEST catId ${catId}");
        print("TEST  counterList ${counterList.toString()}");
        // print("TEST Temp  DBLIST ${appDb.containsKey(subCatIdTemp)}");
        print("TEST perm  DBLIST ${appDb.containsKey(catId)}");

        if (subCatIdTemp == null) {
          for (int i = 0; i < _specializationList.length; i++) {
            setState(() {
              counterList.add(0);
            });
          }
          appDb.put(catId, counterList.toString());
          print("TEST  counterList after ${counterList.toString()}");
        } else if (subCatIdTemp != null) {
          if (appDb.containsKey(catId)) {
            counterList = json.decode(appDb.get(catId));
          } else {
            for (int j = 0; j < _specializationList.length; j++) {
              counterList.add(0);
            }
          }
        }
      });
    }
  }

  void loadData() {
    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.category).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        listRes = mapData[ApiKeys.categoryList];
        print("DATA ${mapData.toString()}");
        print("DATA ${listRes.toString()}");

        for (int i = 0; i < listRes.length; i++) {
          _categoryList.add(listRes[i][ApiKeys.categoryName]);
        }
      });
    });

    var map = {'category_id': '4'};

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.subCategory, map).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        listRes = mapData[ApiKeys.subCatList];
        _subCategoryDropdownValues = SubCategoryModel.fromJson(mapData).subcategoryList.toList();
      });

      /*for (int i = 0; i < listRes.length; i++) {

        _subCategoryDropdownValues.add(listRes[i][ApiKeys.subcategory]);
        subCatIdList.add(listRes[i][ApiKeys.subCategoryId]);
      }*/
      setState(() {
        showLoader = false;
      });
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Document from Library'),
                      onTap: () {
                        getDocFromLib();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        croppedImage = image;

        fileName = image.path.split('/').last;
        var dir = image.parent.path;
        fileStr = fileName;
        uploader(fileName: fileName, directory: dir);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        String fileName = image.path.split('/').last;
        var dir = image.parent.path;
        fileStr = fileName;

        print("image ${image}");
        print("fileName ${fileName}");
        print("dir ${dir}");

        uploader(fileName: fileName, directory: dir);
        setState(() {
          croppedImage = image;
          showLoader = true;
        });
      }
    });
  }

  static Future<Map<String, dynamic>> uploader({fileName, directory}) async {
    dynamic prog;
    Map<String, dynamic> map;
    final uploader = FlutterUploader();
    //String fileName = await file.path.split('/').last;

    final taskId = await uploader.enqueue(url: ApiProvider.baseUrlUpload, files: [FileItem(filename: fileName, savedDir: directory)], method: UploadMethod.POST, headers: {"apikey": "api_123456", "userkey": "userkey_123456"}, showNotification: true);
    final subscription = uploader.progress.listen((progress) {});

    final subscription1 = uploader.result.listen((result) {
//    print("Progress result ${result.response}");

      // return result.response;
    }, onError: (ex, stacktrace) {});
    subscription1.onData((data) async {
      map = await json.decode(data.response);
      map = await json.decode(data.response);
      print("PATH data ${map['url']}");
      uploadedFileUrl = map['url'].toString();
    });
    return map;
  }

/*
  static Future<Map<String,dynamic>>uploaderB({fileName,directory})async{
    dynamic prog;
    Map<String,dynamic>map;
    final uploader = FlutterUploader();
    //String fileName = await file.path.split('/').last;

    final taskId=await uploadebr(url:ApiProvider.baseUrlUpload,

        method:UploadMethod.POST,
        headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
        showNotification:true
    );
    final subscription = uploader.progress.listen((progress) {

    });

    final subscription1 =uploader.result.listen((result) {
//    print("Progress result ${result.response}");

      // return result.response;
    }, onError: (ex, stacktrace) {
    });
    subscription1.onData((data)async {

      map=await json.decode(data.response);
      print("PATH data ${map.toString()}");
    });
    return map;
  }
*/

  void getDocFromLib() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'docx'],
    );
    print("result ${result.paths[0]}");
    setState(() {
      image = File(result.paths[0]);
      String fileName = image.path.split('/').last;
      var dir = image.parent.path;
      fileStr = fileName;

      print("image ${image}");
      print("fileName ${fileName}");
      print("dir ${dir}");

      uploader(fileName: fileName, directory: dir);
    });
  }

  void initCountData(int index) {
    setState(() {
      counterList[index] = ++counterList[index];
      appDb.put(subCatID, counterList.toString());
      //const JsonEncoder encoder = JsonEncoder.withIndent('  ');

      for (int i = 0; i < _specializationList.length; i++) {
        equipmentsObj = {"subcategory": selectedSubCategory.toString().trim(), "id": idCounterMap[i], "name": _specializationList[i], "count": counterList[i]};
        listEqipment.add(json.encode(equipmentsObj));

        machine = Machine(subcategory: selectedSubCategory.toString().trim(), id: idCounterMap[i], name: _specializationList[i], count: counterList[i]);

        listMachine.add(machine);
      }

      Equipments(machine: listMachine);

      print('MOCKKK listMachine ${listMachine.toString()}');
      mapMachinery = {selectedSubCategory.toString(): json.encode(listEqipment)};
      listMachinery.add(mapMachinery);
      listEqipment.clear();
    });
  }

  void submitDetails() {
    print("REquest : ${_specializationList.toString()} ${idCounterMap.toString()} ${counterList.toString()}");
    //  const JsonEncoder encoder = JsonEncoder.withIndent('  ');

    Box<String> appDb;
    List<dynamic> list = [];

    Map<String, dynamic> mapTest = {};

    for (int i = 0; i < _specializationList.length; i++) {
      mapMachinery = {"subcategory": selectedSubCategory.toString().trim(), "id": idCounterMap[i], "name": _specializationList[i], "count": counterList[i]};
      list.add(mapMachinery);
      listOldData.add(mapMachinery);
    }
    list.addAll(listOldData);
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);

    print("LLLLLLLLL ${listEqipment.toString()} ${equipmentsObj.toString()}");
    var map = {
      "id": userId,
      "machinaries_equipments": selectedSubCategory,
      "equipments": json.encode(listOldData),
      "skilled_labour": skilledCount,
      'non_skilled_labour': unSkilledCount,
      'turnover': selectedTurnOver,
      "technical_staff": technicalCount,
      "file": uploadedFileUrl != null ? uploadedFileUrl : "undefined"
    };

    ApiHandler.putApi(ApiProvider.baseUrl, EndApi.updateMachinaries, map).then((value) {
      print('RESPONSE ${value['result']}');
      if (value['result'] == true) {
        Get.to(ThankYouScreen(accountType));
        ToastMessages.showToast(message: 'Updated successfully', type: true);
        listOldData.clear();
      }
    });
  }
}
