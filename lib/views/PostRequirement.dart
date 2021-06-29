import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:one_roof/models/CitiesModel.dart';
import 'package:one_roof/models/SpecialisationsModel.dart';
import 'package:one_roof/models/UnitsModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/OrderPage.dart';

class PostRequirement extends StatefulWidget {
  String selectedValue;
  String colorCode, categoryName;
  bool isAssigned;
  List<SpecialisationList> specializationList = [];
  String specialisation;
  PostRequirement({this.selectedValue, this.specialisation, this.colorCode, this.categoryName, this.isAssigned, this.specializationList});

  PostRequirementState createState() => PostRequirementState(selectedValue, specialisation, colorCode, categoryName, isAssigned, specializationList);
}

class PostRequirementState extends State<PostRequirement> {
  String selectedValue, categoryName, selectedUnit, selectedSpecialisation;
  bool isAssigned;
  var selectedCity;
  String selectedBox;
  String specialisation;
  List<String> listProjectType = ['Residential', 'Commercial', 'industrial', 'Institutional', 'Hospitality', 'IT'];
  List<SpecialisationList> _specializationList = [];

  List<String> _specializationDropDownValues = [];
  int listLength = 1;
  List<CitiesList> _cityDropdownValues = [];
  TextEditingController projectNameCtrl, briefCtrl, projectTypeCtrl, qtyCtrl;
  List<TextEditingController> qtyCtrlList = [];
  List<TextEditingController> brandtrlList = [];

  String colorCode, srNo, selectedProjectType;
  bool showLoader = false;
  static bool showLoaderFile = false;
  PostRequirementState(this.selectedValue, this.specialisation, this.colorCode, this.categoryName, this.isAssigned, this._specializationList);
  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  String fcmToken;
  final picker = ImagePicker();
  File image, croppedImage;
  String fileStr, dateStr;
  TextEditingController positionCtrl;
  TextEditingController experienceCtrl;
  static String uploadedFileUrl;
  final List<String> _localityDropdownValues = [];
  List<String> listItemSelected = [];
  List<String> listUnitSelected = [];
  List<UnitsList> unitsList = [];
  double dimens;
  String selectedCityId, selectedLoc;
  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging();
    initNotification();
    getToken();
    super.initState();
    initControllers();
    Future.delayed(Duration(seconds: 2), () {
      checkIsAssigned();
      qtyCtrl = TextEditingController();
      uploadedFileUrl = " ";
      print("categoryName ${uploadedFileUrl}");
    });

