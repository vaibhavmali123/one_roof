import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_roof/blocs/bloc.dart';
import 'package:one_roof/models/CategoriesModel.dart';
import 'package:one_roof/models/SpecialisationsModel.dart';
import 'package:one_roof/models/SubCategoryModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/ProfileCompletion.dart';
import 'package:one_roof/views/ThankYouScreen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MoreAboutWorker extends StatefulWidget {
  String accountType;
  bool switchedRole = false;

  MoreAboutWorker(this.accountType, {this.switchedRole});

  MoreAboutWorkerState createState() => MoreAboutWorkerState(accountType, switchedRole);
}

class MoreAboutWorkerState extends State<MoreAboutWorker> {
  final List<String> _cityDropdownValues = [];
  String accountType;
  bool switchedRole = false;

  MoreAboutWorkerState(this.accountType, this.switchedRole);

  final List<String> _designationDropdownValues = [];
  List<CategoryList> _categoryDropdownValues = [];
  final List<String> catIdList = [];
  final List<String> cityIdList = [];

  final List<String> subCatIdList = [];
  final List<String> specialisationIdList = [];
  final List<String> listSelectedSubcat = [];
  final List<String> listSelectedSpec = [];
  List<SubcategoryList> _subCategoryDropdownValues = [];
  List<SpecialisationList> _specializationDropdownValues = [];
  final List<String> _localityDropdownValues = [];
  bool isSubCatOpen = false;
  int catIdCnt;
  String catId, catIdTemp;
  bloc block;

  var selectedLoc, selectedCity, selectedDesignation, selectedCategory, selectedSubCategory, selectedspecialization;
  List<dynamic> selectedMainCatList = [];
  TextEditingController orgTextCtrl, experienceCtrl, ctcCtrl;

