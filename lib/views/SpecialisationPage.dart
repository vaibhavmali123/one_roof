import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/models/SpecialisationsModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/PostRequirement.dart';

class SpecialisationPage extends StatefulWidget {
  String specialisation, id, categoryName;
  bool isAssigned;

  String color;
  SpecialisationPage(this.id, this.specialisation, this.color, this.categoryName, this.isAssigned);

  SpecialisationPageState createState() => SpecialisationPageState(id, specialisation, color, categoryName, isAssigned);
}

class SpecialisationPageState extends State<SpecialisationPage> {
  bool isAssigned;

  String specialisation, id, categoryName;
  List<SpecialisationList> _specializationList = [];
  var groupValue, selectedValue;
  int indexSelected;
  bool showLoader = true;
  String colorCode;
  double dimens;
  String fcmToken;
//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SpecialisationPageState(this.id, this.specialisation, this.colorCode, this.categoryName, this.isAssigned);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.configureNotification();
    //   getToken();

    getSpecialisations();
    print("DATA ${id}");
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
                  height: 15,
                ),
                AppBar(
                  backgroundColor: Colors.white,
                  elevation: 2,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    Container(
                      width: Get.size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                  'assets/images/back_icon.png',
                                  scale: 1.8,
                                ),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text(specialisation, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
        body: showLoader != true
            ? Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(flex: 1, child: getTopTextLine()),
                    Expanded(flex: 16, child: getList()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width / 2.4,
                          height: 52,
                          child: _specializationList != null
                              ? RaisedButton(
                                  child: Text(
                                    AppStrings.select,
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  color: color.colorConvert(colorCode),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                  onPressed: () {
                                    print("DATA ${selectedValue}");
                                    if (selectedValue != null) {
                                      Get.to(PostRequirement(
                                        selectedValue: selectedValue,
                                        specialisation: specialisation,
                                        colorCode: colorCode,
                                        categoryName: categoryName,
                                        isAssigned: isAssigned,
                                        specializationList: _specializationList,
                                      ));
                                    } else {
                                      ToastMessages.showToast(message: AppStrings.selectSpec, type: false);
                                    }
                                  })
                              : Container(),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : displayLoader());
  }

  void getSpecialisations() {
    var map = {'subcategory_id': id};

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.specialization, map).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        _specializationList = SpecialisationsModel.fromJson(value).specialisationList.toList();
        /*mapData = value;
        _specializationList = mapData[ApiKeys.specialisationList];
        print("DATA ${mapData.toString()}");*/
        showLoader = false;
      });
    });
  }

  getTopTextLine() {
    return _specializationList != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select " + categoryName + " specialisation", maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#343048').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
            ],
          )
        : Container();
  }

  getList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Get.size.width,
          margin: EdgeInsets.only(top: 30),
          child: _specializationList != null || _specializationList.length > 0
              ? ListView.builder(
                  itemCount: _specializationList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50,
                                width: 40,
                                child: Radio(
                                    activeColor: color.colorConvert(colorCode),
                                    value: _specializationList[index].specialisation,
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        indexSelected = index;
                                        groupValue = value;
                                        selectedValue = value;
                                      });
                                    }),
                              )),
                          Expanded(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexSelected = index;
                                    groupValue = _specializationList[index].specialisation;
                                    selectedValue = _specializationList[index].specialisation;
                                  });
                                },
                                child: Text(_specializationList[index].specialisation,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: index != indexSelected ? color.colorConvert('#6B6977') : color.colorConvert(colorCode), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                              )),
                          Expanded(flex: 1, child: Container()),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Comming soon',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black54),
                  ),
                ),
        )
      ],
    );
  }

  displayLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

/*
  void getToken() async {
    await _firebaseMessaging.getToken().then((value) async {
      setState(() {
        fcmToken = value;
      });
    });
    print("fcmToken ${fcmToken}");
  }
*/
}
