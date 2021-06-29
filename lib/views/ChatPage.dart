import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
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
          Container(
            width:50,
            height:45,
            decoration:BoxDecoration(
                borderRadius:BorderRadius.circular(10.0),
                border:Border.all(width:1,color:Colors.black54)
            ),
            child:Center(
              child:SvgPicture.asset('assets/images/attachment-icon.svg',color:Colors.black54,),
            ),
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
}
