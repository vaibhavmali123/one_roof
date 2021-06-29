import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:one_roof/models/FaqModel.dart';

class FaqScreen extends StatefulWidget
{

  FaqScreenState createState()=>FaqScreenState();
}

class FaqScreenState extends State<FaqScreen>
{
  List<dynamic>listFaqs=[];
  List<bool>isSelectedList=[];
  int indexQue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJson();
  }
  @override
  Widget build(BuildContext context)
  {
  return Scaffold(
    appBar:
    AppBar(
      backgroundColor:Colors.white,
      leading:IconButton(icon:Icon(Icons.keyboard_backspace,color:Colors.black87,), onPressed:(){
        Get.back();
      }),
      title:Text(
        'FAQs',style:TextStyle(fontSize:16,
          color:Colors.black87,fontWeight:FontWeight.w800),),),
    body:Container(
      child:
      ListView.builder(
          itemCount:listFaqs.length,
          itemBuilder:(context,index){
            return Container(
             margin:EdgeInsets.only(left:18,right:14,top:18),
              decoration:BoxDecoration(
                boxShadow:[
                  BoxShadow(
                    color:Colors.black12,
                    offset:Offset(
                      5.0,
                      0.5
                    ),
                    blurRadius:10.4,
                    spreadRadius:0.4
                  )
                ]
              ),
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  GestureDetector(
                    onTap:(){

                      if (isSelectedList[index]==true) {
                        setState(() {
                          isSelectedList[index]=false;
                        });
                      }
                      else if(isSelectedList[index]==false){
                        setState(() {
                          isSelectedList[index]=true;
                          indexQue=index;
                        });
                      }
                    },
                    child:Container(
                      height:70,
                      padding:EdgeInsets.symmetric(horizontal:5),
                      width:Get.size.width/1.1,
                      decoration:BoxDecoration(
                        color:Colors.white
                      ),
                      child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex:5,
                                  child:Container(
                                    child:Text(listFaqs[index]['question'],
                                        overflow:TextOverflow.ellipsis,
                                        maxLines:3,
                                        style:TextStyle(fontSize:15,color:Colors.black87,
                                            fontWeight:FontWeight.w600)),
                                  )),
                              Expanded(
                                  flex:1,
                                  child:Icon(isSelectedList[index]!=true?
                              Icons.arrow_drop_down:Icons.arrow_drop_up,size:28,))
                            ],
                          ),
                        ],
                      )
                    ),
                  ),
                  isSelectedList[index]==true?Container(
                      padding:EdgeInsets.all(8),
                      width:Get.size.width/1.1,
                      decoration:BoxDecoration(
                          color:Colors.white,
                      ),
                      child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Text('Answer: '+listFaqs[index]['answer'],
                              style:TextStyle(fontSize:15,color:Colors.black87.withOpacity(0.7),
                                  fontWeight:FontWeight.w600,fontStyle:FontStyle.italic,height:1.8))
                        ],
                      )
                  ):Container(),
                ],
              ),
            );
          }),
    ),

  );
  }

  Future<String> getJson() async{
    var jsonText=await rootBundle.loadString('assets/json/FaqJson');
    setState(() {
      var map=json.decode(jsonText);
      listFaqs=map['list'];
//      listFaqs=FaqModel.fromJson(map)
      print("jsonText ${jsonText}");
      print("jsonText ${listFaqs.toString()}");
      for(int i=0;i<listFaqs.length;i++){
        isSelectedList.add(false);
      }
    });
  }
}