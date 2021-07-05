import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';

class ChatPage extends StatefulWidget
{
  ChatPageState createState()=>ChatPageState();

}

class ChatPageState extends State<ChatPage>
{
  List<String>listChat=[];
  final messageEditingCtrl=TextEditingController();
  String userType,userId;
  final picker = ImagePicker();
  File image, croppedImage;
  String uploadedFileUrl,fileStr;
  bool showLoader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context)
  {
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
                    title: Text(AppStrings.chatWithUs,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w900)),
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
        //bottomNavigationBar:getChatField(),
        body:
        Column(
          children: [
            Expanded(
                child:ListView.builder(
                    itemCount:listChat.length,
                    itemBuilder:(context,index){
                      return
                        Align(
                          alignment:index/2!=0?Alignment.topLeft:Alignment.topRight,
                          child:Container(
                            padding:EdgeInsets.all(14),
                            margin:EdgeInsets.only(top:30,right:20,left:12),
                            //height:80,
                            width:Get.size.width/2,
                            decoration:BoxDecoration(
                              borderRadius:BorderRadius.only(bottomRight:Radius.circular(0),
                                topRight:Radius.circular(12),bottomLeft:Radius.circular(12),
                                topLeft:Radius.circular(12),),
                              color:index/2==0?color.colorConvert(color.primaryColor):Colors.cyan,
                            ),
                            child:Center(
                              child:Text(listChat[index],style:TextStyle(fontSize:15,color:Colors.white),),
                            ),
                          ),
                        );
                    })
            ),
            Align(
              alignment:Alignment.bottomCenter,
              child:getChatField(),
            ),
          ],
        )
    );
  }

  getChatField() {
    return Container(
      padding:EdgeInsets.only(top:4,bottom:8),
      child:Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          SizedBox(
            height:50,
            width:Get.size.width/1.4,
            child:TextField(
              controller:messageEditingCtrl,
              decoration:InputDecoration(
                  hintText:'Type a message',
                  suffixIcon:GestureDetector(
                    onTap:(){
                      if (messageEditingCtrl.text.length>0) {
                        sendMessage();
                      }
                      else{
                        ToastMessages.showToast(message:'Please enter message',type:false);
                      }
                    },
                    child:Image.asset('assets/images/Icon ionic-ios-send.png',height:10,width:10,),
                  ),
                  enabledBorder:inputBorder,
                  focusedBorder:inputBorder
              ),
            ),
          ),
          SizedBox(width:10,),
            GestureDetector(
              child:Container(
                width:50,
                height:45,
                decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(10.0),
                    border:Border.all(width:1,color:Colors.black54)
                ),
                child:Center(
                  child:SvgPicture.asset('assets/images/attachment-icon.svg',color:Colors.black54,),
                ),
              ),
              onTap:(){
                _showPicker(context);
              },
            )
        ],
      ),
    );
  }
  var inputBorder=OutlineInputBorder(
      borderRadius:BorderRadius.circular(15.0),
      borderSide:BorderSide(width:1,color:Colors.black54)
  );

  void sendMessage() {
    listChat.clear();
    var map={
      'user_id':userId,
      'user_type':userType,
      'message':messageEditingCtrl.text
    };
    ApiHandler.postApi(ApiProvider.baseUrl,EndApi.chat, map).then((value){
      print("MSG t ${value.toString()}");
      if (value['result']=true) {
        setState(() {
          listChat.add(messageEditingCtrl.text);
          listChat.add(value['answer']);
          messageEditingCtrl.clear();
        });
        print("MSG ${value.toString()}");
      }  
    });
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    setState(() {
      userId=appDb.get(ApiKeys.userId);
      userType=appDb.get(ApiKeys.type);
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

      print("image ${image}");
      print("fileName ${fileName}");
      print("dir ${dir}");
      showLoader = true;

      uploader(fileName: fileName, directory: dir);
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
    ToastMessages.showToast(message:"File submit successfully",type:true);
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
}
