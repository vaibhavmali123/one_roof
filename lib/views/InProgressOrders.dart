import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/OrderDetails.dart';

class InProgressOrders extends StatefulWidget
{
  InProgressOrdersState createState()=>InProgressOrdersState();
}

class InProgressOrdersState extends State<InProgressOrders>
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
            margin:EdgeInsets.only(top:40),
            width:Get.size.width/1.2,
            child:
            status!=null?ListView.builder(
                itemCount:list.length,
                itemBuilder:(context,index){
                  return
                    GestureDetector(
                      onTap:(){
                        Get.to(OrderDetails(list[index][ApiKeys.crNo],list[index]['status'],list[index]['project_name']));
                      },
                      child:Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          list[index]['status']=='1'?Container(
                            height:60,
                            margin:EdgeInsets.only(top:20),
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
                                        child:Text("SR no. "+list[index][ApiKeys.crNo],
                                          style:TextStyle(fontSize:13,fontWeight:FontWeight.w400,
                                              color:color.colorConvert('#6B6977')),)
                                      ),
                                    )),
                                Expanded(
                                    child:Container(
                                        height:60,
                                        decoration:BoxDecoration(
                                          borderRadius:BorderRadius.only(topRight:Radius.circular(14.0),bottomRight:Radius.circular(14.0)),
                                          color:Colors.orange,
                                        ),
                                        child:Center(
                                          child:Text('In Progress',style:TextStyle(fontSize:13,
                                              fontWeight:FontWeight.w600,
                                              color:Colors.white),),
                                        )
                                    ))
                              ],
                            ),
                          ):Container()
                        ],
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
      print("RESPONSE1 list ${list.toString()}");
      for(int i=0;i<list.length;i++){
        print("statusDATA ${list[i]['status']}");
        if (list[i]['status']=='1') {
          setState(() {
            status="1";
          });
        }
      }
    });



   // print("statusDATA ${status}");
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
        print("statusDATA ${list[i]['status']}");
        if (list[i]['status']=='1') {
          setState(() {
            status="1";
          });
        }
      }
      print("DDDDDD ${status}");

    });

      }
}