  final picker = ImagePicker();
  File image, croppedImage;
  String uploadedFileUrl;
  bool showLoader;
  String fileStr, fileName;
  List<String> extensions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orgTextCtrl = TextEditingController();
    experienceCtrl = TextEditingController();
    ctcCtrl = TextEditingController();
    block = bloc();
    loadData();
  }

  String categoryId;
  double dimens;

  @override
  Widget build(BuildContext context) {
    dimens = MediaQuery.of(context).size.height;
    print("DIMENS ${dimens}");
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
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double height;
              if (dimens >= 760 && dimens <= 850) {
                if (listSelectedSubcat.length <= 0) {
                  height = Get.size.height - 100;
                } else if (listSelectedSpec.length >= 0 && listSelectedSubcat.length >= 0) {
                  height = Get.size.height - 10;
                }
              } else if (dimens > 855) {
                if (listSelectedSubcat.length <= 0) {
                  height = Get.size.height - 100;
                } else if (listSelectedSpec.length >= 0 && listSelectedSubcat.length >= 0) {
                  height = Get.size.height - 10;
                }
              } else if (dimens < 760) {
                if (listSelectedSubcat.length <= 0) {
                  height = Get.size.height + 80;
                } else if (listSelectedSpec.length >= 0 && listSelectedSubcat.length >= 0) {
                  height = Get.size.height + 150;
                }
              }
              return IntrinsicHeight(
                // height:height,
                //width:Get.size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                //flex: 1,
                                child: Column(
                                  children: [
                                    Text(AppStrings.serveText, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black38, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 12,
                                  child: Column(
                                    children: [
                                      getCityDropDown(),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      getLocalityDropDown(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      getMainCategoryDropDown(),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      getSubCategoryDropDown(),
                                      listSelectedSubcat.length > 0 ? SizedBox(height: 5) : Container(),
                                      listSelectedSubcat.length > 0
                                          ? Container(
                                              margin: EdgeInsets.only(top: 5),
                                              width: Get.size.width,
                                              height: 40,
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: listSelectedSubcat.length,
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                        decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(8.0)),
                                                        margin: EdgeInsets.only(left: 2, right: 2),
                                                        height: 15,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 12),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                listSelectedSubcat[index],
                                                                style: TextStyle(color: Colors.black87, fontSize: 12),
                                                              ),
                                                              IconButton(
                                                                  icon: Icon(
                                                                    Icons.clear,
                                                                    color: Colors.red,
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      listSelectedSubcat.removeAt(index);
                                                                      subCatIdList.removeAt(index);
                                                                      _specializationDropdownValues.clear();
                                                                      selectedspecialization = null;
                                                                      listSelectedSpec.clear();
                                                                    });
                                                                    setState(() {
                                                                      subCatIdList.removeAt(index);
                                                                      getSpecializations();
                                                                    });
                                                                    print("listSelectedSubcat ${listSelectedSubcat.toString()}");
                                                                  })
                                                            ],
                                                          ),
                                                        ));
                                                  }))
                                          : Container(),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      getSpecializationDropDown(),
                                      listSelectedSpec.length > 0 ? SizedBox(height: 5) : Container(),
                                      listSelectedSpec.length > 0
                                          ? Container(
                                              margin: EdgeInsets.only(top: 5),
                                              width: Get.size.width,
                                              height: 40,
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: listSelectedSpec.length,
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                        decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(8.0)),
                                                        margin: EdgeInsets.only(left: 2, right: 2),
                                                        height: 15,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 12),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                listSelectedSpec[index],
                                                                style: TextStyle(color: Colors.black87, fontSize: 12),
                                                              ),
                                                              IconButton(
                                                                  icon: Icon(
                                                                    Icons.clear,
                                                                    color: Colors.red,
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      listSelectedSpec.removeAt(index);
                                                                      specialisationIdList.removeAt(index);
                                                                    });
                                                                  })
                                                            ],
                                                          ),
                                                        ));
                                                  }))
                                          : Container(),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      getOrgNameField(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      getDesignationDropDown(),
                                      selectedCategory == Constants.hrManagement ? getExperienceField() : Container()
                                    ],
                                  ))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width / 2.4,
                            height: 52,
                            child: RaisedButton(
                                child: showLoader != true
                                    ? Text(
                                        AppStrings.submit,
                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                      )
                                    : CircularProgressIndicator(),
                                color: color.colorConvert(color.primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                onPressed: () {
                                  if (selectedCategory == Constants.hrManagement) {
                                    if (experienceCtrl.text.length > 0 && ctcCtrl.text.length > 0) {
                                      submitDetails();
                                    } else {
                                      ToastMessages.showToast(message: "All Fields Compulsory", type: false);
                                    }
                                  } else {
                                    submitDetails();
                                  }
                                }),
                          ),
                        ))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  getCityDropDown() {
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
            value: selectedCity,
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
              "Select Your city",
              style: TextStyle(fontSize: 14, color: selectedCity != null ? Colors.black87 : Colors.black54, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedCity = value;
                getLocality();
              });
            },
          ),
        ),
      ),
    );
  }

  getLocalityDropDown() {
    return Container(
      height: 54,
      width: Get.size.width / 1.2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
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
            items: _localityDropdownValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            hint: Text(
              AppStrings.locality,
              style: TextStyle(fontSize: 14, color: selectedLoc != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedLoc = value;
              });
            },
          ),
        ),
      ),
    );
  }

  getOrgNameField() {
    return Container(
        width: Get.size.width / 1.2,
        child: Column(
          children: [
            /*Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppStrings.orgName,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),*/
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width - 50,
              child: TextField(
                keyboardType: TextInputType.text,
                showCursor: true,
                controller: orgTextCtrl,
                cursorWidth: 2,
                autofocus: false,
                style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  isDense: false,
                  hintText: "Enter your organization Name",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                  contentPadding: EdgeInsets.only(top: 18, left: 16, bottom: 18),
                  errorStyle: TextStyle(height: 0),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
                ),
                //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
              ),
            ),
          ],
        ));
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

  getMainCategoryDropDown() {
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
            value: selectedCategory,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            icon: Image.asset(
              'assets/images/dropDown_icon.png',
              height: 22,
              width: 22,
            ),
            items: _categoryDropdownValues.map<DropdownMenuItem<String>>((CategoryList value) {
              print("DDD ${value.id}");
              return DropdownMenuItem<String>(
                value: value.categoryName,
                child: Text(
                  value.categoryName,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            hint: Text(
              AppStrings.selectCategory,
              style: TextStyle(fontSize: 14, color: selectedCategory != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                listSelectedSubcat.clear();
                listSelectedSpec.clear();
                selectedSubCategory = null;
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedCategory = value;
                selectedMainCatList.add(selectedCategory);
                _subCategoryDropdownValues.clear();
                subCatIdList.clear();
                selectedDesignation = null;
                _designationDropdownValues.clear();
                _specializationDropdownValues.clear();
                selectedspecialization = null;
                print("selectedCategory ${selectedMainCatList.toString()}");

                for (int i = 0; i < _categoryDropdownValues.length; i++) {
                  //TODO
                  if (_categoryDropdownValues[i].categoryName == value) {
                    catIdList.add(_categoryDropdownValues[i].id);
                    catId = _categoryDropdownValues[i].id;
                  }
                }

                getDesignation();
                /*catId = catIdList
                    .toString()
                    .substring(1, catIdList.toString().length - 1)
                    .toString();*/
                catIdTemp = catId;
                print("catId ${catId}");
              });
              getSubCategory();
            },
          ),
        ),
      ),
    );
  }

  Widget getSubCategoryDropDown() {
    return InkWell(
      onTap: () {
        block.streamSink.add(true);
      },
      child: Container(
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
              onTap: () {
                //TODO
                setState(() {
                  isSubCatOpen = true;
                });
              },
              underline: Container(
                height: 1.0,
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))),
              ),
              isExpanded: true,
              focusColor: Colors.white,
              value: selectedSubCategory,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              icon: selectedSubCategory == null
                  ? Image.asset(
                      'assets/images/dropDown_icon.png',
                      height: 22,
                      width: 22,
                    )
                  : Container(),
              items: _subCategoryDropdownValues.map<DropdownMenuItem<String>>((SubcategoryList value) {
                print("DDD ${value.subcstegoryId}");
                return DropdownMenuItem<String>(
                    value: value.subcategory,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Get.size.width / 1.6,
                          child: Text(
                            value.subcategory,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(
                          subCatIdList.contains(value.subcstegoryId) ? Icons.check_box : Icons.check_box_outline_blank,
                          color: color.colorConvert(color.primaryColor),
                        )
                      ],
                    ));
              }).toList(),
              hint: Text(
                AppStrings.subCategory,
                style: TextStyle(fontSize: 14, color: selectedSubCategory != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
              ),
              onChanged: (String value) {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  if (_subCategoryDropdownValues.length > 0) {
                    for (int i = 0; i < _subCategoryDropdownValues.length; i++) {
                      if (_subCategoryDropdownValues[i].subcategory == value) {
                        print("ID ${_subCategoryDropdownValues[i].subcstegoryId}");
                        subCatIdList.add(_subCategoryDropdownValues[i].subcstegoryId);
                        listSelectedSubcat.add(_subCategoryDropdownValues[i].subcategory);
                      }
                    }
                  }

                  selectedSubCategory = value;
                  catIdCnt = subCatIdList.length;
                  catId = subCatIdList.toString().substring(1, subCatIdList.toString().length - 1).toString();
                  getSpecializations();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  getSpecializationDropDown() {
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
            value: selectedspecialization,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            icon: selectedspecialization == null
                ? Image.asset(
                    'assets/images/dropDown_icon.png',
                    height: 22,
                    width: 22,
                  )
                : Container(),
            items: _specializationDropdownValues.map<DropdownMenuItem<String>>((SpecialisationList value) {
              return DropdownMenuItem<String>(
                value: value.specialisation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: Get.size.width / 1.6,
                        child: Text(
                          value.specialisation,
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        )),
                    Icon(
                      specialisationIdList.contains(value.id) ? Icons.check_box : Icons.check_box_outline_blank,
                      color: color.colorConvert(color.primaryColor),
                    )
                  ],
                ),
              );
            }).toList(),
            hint: Text(
              'Select Specialization',
              style: TextStyle(fontSize: 14, color: selectedspecialization != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                selectedspecialization = value;
                for (int i = 0; i < _specializationDropdownValues.length; i++) {
                  if (_specializationDropdownValues[i].specialisation == value) {
                    specialisationIdList.add(_specializationDropdownValues[i].id);
                    listSelectedSpec.add(_specializationDropdownValues[i].specialisation);
                  }
                }
              });
            },
          ),
        ),
      ),
    );
  }

  void loadData() {
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
          cityIdList.add(listRes[i][ApiKeys.id]);
        }
        print("DATA cityID ${cityIdList.toString()}");
      });
    });

    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.category).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;

      setState(() {
        mapData = value;
        print('_categoryDropdownValues ${mapData.toString()}');

        _categoryDropdownValues = CategoriesModel.fromJson(mapData).categoryList.toList();
      });
      print('_categoryDropdownValues ${_categoryDropdownValues.toString()}');
    });
  }

  void getLocality() {
    setState(() {
      _localityDropdownValues.clear();
    });
    int index;
    String catId;
    for (int i = 0; i < _cityDropdownValues.length; i++) {
      if (_cityDropdownValues[i] == selectedCity) {
        index = i;
      }
      print("INDEX ${index}");
    }
    for (int i = 0; i < cityIdList.length; i++) {
      catId = cityIdList[index];
    }
    setState(() {
      categoryId = catId;
      // catIdList.clear();
      _localityDropdownValues.clear();
      selectedLoc = null;
    });
    print("INDEX catID ${catId}");
    if (catId != null && catId != '') {
      var map = {'city_id': catId};
      ApiHandler.postApi(ApiProvider.baseUrl, EndApi.locality, map).then((value) {
        Map<String, dynamic> mapData;
        List<dynamic> listRes;
        setState(() {
          mapData = value;
          listRes = mapData[ApiKeys.localatyList];
          print("DATA ${mapData.toString()}");
          print("DATA ${listRes.toString()}");
        });
        for (int i = 0; i < listRes.length; i++) {
          _localityDropdownValues.add(listRes[i][ApiKeys.areaName]);
          //subCatIdList.add(listRes[i][ApiKeys.subCategoryId]);
        }
        print("DATA locality ${_subCategoryDropdownValues.toString()}");
        print("DATA d ${catIdList.toString()}");
      });
    }
  }

  void getSubCategory() {
    _subCategoryDropdownValues.clear();

    var map = {'category_id': catId};
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.subCategory, map).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        _subCategoryDropdownValues = SubCategoryModel.fromJson(mapData).subcategoryList.toList();
        listRes = mapData[ApiKeys.subCatList];
        print("DATA ${mapData.toString()}");
        print("_subCategoryDropdownValues ${_subCategoryDropdownValues.length}");
      });
    });
  }

  void getSpecializations() {
    if (catId != null && catId != '') {
      var map = {'subcategory_id': catId};
      ApiHandler.postApi(ApiProvider.baseUrl, EndApi.specialization, map).then((value) {
        Map<String, dynamic> mapData;
        List<dynamic> listRes;
        setState(() {
          mapData = value;
          listRes = mapData[ApiKeys.specialisationList];
          _specializationDropdownValues = SpecialisationsModel.fromJson(mapData).specialisationList.toList();
          print("DATA d ${_specializationDropdownValues.toString()}");
          print("DATA d ${catIdList.toString()}");
        });
      });
    }
  }

  void getDesignation() {
    var obj = {"category_name": selectedCategory};

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.designation, obj).then((value) {
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
        print("DATA desgnation ${_designationDropdownValues.toString()}");
      });
    });
  }

  getExperienceField() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 60,
          width: Get.size.width / 1.2,
          child: TextField(
            keyboardType: TextInputType.text,
            showCursor: true,
            controller: experienceCtrl,
            cursorWidth: 2,
            autofocus: false,
            style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: false,
              hintText: "Experience",
              hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
              contentPadding: EdgeInsets.only(top: 18, left: 16, bottom: 18),
              errorStyle: TextStyle(height: 0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
            ),
            //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 60,
          width: Get.size.width / 1.2,
          child: TextField(
            keyboardType: TextInputType.text,
            showCursor: true,
            controller: ctcCtrl,
            cursorWidth: 2,
            autofocus: false,
            style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: false,
              hintText: "Cureent CTC",
              hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
              contentPadding: EdgeInsets.only(top: 18, left: 16, bottom: 18),
              errorStyle: TextStyle(height: 0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
            ),
            //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 60,
          width: Get.size.width / 1.2,
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: Container(
                width: Get.size.width - 50,
                height: 52,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(width: 2, color: color.colorConvert('#0457BE'))),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Attach Resume", style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0457BE'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                    Icon(
                      Icons.attach_file,
                      color: color.colorConvert('#0457BE'),
                    )
                  ],
                ))),
          ),
        )
      ],
    );
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
        showLoader = true;
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
        showLoader = true;
        uploader(fileName: fileName, directory: dir);
        setState(() {
          croppedImage = image;
        });
      }
    });
  }

  Future<Map<String, dynamic>> uploader({fileName, directory}) async {
    dynamic prog;
    Map<String, dynamic> map;
    final uploader = FlutterUploader();
    //String fileName = await file.path.split('/').last;

    final taskId = await uploader.enqueue(url: ApiProvider.baseUrlUpload, files: [FileItem(filename: fileName, savedDir: directory)], method: UploadMethod.POST, headers: {"apikey": "api_123456", "userkey": "userkey_123456"}, showNotification: true);
    final subscription = uploader.progress.listen((progress) {});

    final subscription1 = uploader.result.listen((result) {
//    print("Progress result ${result.response}");

      // return result.response;
    }, onError: (ex, stacktrace) {
      setState(() {
        showLoader = false;
      });
    });
    subscription1.onData((data) async {
      map = await json.decode(data.response);
      map = await json.decode(data.response);
      print("PATH data ${map['url']}");
      setState(() {
        showLoader = false;
      });
      uploadedFileUrl = map['url'].toString();
    });
    return map;
  }

  void getDocFromLib() async {
    String filepath = await FilePicker.getFilePath(type: FileType.any, allowedExtensions: extensions);
    String dir = (await getApplicationDocumentsDirectory()).path;

    String imgName = 'oneRoof';
    String extension = File(filepath).path.split('.').last;
    print("NAME extension ${extension}");

    String newPath = path.join(dir, imgName + '.' + extension);
    File f = await File(filepath);
    File ff = await File(f.path).copy(newPath);
    print("NAME ${ff}");
    String fileName = ff.path.split('/').last;
    print("NAME fileName ${fileName}");

    uploader(fileName: fileName, directory: dir);

    /*
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'docx'],
    );
    print("result ${result.paths[0]}");
    setState(() {
      image = File(result.paths[0]);
      String fileName = image.path.split('/').last;
      var dir = image.parent.path;

      print("image ${image}");
      print("fileName ${fileName}");
      print("dir ${dir}");
      showLoader = true;

      uploader(fileName: fileName, directory: dir);
    });
*/
  }

  void submitDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);
    appDb.put('Listdata', '2');
    //catId=catIdList.toString().substring(1,catIdList.toString().length-1).toString();
    print("RESULT userId ${userId}");
    String strSubCategories = listSelectedSubcat.toString().substring(1, listSelectedSubcat.toString().length - 1);

    String strSpecialisation = listSelectedSpec.toString().substring(1, listSelectedSpec.toString().length - 1);

    if (selectedCity != null && selectedLoc != null && orgTextCtrl.value.text.length > 0 && selectedDesignation != null && selectedSubCategory != null) {
      var map = {
        "id": userId,
        "city": selectedCity,
        "locality": selectedLoc,
        "organization_name_work": orgTextCtrl.value.text,
        "designation": selectedDesignation,
        "category": selectedCategory,
        "subcategory": strSubCategories,
        "specialization": strSpecialisation,
        "exp": experienceCtrl.text.toString(),
        "ctc": ctcCtrl.text.toString(),
        "resume_file": uploadedFileUrl,
        'swithched_role': switchedRole == true ? '1' : 0
      };
      print("LLLLLLLLLLLLL ${map.toString()}");
      ApiHandler.putApi(ApiProvider.baseUrl, EndApi.workDetailsUpdate, map).then((value) {
        Map<String, dynamic> mapData;
        setState(() {
          mapData = value;
        });
        appDb.put(ApiKeys.type, accountType);
        print("TYPE ${accountType}");
        if (mapData['result'] == true || mapData['id'] != null) {
          ToastMessages.showToast(message: 'Updated successfully', type: true);

          print("selectedCategory ${selectedCategory}");

          if (selectedCategory == Constants.machineryAndEquipment || selectedCategory == Constants.contractors) {
            Get.to(ProfileCompletion(catIdTemp, selectedCategory, accountType));
          } else {
            Get.to(ThankYouScreen(accountType));
          }
        }
        print("RESULT REQUEST ${map.toString()}");

        print("RESULT RESPONSE ${mapData.toString()}");
      });
      print("USERID ${userId}");
      //Get.to(ProfileCompletion());
    } else {
      ToastMessages.showToast(message: "All Fields Compulsory", type: false);
    }
  }
}
