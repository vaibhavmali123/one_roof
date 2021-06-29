import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/BottomNavigationScreen.dart';
import 'package:one_roof/views/LoginScreen.dart';
import 'package:one_roof/views/OrderPage.dart';

class ThankYouScreen extends StatelessWidget
{
  String accountType;


  ThankYouScreen(this.accountType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
          preferredSize:Size.fromHeight(75),
          child:
          Column(
            children: [
              SizedBox(height:15,),
              AppBar(
                  backgroundColor:Colors.transparent,
                  elevation:0,
                  centerTitle:true,

                  leading:GestureDetector(
                    child:Image.asset('assets/images/back_icon.png',scale:1.8,),
                    onTap:(){
                      Get.back();
                    },
                  )
              ),
            ],
          )
      ),
      body:Column(
        crossAxisAlignment:CrossAxisAlignment.center,
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Expanded(
              flex:1,
              child:Container()),
          Expanded(
            flex:4,
            child:Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(AppStrings.thankYou,style:
                    GoogleFonts.openSans(textStyle:TextStyle(fontSize:24,color:Colors.black,
                        fontWeight:FontWeight.w900,letterSpacing:0.0))),
                    SizedBox(height:10,),
                    Text('For sign up',style:
                    GoogleFonts.openSans(textStyle:TextStyle(fontSize:16,color:Colors.black54,
                        fontWeight:FontWeight.w700,letterSpacing:0.0))),
                    SizedBox(height:10,),

                    Image.asset('assets/images/thank_you.png',scale:1.5,)

                  ],
                )
              ],
            ),),
          Expanded(
              flex:2,
              child:Align(
                  alignment:Alignment.bottomCenter,
                  child:Padding(
                    padding:EdgeInsets.only(bottom:40),
                    child:ButtonTheme(
                      minWidth:MediaQuery.of(context).size.width/2.4,
                      height:52,
                      child:RaisedButton(
                          child:Text(AppStrings.letsStart,style:TextStyle(fontSize:16,color:Colors.white),),
                          color:color.colorConvert(color.primaryColor),
                          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12.0)),
                          onPressed:(){
                            Box<String> appDb;
                            appDb = Hive.box(ApiKeys.appDb);
                            appDb.put(ApiKeys.type,accountType);
                            appDb.put(Constants.logedInFlag,Constants.logedInFlag);
                            Get.offAll(BottomNavigationScreen());
                          }),),
                  )
              ))
        ],
      ),

    );
  }
}