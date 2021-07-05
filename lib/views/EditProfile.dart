import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/models/ProfileData.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';

class EditProfile extends StatefulWidget {
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  List<Result> listResult = [];
  TextEditingController nameCtrl;
  TextEditingController mnoCtrl;
  TextEditingController emailCtrl;
  TextEditingController addressCtrl;
  TextEditingController panCtrl;
  TextEditingController gstCtrl;
  TextEditingController experienceCtrl;

  bool showLoader = true;
  final picker = ImagePicker();
  File image, croppedImage;
  Box<String> appDb;
  String profileUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initControlls();
    NotificationService.configureNotification();

    appDb = Hive.box(ApiKeys.appDb);
    profileUrl = appDb.get(ApiKeys.profileUrl);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double dimens = MediaQuery.of(context).size.height;

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
                elevation:0,
                automaticallyImplyLeading:false,
                centerTitle: true,
                actions: [

                  Container(
                    width:Get.size.width,
                    child:Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex:1,
                            child:GestureDetector(
                              onTap:(){
                                Get.back();
                              },
                              child: Image.asset(
                                'assets/images/back_icon.png',
                                scale: 1.8,
                              ),
                            )),
                        Expanded(
                            flex:5,
                            child:Container(
                              child:Text('Edit Profile',
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          color: color.colorConvert('#343048'),
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.0))),
                            )),
                        Expanded(
                          flex:1,
                          child:Container(),
                        )
                      ],
                    ),
                  ),

                ],
              )
            ],
          )),
      body: Stack(
        children: [
          showLoader == false
              ? Container(
                  height: Get.size.height,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Container(
                        height: dimens <= 725 ? Get.size.height + 90 : Get.size.height / 0.9,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          _showPicker(context);
                                        },
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                                radius: croppedImage == null ? 60 : 50,
                                                backgroundColor: Colors.white,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(80.0),
                                                  child: profileUrl == null
                                                      ? croppedImage == null
                                                          ? Image.asset(
                                                              'assets/images/profile pic.png',
                                                            )
                                                          : Image.file(
                                                              croppedImage,
                                                              fit: BoxFit.fill,
                                                            )
                                                      : Image.network(
                                                          profileUrl,
                                                          width: 90,
                                                          height: 90,
                                                        ),
                                                )),
                                            Positioned(
                                                top: 70,
                                                left: 70,
                                                child: Container(
                                                  height: 32,
                                                  width: 32,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: color.colorConvert('##EBF2FA').withOpacity(1)),
                                                  child: Center(
                                                    child: Image.asset(
                                                      'assets/images/Icon material-edit.png',
                                                      scale: 1,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              //height:Get.size.height,
                              width: Get.size.width / 1.1,
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('Organization Name'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 55,
                                    child: TextFormField(
                                      autofocus: false,
                                      controller: nameCtrl,
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
                                    ),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Mobile Number'),
                                    ],
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    maxLength: 10,
                                    enabled: false,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: mnoCtrl,
                                    cursorHeight: 24,

                                    // onChanged:block.emailChanged,
                                    decoration: InputDecoration(
                                        helperStyle: TextStyle(fontSize: 0),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                                        isDense: false,
                                        contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                                        prefixIcon: Image.asset('assets/images/Icon_feather_phone_call.png'),
                                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Email'),
                                    ],
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    controller: emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorHeight: 24,
                                    // onChanged:block.emailChanged,
                                    decoration: InputDecoration(
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
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Address'),
                                    ],
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    controller: addressCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorHeight: 24,
                                    maxLines: 2,
                                    // onChanged:block.emailChanged,
                                    decoration: InputDecoration(
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                                        isDense: false,
                                        contentPadding: EdgeInsets.only(bottom: 0, top: 15, left: 30),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                                        prefixIcon: Icon(
                                          Icons.add_location,
                                          color: Colors.black54,
                                          size: 24,
                                        ),
                                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Experience.'),
                                    ],
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    controller: experienceCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorHeight: 24,
                                    decoration: InputDecoration(
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                                        isDense: false,
                                        contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                                        prefixIcon: Icon(
                                          Icons.offline_pin,
                                          color: Colors.black54,
                                          size: 24,
                                        ),
                                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Pan No.'),
                                    ],
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    controller: panCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorHeight: 24,
                                    // onChanged:block.emailChanged,
                                    decoration: InputDecoration(
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                                        isDense: false,
                                        contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                                        prefixIcon: Icon(
                                          Icons.edit,
                                          color: Colors.black54,
                                          size: 24,
                                        ),
                                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('GST No.'),
                                    ],
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    controller: gstCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorHeight: 24,
                                    // onChanged:block.emailChanged,
                                    decoration: InputDecoration(
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                                        isDense: false,
                                        contentPadding: EdgeInsets.only(bottom: 6, top: 4, left: 30),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 30, maxWidth: 40),
                                        prefixIcon: Icon(
                                          Icons.edit,
                                          color: Colors.black54,
                                          size: 24,
                                        ),
                                        focusedBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.black))),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        width: Get.size.width / 3,
                                        child: RaisedButton(
                                            child: Text(
                                              'Save',
                                              style: TextStyle(fontSize: 16, color: Colors.white),
                                            ),
                                            color: color.colorConvert(color.primaryColor),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                            onPressed: () {
                                              setState(() {
                                                showLoader = true;
                                              });
                                              updateProfile();
                                            }),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        )),
                  ),
                )
              : displayLoader()
        ],
      ),
    );
  }

  void loadData() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);
    var map = {'user_id': userId};
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.showProfile, map).then((value) {
      print("userId ll${userId}");

      ProfileData profileData = ProfileData();
      profileData = ProfileData.fromJson(value);
      print("RESPONSE l${profileData.result.length}");

      setState(() {
        listResult = profileData.result;
        showLoader = false;
      });
      print("RESPONSE l${listResult[0].gstNo}");
      String name = listResult[0].firstName;
      nameCtrl.text = listResult[0].organizationNameWork != null || listResult[0].organizationNameWork != "" ? listResult[0].organizationNameWork : listResult[0].orgnizationNameHire;
      //nameCtrl.text = listResult[0].firstName;
      mnoCtrl.text = listResult[0].mobileNumber;
      emailCtrl.text = listResult[0].email;
      addressCtrl.text = listResult[0].address;
      panCtrl.text = listResult[0].panNo;
      gstCtrl.text = listResult[0].gstNo; //experience
      experienceCtrl.text = listResult[0].experience;
      //gstCtrl.text=listResult[0].e;
    });
  }

  void initControlls() {
    nameCtrl = TextEditingController();
    mnoCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    panCtrl = TextEditingController();
    gstCtrl = TextEditingController();
    experienceCtrl = TextEditingController();
  }

  void updateProfile() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);
    String type = appDb.get(ApiKeys.type);
    var map = {"id": userId, "types": type, "organization_name": nameCtrl.value.text, "mobile_number": mnoCtrl.value.text, "email": emailCtrl.value.text, "address": addressCtrl.value.text, "pan_no": panCtrl.value.text, "gst_no": gstCtrl.value.text, "experience": experienceCtrl.text};
    ApiHandler.putApi(ApiProvider.baseUrl, EndApi.editProfile, map).then((value) {
      setState(() {
        showLoader = false;
        //appDb.put(ApiKeys.first_name, nameCtrl.value.text);
        appDb.put(ApiKeys.mobile_number, mnoCtrl.value.text);
        appDb.put(ApiKeys.email, emailCtrl.value.text);
        appDb.put(ApiKeys.address, addressCtrl.value.text);
      });
      if (value['result'] == true) {
        ToastMessages.showToast(message: 'Updated Successfully', type: true);
      } else {
        ToastMessages.showToast(message: 'Not updated Successfully', type: false);
      }
    });
  }

  displayLoader() {
    return Center(
      child: CircularProgressIndicator(),
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
        _cropImage();
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        _cropImage();
        setState(() {});
        String fileName = croppedImage.path.split('/').last;
        var dir = croppedImage.parent.path;
        uploader(fileName: fileName, directory: dir);
      }
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        maxWidth: 200,
        maxHeight: 200,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9]
            : [CropAspectRatioPreset.original, CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio5x3, CropAspectRatioPreset.ratio5x4, CropAspectRatioPreset.ratio7x5, CropAspectRatioPreset.ratio16x9],
        androidUiSettings: AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: color.colorConvert(color.primaryColor), toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.ratio5x4, lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        croppedImage = croppedFile;
        String fileName = croppedImage.path.split('/').last;
        var dir = croppedImage.parent.path;
        uploader(fileName: fileName, directory: dir);
        // uploadImage("ShubhamLarotiImage","https://xy2y3lhble.execute-api.ap-south-1.amazonaws.com/dev");
      });
    }
  }

  static Future<Map<String, dynamic>> uploader({fileName, directory}) async {
    dynamic prog;
    Map<String, dynamic> map;
    final uploader = FlutterUploader();
    //String fileName = await file.path.split('/').last;

    final taskId = await uploader.enqueue(url: ApiProvider.baseUrlUpload, files: [FileItem(filename: fileName, savedDir: directory)], method: UploadMethod.POST, headers: {"apikey": "api_123456", "userkey": "userkey_123456"}, showNotification: true);
    final subscription = uploader.progress.listen((progress) {});

    final subscription1 = await uploader.result.listen((result) {
//    print("Progress result ${result.response}");

      // return result.response;
    }, onError: (ex, stacktrace) {});
    subscription1.onData((data) async {
      map = await json.decode(data.response);
      print("PATH data ${map.toString()}");
      print("PATH Url ${map['url']}");
      Box<String> appDb;

      appDb = Hive.box(ApiKeys.appDb);

      appDb.put(ApiKeys.profileUrl, map['url']);
    });

    return map;
  }
}
