import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/FeedbackPage.dart';

class CompletedOrders extends StatefulWidget
{
  CompletedOrdersState createState()=>CompletedOrdersState();
}

class CompletedOrdersState extends State<CompletedOrders>
{
  List<dynamic>list=[];
  bool showLoader=true;
  String status,userType;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    userType==Constants.hire?getHireOrders():
    getWorkerOrders();

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body:
      Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          showLoader==false?Container(
            margin:EdgeInsets.only(top:25),
            width:Get.size.width/1.2,
            child:
            status!=null?ListView.builder(
                itemCount:list.length,
                itemBuilder:(context,index){
                  print("sT ${list[index]['worker_feedback_status']}");
                  return
                    GestureDetector(
                      onTap:(){

                        switch(userType){
                          case"hire":
                            if (list[index]['status']!='4') {
                              Get.to(FeedbackPage(list[index][ApiKeys.crNo]));
                            }
                            break;
                          case"work":
                            if (list[index]['worker_feedback_status']=='0') {
                              Get.to(FeedbackPage(list[index][ApiKeys.crNo]));
                            }
                            break;
                        }                      },
                      child:Padding(padding:EdgeInsets.only(top:10),
                        child:
                        list[index]['status']=='2' || list[index]['status']=='4'?Column(
                          children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                Text('Completed',style:TextStyle(fontSize:13,
                                    fontWeight:FontWeight.w600,
                                    color:color.colorConvert('#2AAD9C')),),
                              ],
                            ),
                            SizedBox(height:8,),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                Container(
                                  height:60,
                                  // margin:EdgeInsets.only(top:20),
                                  width:Get.size.width/1.2,
                                  decoration:BoxDecoration(
                                      borderRadius:BorderRadius.circular(14.0),
                                      border:Border.all(width:1,color:Colors.black45)
                                  ),
                                  child:Row(
                                    children: [
                                      Expanded(
                                          child:Container(
                                            child:Center(
                                                child:Text(list[index][ApiKeys.crNo],style:TextStyle(fontSize:13,fontWeight:FontWeight.w400,
                                                    color:color.colorConvert('#6B6977')),)
                                            ),
                                          )),
                                      Expanded(
                                          child:Container(
                                              height:60,
                                              decoration:BoxDecoration(
                                                borderRadius:BorderRadius.only(topRight:Radius.circular(14.0),bottomRight:Radius.circular(14.0)),
                                                color:list[index]['status']=='1'?color.colorConvert('#FEBA3D'):
                                                list[index]['status']=='3'?color.colorConvert('#DEDCE6'):color.colorConvert('#2AAD9C'),
                                              ),
                                              child:Center(
                                                child:
                                                userType!='work'?Text(list[index]['status']=='1'?'In Progress':
                                                list[index]['status']=='3'?'Open':list[index]['status']=='4'?'Feedback Given':'Feedback',style:TextStyle(fontSize:13,
                                                    fontWeight:FontWeight.w600,
                                                    color:Colors.white),):Text(list[index]['status']=='1'?'In Progress':
                                                list[index]['status']=='3'?'Open':list[index]['worker_feedback_status']=='1'?'Feedback Given':
                                                list[index]['worker_feedback_status']=='1'?'Feedback Given':'Feedback',style:TextStyle(fontSize:13,
                                                    fontWeight:FontWeight.w600,
                                                    color:Colors.white),),
                                                /*Text(list[index]['status']=='1'?'In Progress':
                                                list[index]['status']=='3'?'Open':'Feedback',style:TextStyle(fontSize:13,
                                                    fontWeight:FontWeight.w600,
                                                    color:Colors.white),),*/
                                              )
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ):Container(),
                      ),
                    );
                }):Center(
              child:Text("No Orders found",style:TextStyle(fontSize:12,color:Colors.black45,fontWeight:FontWeight.w600),),
            ),
          ):displayLoader()
        ],
      ),
    );
  }
  void getHireOrders() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId=appDb.get(ApiKeys.userId);
    print("USERID ${userId}");
    var map={
      'user_id':userId
    };
    ApiHandler.postApi(ApiProvider.baseUrl,EndApi.ordersUsingId,map).then((value) {
      print("RESPONSE1 ${value.toString()}");
      setState(() {
        showLoader=false;
        list=value['result'];
      });
      for(int i=0;i<list.length;i++){
        if (list[i]['status']=='2' || list[i]['status']=='4') {
          setState(() {
            status="2";
          });
        }
      }
      print("STATUSDATA ${status}");

      print("RESPONSE1 list ${list.toString()}");

    });
  }

  displayLoader() {
    return Container(
      child:Center(
        child:CircularProgressIndicator(),
      ),
    );
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    setState(() {
      userType=appDb.get(ApiKeys.type);
    });

  }

  void getWorkerOrders() {

    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId=appDb.get(ApiKeys.userId);
    var map={
      'user_id':userId
    };
    ApiHandler.postApi(ApiProvider.baseUrl,EndApi.workerAssignedCat, map).then((value){
      print("VALUE ${value.toString()}");

      setState(() {
        showLoader=false;
        list=value['result'];
      });
      for(int i=0;i<list.length;i++){
        if (list[i]['status']=='2') {
          setState(() {
            status="2";
          });
        }
      }

    });

  }
}