    getLocations();
    getUnits();
  }

  List<String> selectedItemValue = List<String>();
  List<String> selectedUnitValues = List<String>();

  List<DropdownMenuItem<String>> _dropDownItems() {
    List<String> ddl = ["Select items"];
    for (int i = 0; i < _specializationList.length; i++) {
      ddl.add(_specializationList[i].specialisation);
    }

    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> _dropDownItemsUnits() {
    List<String> ddl = ["units"];
    for (int i = 0; i < unitsList.length; i++) {
      ddl.add(unitsList[i].unit);
    }

    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    dimens = MediaQuery.of(context).size.height;
    return Scaffold(
        //resizeToAvoidBottomPadding:false,
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
                            child: Text(selectedValue, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700)),
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
        body: showLoader == false
            ? SingleChildScrollView(
                child: showLoader == false
                    ? IntrinsicHeight(
                        // height:Get.size.height/1.4,
                        //height:dimens<=725?Get.size.height/1.2:Get.size.height/1.4,
                        child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Expanded(
                            flex: dimens >= 725 ? 2 : 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppStrings.postRequirement, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#343048').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              flex: categoryName == Constants.machineryAndEquipment || categoryName == "Construction Material" || categoryName == 'Product Vendors'
                                  ? listLength < 3
                                      ? 28
                                      : 38
                                  : 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      categoryName != 'HR Management'
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  getProjectName(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  getProjectType(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  getCityDropDown(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  getLocalityDropdown(),
                                                ],
                                              ),
                                            )
                                          : getHrManagementBox(),
                                      categoryName == Constants.machineryAndEquipment || categoryName == Constants.constructionMaterial
                                          ? getCustomBoxMachinery()
                                          : categoryName == "Contractors"
                                              ? getContractorCustomBox()
                                              : categoryName == 'Product Vendors'
                                                  ? getProductVendorBox()
                                                  : Container(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      getBriefDescription(),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      getUploadbutton()
                                    ],
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Expanded(flex: 2, child: getSubmitButton()),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ))
                    : displayLoader())
            : displayLoader());
  }

  void getLocations() {
    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.cities).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        listRes = mapData[ApiKeys.citiesList];
        print("DATA ${mapData.toString()}");
        print("DATA ${listRes.toString()}");
        _cityDropdownValues.clear();
        _cityDropdownValues = CitiesModel.fromJson(mapData).citiesList;
        /*for (int i = 0; i < listRes.length; i++) {
          _cityDropdownValues.add(listRes[i][ApiKeys.cityName]);
        }*/
        print("DATA cityID ${_cityDropdownValues.toString()}");
      });
    });
  }

  void displayPopupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
              height: Get.size.height / 2.2,
              width: Get.size.width / 1.1,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(flex: 4, child: Container()),
                      Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(top: 14),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(OrderPage());
                                },
                                child: SvgPicture.asset(
                                  'assets/images/Icon_close.svg',
                                  height: 23,
                                  width: 23,
                                  color: Colors.black54,
                                ),
                              )))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: Get.size.height / 2.8,
                        width: Get.size.width / 1.3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Image.asset(
                                'assets/images/thank you for request graphic.png',
                                scale: 0.9,
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(AppStrings.thankForReq, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#343048').withOpacity(0.6), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                    Text(AppStrings.contactSoon, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#343048').withOpacity(0.6), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                  ],
                                )),
                            Expanded(flex: 1, child: Text(AppStrings.serialNoIs + " " + srNo, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w700, letterSpacing: 0.0))))
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void postRequirment() {
    print("REQUEST selectedItemValue${selectedItemValue.toString()} ${listUnitSelected.toString()}");
    List<dynamic> listRequest = [];

    List<String> listTempItems = [];
    List<String> listTempUnits = [];
    var mapMachinery = {};
    var mapBrands = {};
    List<dynamic> brandList = [];
    if (categoryName == Constants.machineryAndEquipment || categoryName == "Construction Material") {
      for (int i = 0; i < listLength; i++) {
        if (selectedItemValue[i] != "Select items") {
          listTempItems.add(selectedItemValue[i]);
          mapMachinery = {"items": selectedItemValue[i], "units": selectedUnitValues[i], "quantity": qtyCtrlList[i].text.toString()};
          listRequest.add(mapMachinery);
        }
      }
    } else if (categoryName == 'Product Vendors') {
      List<String> qtyList = [];
      print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");

      for (int i = 0; i < listLength; i++) {
        mapBrands = {"brand": brandtrlList[i].text, "quantity": qtyCtrlList[i].text.toString()};

        brandList.add(mapBrands);
      }
    } else if (categoryName != Constants.hrManagement || categoryName == Constants.projectMAnagement) {}
    print("REQUEST r ${mapBrands.toString()}");
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);
    setState(() {
      showLoader = false;
    });
    var map = {
      'user_id': userId,
      'project_name': projectNameCtrl.text != null ? projectNameCtrl.text : " ",
      'project_type': selectedProjectType != null ? selectedProjectType : "",
      'project_location': selectedLoc != null ? selectedLoc : "",
      'city': selectedCity,
      'brief_description': briefCtrl.value.text,
      'file': uploadedFileUrl != null ? uploadedFileUrl : "exampleUrl",
      'category_name': categoryName,
      'fcm_token': fcmToken,
      'quantity': qtyCtrl.text.toString(),
      'unit': selectedUnit.toString() != null ? selectedUnit.toString() : "",
      "me_details": json.encode(listRequest),
      "brand": json.encode(brandList),
      "position": positionCtrl.text != null ? positionCtrl.text : "",
      "experience": experienceCtrl.text != null ? experienceCtrl.text : "",
      "subcategory": specialisation != null ? specialisation : "unspecified",
      "specialization": selectedValue != null ? selectedValue : "unspecified",
      "within_date": dateStr.toString(),
    };
    print("REQUEST D ${map.toString()}");
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.requirementsPost, map).then((value) {
      print("RESPONSE ${value.toString()}");

      if (value['user_id'] != null) {
        setState(() {
          srNo = value['sr_no'];
          showLoader = false;
        });
        showLoader = false;
        displayPopupDialog(context);
      }
    });
  }

  displayLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  void getToken() async {
    await _firebaseMessaging.getToken().then((value) async {
      setState(() {
        fcmToken = value;
      });
    });
    print("fcmToken ${fcmToken}");
  }

  void initNotification() async {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> map) async {
      print("Notification ${map['notification']}");
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
      print("Notification l${map.toString()}");
      //_showNotification(map);
    },
        //onBackgroundMessage:myBackgroundHandler,
        onResume: (Map<String, dynamic> map) async {
      print("Notification r ${map.toString()}");
    });
  }

  Future _showNotification(Map<String, dynamic> mesage) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_ID', 'channel_name', 'channel description',
        importance: Importance.high,
        playSound: true,
        // sound: 'sound',
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    print("Channel :${platformChannelSpecifics.android.channelId}");
    await flutterLocalNotificationsPlugin.show(0, mesage['title'], mesage['body'], platformChannelSpecifics, payload: 'Default_Sound');
  }

  void _showPicker(BuildContext context) async {
    Future<void> _showPicker(BuildContext context) async {
      await showModalBottomSheet(
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
  }

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
      showLoaderFile = true;
      showLoader = true;
      // uploadImage(ApiProvider.baseUrlUpload,image);
      uploader(fileName: fileName, directory: dir, image: image);
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        String fileName = image.path.split('/').last;
        var dir = image.parent.path;
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

  Future<Map<String, dynamic>> uploader({fileName, directory, File image}) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiProvider.baseUrlUpload));
    dynamic prog;
    Map<String, dynamic> map;
    final uploader = FlutterUploader();
    String fileName = await image.path.split('/').last;

    print("FILENAME ${fileName} FILENAME ${directory}");

    final taskId = await uploader.enqueue(url: ApiProvider.baseUrlUpload, files: [FileItem(filename: fileName, savedDir: directory)], method: UploadMethod.POST, headers: {"apikey": "api_123456", "userkey": "userkey_123456"}, showNotification: true);
    final subscription = uploader.progress.listen((progress) {});
    final subscription1 = uploader.result.listen((result) {
//    print("Progress result ${result.response}");
      // return result.response;
    }, onError: (ex, stacktrace) {
      showLoaderFile = false;
      showLoader = false;
    });
    subscription1.onData((data) async {
      map = await json.decode(data.response);
      print("PATH data ${map['url']}");
      showLoaderFile = false;
      setState(() {
        showLoader = false;
      });
      uploadedFileUrl = map['url'].toString();
    });
    return map;
  }

  uploadImage(String url, File croppedImage) async {
    var postUri = Uri.parse(url);
    print('URI ${url}${croppedImage}');
    Map<String, dynamic> map;
    http.MultipartRequest request = await new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', croppedImage.path);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();
    String imgUrl;
    response.stream.transform(utf8.decoder).listen((event) {
      print("IMG_RESPONSE ${event}");
      setState(() {
        map = json.decode(event);
        print("IMG_RESPONSE ${map.toString()}");
      });
      Get.back();

      setState(() {});
    });
  }

  void getLocality() {
    setState(() {
      _localityDropdownValues.clear();
      selectedLoc = null;
    });
    if (selectedCityId != null && selectedCityId != '') {
      var map = {'city_id': selectedCityId};
      ApiHandler.postApi(ApiProvider.baseUrl, EndApi.locality, map).then((value) {
        Map<String, dynamic> mapData;
        List<dynamic> listRes;
        setState(() {
          mapData = value;
          listRes = mapData[ApiKeys.localatyList];
          print("DATA  locality${mapData.toString()}");
          print("DATA ${listRes.toString()}");
        });
        for (int i = 0; i < listRes.length; i++) {
          _localityDropdownValues.add(listRes[i][ApiKeys.areaName]);
          //subCatIdList.add(listRes[i][ApiKeys.subCategoryId]);
        }
      });
    }
  }

  getProjectType() {
    return Container(
      height: 54,
      width: Get.size.width / 1.1,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: selectedBox != Constants.projectType ? Colors.black38 : color.colorConvert(colorCode))),
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
            value: selectedProjectType,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            icon: Image.asset(
              'assets/images/dropDown_icon.png',
              height: 22,
              width: 22,
            ),
            items: listProjectType.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            hint: Text(
              "Select Project Type",
              style: TextStyle(fontSize: 14, color: selectedProjectType != null ? Colors.black87 : Colors.black54, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedBox = Constants.projectType;
                selectedProjectType = value;
              });
            },
          ),
        ),
      ),
    );
  }

  void checkIsAssigned() {
    if (isAssigned == false) {
      displayDialogAdmin(categoryName: categoryName);
    }
  }

  void displayDialogAdmin({String categoryName}) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Container(
            width: Get.size.width / 1.2,
            height: Get.size.height / 2.4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.white),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12, top: 10, left: 12),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(
                          'assets/images/Icon_close.svg',
                          height: dimens > 750 ? 23 : 18,
                          width: dimens > 750 ? 23 : 18,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/images/Sorry graphic.png',
                  scale: dimens > 750 ? 0.9 : 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Based on your request we are', maxLines: 3, style: TextStyle(fontSize: dimens > 750 ? 15 : 12, color: Colors.black87, fontWeight: FontWeight.w400)),
                Text('unable to process your', maxLines: 3, style: TextStyle(fontSize: dimens > 750 ? 15 : 12, color: Colors.black87, fontWeight: FontWeight.w400)),
                Text('request in this section', maxLines: 3, style: TextStyle(fontSize: dimens > 750 ? 15 : 12, color: Colors.black87, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width / 2.4,
                      height: dimens > 750 ? 55 : 48,
                      child: RaisedButton(
                          child: Text(
                            AppStrings.contactAdmin,
                            style: TextStyle(fontSize: dimens > 750 ? 16 : 12, color: Colors.white),
                          ),
                          color: color.colorConvert(color.primaryColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          onPressed: () {
                            postRequestAccess(categoryName: categoryName);
                            Get.back();
                          }),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void postRequestAccess({String categoryName}) {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);

    var map = {'user_id': userId, 'category_name': categoryName, 'fcm_token': fcmToken};
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.serviceAccess, map).then((value) {
      print("RRRRRRRRRRRRR ${value.toString()}");
      ToastMessages.showToast(message: 'Access request sent to admin', type: true);
      if (value['user_id' != null]) {
        ToastMessages.showToast(message: 'Access request sent to admin', type: true);
      }
    });
  }

  getProjectName() {
    return SizedBox(
      height: 65,
      width: Get.size.width / 1.1,
      child: TextFormField(
        controller: projectNameCtrl,
        onTap: () {
          setState(() {
            selectedBox = Constants.none;
          });
        },

        keyboardType: TextInputType.text,
        showCursor: true,
        cursorWidth: 2,
        autofocus: false,
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          isDense: true,
          hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
          hintText: "Project Name",
          errorStyle: TextStyle(height: 0),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: color.colorConvert(colorCode))),
        ),
        //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
      ),
    );
  }

  getCityDropDown() {
    return Container(
      height: 54,
      width: Get.size.width / 1.1,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: selectedBox != Constants.city ? Colors.black38 : color.colorConvert(colorCode))),
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
            items: _cityDropdownValues.map<DropdownMenuItem<String>>((CitiesList value) {
              return DropdownMenuItem<String>(
                value: value.cityName,
                child: Text(
                  value.cityName,
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
                for (int i = 0; i < _cityDropdownValues.length; i++) {
                  if (_cityDropdownValues[i].cityName == value) {
                    setState(() {
                      selectedBox = Constants.city;
                      selectedCityId = _cityDropdownValues[i].id;
                    });
                  }
                }
                getLocality();
              });
            },
          ),
        ),
      ),
    );
  }

  getLocalityDropdown() {
    return Column(
      children: [
        Container(
          height: 54,
          width: Get.size.width / 1.1,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: selectedBox != Constants.location ? Colors.black38 : color.colorConvert(colorCode))),
          child: Center(
            child: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  backgroundColor: color.colorConvert(colorCode),
                  focusColor: color.colorConvert(colorCode),
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
                  "Select your project location",
                  style: TextStyle(fontSize: 14, color: selectedLoc != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    selectedBox = Constants.location;
                    selectedLoc = value;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: EdgeInsets.only(top: 2),
          width: Get.size.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(flex: 3, child: Container()),
              Expanded(
                flex: 4,
                child: Text(AppStrings.selectNearby, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  getBriefDescription() {
    return Container(
      width: Get.size.width / 1.1,
      child: TextField(
        controller: briefCtrl,
        keyboardType: TextInputType.text,
        showCursor: true,
        cursorWidth: 2,
        onTap: () {
          setState(() {
            selectedBox = Constants.none;
          });
        },
        maxLines: 4,
        autofocus: false,
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          isDense: true,
          hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
          hintText: "Brief Description",
          errorStyle: TextStyle(height: 0),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: color.colorConvert(colorCode))),
        ),
        //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
      ),
    );
  }

  getUploadbutton() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedBox = Constants.file;
            });
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
          },
          child: Container(
              width: Get.size.width - 50,
              height: 56,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(width: 1, color: selectedBox != Constants.file ? Colors.black38 : color.colorConvert(colorCode))),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 10,
                    child: Text(fileStr == null ? "Attach File" : fileStr, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: Colors.black38, fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                  ),
                  Expanded(
                    flex: 2,
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.black38,
                    ),
                  )
                ],
              ))),
        ),
        Container(
          margin: EdgeInsets.only(top: 2),
          width: Get.size.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(flex: 3, child: Container()),
              Expanded(
                flex: 2,
                child: Text(AppStrings.maxSize, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w700, letterSpacing: 0.0))),
              )
            ],
          ),
        ),
      ],
    );
  }

  getSubmitButton() {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width / 2.4,
      height: 50,
      child: RaisedButton(
          child: Text(
            AppStrings.submit,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          color: color.colorConvert(colorCode),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          onPressed: () {
            if (categoryName != 'HR Management') {
              if (projectNameCtrl.value.text.length > 0 && briefCtrl.value.text.length > 0 && selectedValue != null) {
                if (isAssigned == true) {
                  postRequirment();
                  /*setState(() {
                  showLoader=true;
                });*/
                } else {
                  checkIsAssigned();
                }
              } else {
                ToastMessages.showToast(message: 'All fields compulsory', type: false);
              }
            } else if (positionCtrl.text.length > 0 && experienceCtrl.text.length > 0 && selectedCity != null) {
              postRequirment();
            } else {
              ToastMessages.showToast(message: 'All fields compulsory', type: false);
            }
            // displayPopupDialog(context);
          }),
    );
  }

  getCustomBoxMachinery() {
    return Column(
      children: [
        Container(
          width: Get.size.width,
          height: listLength * 125.toDouble(),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: listLength,
              itemBuilder: (context, index) {
                qtyCtrlList.add(TextEditingController());
                for (int i = 0; i < _specializationList.length; i++) {
                  selectedItemValue.add("Select items");
                  selectedUnitValues.add("units");
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              --listLength;
                            });
                          },
                          child: Text(
                            "Remove",
                            style: TextStyle(fontSize: 12, color: color.colorConvert(colorCode), fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              //  width: Get.size.width /2.4,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
                              child: Center(
                                child: Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white,
                                        // background color for the dropdown items
                                        buttonTheme: ButtonTheme.of(context).copyWith(
                                          alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
                                        )),
                                    child: DropdownButton(
                                      underline: Container(
                                        height: 1.0,
                                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))),
                                      ),
                                      icon: Image.asset(
                                        'assets/images/dropDown_icon.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                      style: TextStyle(fontSize: 13, color: selectedItemValue[index] != null && selectedItemValue[index] != 'Select items' ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
                                      isExpanded: true,
                                      value: selectedItemValue[index] != null ? selectedItemValue[index].toString() : "Item",
                                      items: _dropDownItems(),
                                      onChanged: (value) {
                                        selectedItemValue[index] != null ? selectedItemValue[index] = value : selectedItemValue[index] = "vvv";
                                        setState(() {});
                                      },
                                      hint: Text('Item'),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                SizedBox(height: 18),
                                Container(
                                  height: 50,
                                  //  width:Get.size.width/4,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
                                  child: TextField(
                                    controller: qtyCtrlList[index],
                                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 12),
                                      border: tranparentBorder,
                                      focusedBorder: tranparentBorder,
                                      disabledBorder: tranparentBorder,
                                      hintText: categoryName != Constants.machineryAndEquipment ? 'Work Qty' : 'Nos',
                                      hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                // SizedBox(height:10),
                                Text(
                                  'Approx',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              // width:Get.size.width/3.5,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
                              child: Center(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      canvasColor: Colors.white,
                                      // background color for the dropdown items
                                      buttonTheme: ButtonTheme.of(context).copyWith(
                                        alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
                                      )),
                                  child: DropdownButton(
                                    underline: Container(
                                      height: 1.0,
                                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 0.0))),
                                    ),
                                    icon: Image.asset(
                                      'assets/images/dropDown_icon.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    style: TextStyle(fontSize: 14, color: selectedUnitValues[index] != null && selectedUnitValues[index] != 'units' ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
                                    value: selectedUnitValues[index] != null ? selectedUnitValues[index].toString() : "Item",
                                    items: _dropDownItemsUnits(),
                                    onChanged: (value) {
                                      selectedUnitValues[index] != null ? selectedUnitValues[index] = value : selectedUnitValues[index] = "vvv";
                                      setState(() {});
                                    },
                                    hint: Text('Item'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              ++listLength;
              selectedBox = Constants.addMore;
            });
            print("listLength ${listLength}");
          },
          child: Container(
            width: Get.size.width / 1.1,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: selectedBox != Constants.addMore ? Colors.black38 : color.colorConvert(colorCode))),
            child: Center(
              child: Text('Add more'),
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
        GestureDetector(
          onTap: () {
            selectDate();
          },
          child: Container(
            width: Get.size.width / 1.1,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: selectedBox != Constants.requiredWithin ? Colors.black38 : color.colorConvert(colorCode))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateStr == null ? 'Requirement before' : dateStr),
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getUnits() {
    ApiHandler.requestApi(
      ApiProvider.baseUrl,
      EndApi.units,
    ).then((value) {
      print("UNITS ${value}");
      setState(() {
        unitsList = UnitsModel.fromJson(value).unitsList.toList();
      });
    });
  }

  getContractorCustomBox() {
    return Container(
      width: Get.size.width / 1.1,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: Get.size.width / 2.4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
            child: TextField(
              controller: qtyCtrl,
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 12),
                border: tranparentBorder,
                focusedBorder: tranparentBorder,
                disabledBorder: tranparentBorder,
                hintText: 'Work Qty',
                hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            height: 50,
            width: Get.size.width / 2.4,
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
                  value: selectedUnit,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  icon: Image.asset(
                    'assets/images/dropDown_icon.png',
                    height: 22,
                    width: 22,
                  ),
                  items: unitsList.map<DropdownMenuItem<String>>((UnitsList value) {
                    print("DDD ${value.id}");
                    return DropdownMenuItem<String>(
                      value: value.unit,
                      child: Text(
                        value.unit,
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    AppStrings.unit,
                    style: TextStyle(fontSize: 14, color: selectedUnit != null ? Colors.black : Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      selectedUnit = value;
                      print("selectedCategory ${selectedUnit.toString()}");
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  var tranparentBorder = UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  void initControllers() {
    projectNameCtrl = TextEditingController();
    briefCtrl = TextEditingController();
    positionCtrl = TextEditingController();
    experienceCtrl = TextEditingController();
  }

  Future<Null> selectDate() async {
    var picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
              primary: color.colorConvert(color.primaryColor),
              onPrimary: Colors.white,
              surface: color.colorConvert("#39003E"),
            )),
            child: child,
          );
        });
    setState(() {
      selectedBox = Constants.requiredWithin;

      var myFormat = DateFormat('yyyy-MM-dd');

      dateStr = myFormat.format(picked).toString();
    });
  }

  getProductVendorBox() {
    return Column(
      children: [
        Container(
          width: Get.size.width,
          height: listLength * 160.toDouble(),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: listLength,
              itemBuilder: (context, index) {
                qtyCtrlList.add(TextEditingController());
                brandtrlList.add(TextEditingController());

                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              --listLength;
                            });
                          },
                          child: Text(
                            "Remove",
                            style: TextStyle(fontSize: 12, color: color.colorConvert(colorCode), fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 50,
                            width: Get.size.width / 1.1,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
                            child: TextField(
                              controller: brandtrlList[index],
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 12),
                                border: tranparentBorder,
                                focusedBorder: tranparentBorder,
                                disabledBorder: tranparentBorder,
                                hintText: 'Brand',
                                hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 50,
                            width: Get.size.width / 1.1,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: Colors.black38)),
                            child: TextField(
                              controller: qtyCtrlList[index],
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 12),
                                border: tranparentBorder,
                                focusedBorder: tranparentBorder,
                                disabledBorder: tranparentBorder,
                                hintText: 'Qty',
                                hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              ++listLength;
              selectedBox = Constants.addMore;
            });
            print("listLength ${listLength}");
          },
          child: Container(
            width: Get.size.width / 1.1,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: selectedBox != Constants.addMore ? Colors.black38 : color.colorConvert(colorCode))),
            child: Center(
              child: Text('Add more'),
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
        GestureDetector(
          onTap: () {
            selectDate();
          },
          child: Container(
            width: Get.size.width / 1.1,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(width: 1, color: selectedBox != Constants.requiredWithin ? Colors.black38 : color.colorConvert(colorCode))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateStr == null ? 'Requirement before' : dateStr),
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  getHrManagementBox() {
    return Column(
      children: [
        SizedBox(
          height: 65,
          width: Get.size.width / 1.1,
          child: TextFormField(
            controller: positionCtrl,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            keyboardType: TextInputType.number,
            onTap: () {
              setState(() {
                selectedBox = Constants.none;
              });
            },
            showCursor: true,
            cursorWidth: 2,
            autofocus: false,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: true,
              hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
              hintText: "Number of positions required",
              errorStyle: TextStyle(height: 0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: color.colorConvert(colorCode))),
            ),
            //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 65,
          width: Get.size.width / 1.1,
          child: TextFormField(
            controller: experienceCtrl,
            onTap: () {
              setState(() {
                selectedBox = Constants.none;
              });
            },

            keyboardType: TextInputType.text,
            showCursor: true,
            cursorWidth: 2,
            autofocus: false,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: true,
              hintStyle: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
              hintText: "Experience Required",
              errorStyle: TextStyle(height: 0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.black38)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: color.colorConvert(colorCode))),
            ),
            //cursorColor:color.colorConvert(color.PRIMARY_COLOR),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        getCityDropDown(),
      ],
    );
  }
}
