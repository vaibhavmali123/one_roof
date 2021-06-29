import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/FeedbackPage.dart';

class SearchEndScreen extends StatefulWidget {
  String bidderName,srNo;

  SearchEndScreen(this.bidderName,this.srNo);

  SearchEndScreenState createState() => SearchEndScreenState(bidderName,srNo);
}

class SearchEndScreenState extends State {
  String firstname, lastName, email, mno,bidderName,srNo;


  SearchEndScreenState(this.bidderName,this.srNo);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();

  }
  @override
  Widget build(BuildContext context) {
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
                          child:Container()),
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height:40,),
                  Text(firstname!=null?"Hello "+firstname:"",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: color.colorConvert('#343048'),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.0))),
                  SizedBox(height:20,),
                  Image.asset('assets/images/Serch ends here_graphic.png'),
                  SizedBox(height:30,),
                  Text("Your Search ends here",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              color: color.colorConvert('#343048'),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0))),
                  Text.rich(TextSpan(
                      text: 'Thank you for choosing ',
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: color.colorConvert('#343048'),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.0)),
                      children: <InlineSpan>[
                        TextSpan(
                            text: 'One Roof',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    color: color.colorConvert('#343048'),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.0)))
                      ])),
                ],
              )
            ],
          ),
          SizedBox(height:60,),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin:EdgeInsets.only(left:35),
                    child:Text("Successful Bidder",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: color.colorConvert('#2AAD9C'),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.0))),
                  )
                ],
              ),
              SizedBox(height:6,),

              Container(
                height:50,
                // margin:EdgeInsets.only(top:20),
                width: Get.size.width / 1.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(width: 1, color: Colors.black45)),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          child: Center(
                              child: Text(
                                bidderName!=null?bidderName:"",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: color.colorConvert('#6B6977')),
                              )),
                        )),
                    Expanded(
                        child:
                        GestureDetector(
                          child:Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(14.0),
                                    bottomRight: Radius.circular(14.0)),
                                color: color.colorConvert('#2AAD9C'),
                              ),
                              child: Center(
                                child: Text(
                                  'Feedback',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: color.colorConvert('#0D082B')),
                                ),
                              )),
                          onTap:(){
                            Get.to(FeedbackPage(srNo));
                          },
                        ))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    firstname = appDb.get(ApiKeys.first_name);
    lastName = appDb.get(ApiKeys.last_name);
  }}
