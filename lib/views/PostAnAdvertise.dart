import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/models/CategoriesModel.dart';
import 'package:one_roof/models/DurationModel.dart';
import 'package:one_roof/models/ServicesModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:intl/intl.dart';
class PostAnAdvertise extends StatefulWidget
{

  PostAnAdvertiseState createState()=>PostAnAdvertiseState();
}

class PostAnAdvertiseState extends State<PostAnAdvertise>
{
  List<TypeList>listService=[];
  List<DurationList>listDuration=[];
  var selectedService,selectedDuration,selectedCategory,picked,dateStr;
  List<CategoryList> _categoryDropdownValues = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
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
                title:Text('Thank you for your intrest',style:TextStyle(fontSize:16,
                    color:Colors.black87,fontWeight:FontWeight.w700),),
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

    body:SafeArea(
        child:Container(
          width:Get.size.width,
          child:
          Column(
            mainAxisSize:MainAxisSize.max,
            //mainAxisAlignment:MainAxisAlignment.spaceBetween,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              SizedBox(height:14,),
              Text('Provide some more details',style:TextStyle(fontSize:16,
                  color:Colors.black87,fontWeight:FontWeight.w700),),
              SizedBox(height:35,),

              getProductService(),
              SizedBox(height:34,),
              getBusinessType(),
              SizedBox(height:34,),
              getDuration(),
              SizedBox(height:34,),
              getWhenToStart(),
              SizedBox(height:80,),

              Align(
                alignment:Alignment.bottomCenter,
                child:SizedBox(
                  width:Get.size.width/2.2,
                  height:54,
                  child:RaisedButton(onPressed:(){
                    if (selectedService!=null && selectedCategory!=null && selectedDuration!=null && dateStr!=null) {
                      postAdvertise();
                    }
                    else{
                      ToastMessages.showToast(message:'Please select all fields',type:false);
                    }
                  },
                    shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
                    color:color.colorConvert(color.primaryColor),
                    child:Text('Submit',style:TextStyle(fontSize:15,color:Colors.white,
                        fontWeight:FontWeight.w900),),),
                )
              )
            ],
          ),
        )
    ),
  ) ;
  }

  getProductService() {
    return
      Container(
        height: 54,
        width: Get.size.width / 1.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1, color: Colors.black38)),
        child: Center(
          child: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                // background color for the dropdown items
                buttonTheme: ButtonTheme.of(context).copyWith(
                  alignedDropdown:
                  true, //If false (the default), then the dropdown's menu will be wider than its button.
                )),
            child: DropdownButton<String>(
              underline: Container(
                height: 1.0,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                        BorderSide(color: Colors.transparent, width: 0.0))),
              ),
              isExpanded: true,
              focusColor: Colors.white,
              value: selectedService,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              icon: Image.asset(
                'assets/images/dropDown_icon.png',
                height: 22,
                width: 22,
              ),
              items: listService
                  .map<DropdownMenuItem<String>>((listService) {
                return DropdownMenuItem<String>(
                  value:listService.name,
                  child: Text(
                    listService.name,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              hint: Text(
                "Product or Service",
                style: TextStyle(
                    fontSize: 14,
                    color:selectedService != null ? Colors.black87 : Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (String value) {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  selectedService = value;
                });
              },
            ),
          ),
        ),
      );
  }

  void loadData() {
    ApiHandler.requestApi(ApiProvider.baseUrl,EndApi.adsType).then((value){
      setState(() {
        listService=ServicesModel.fromJson(value).typeList.toList();
      });
      print("VALUE ${value.toString()}");
    });
    ApiHandler.requestApi(ApiProvider.baseUrl,EndApi.adsDuration).then((value){
        listDuration=DurationModel.fromJson(value).durationList.toList();
      print("VALUE ${value.toString()}");
    });

    ApiHandler.requestApi(ApiProvider.baseUrl, EndApi.category).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;

      setState(() {
        mapData = value;
        print('_categoryDropdownValues ${mapData.toString()}');

        _categoryDropdownValues =
            CategoriesModel.fromJson(mapData).categoryList.toList();
      });
      print('_categoryDropdownValues ${_categoryDropdownValues.toString()}');
    });
  }

  getBusinessType() {
    return Container(
      height: 54,
      width: Get.size.width / 1.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1, color: Colors.black38)),
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown:
                true, //If false (the default), then the dropdown's menu will be wider than its button.
              )),
          child: DropdownButton<String>(
            underline: Container(
              height: 1.0,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom:
                      BorderSide(color: Colors.transparent, width: 0.0))),
            ),
            isExpanded: true,
            focusColor: Colors.white,
            value: selectedCategory,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            icon: Image.asset(
              'assets/images/dropDown_icon.png',
              height: 22,
              width: 22,
            ),
            items: _categoryDropdownValues
                .map<DropdownMenuItem<String>>((CategoryList value) {
              print("DDD ${value.id}");
              return DropdownMenuItem<String>(
                value: value.categoryName,
                child: Text(
                  value.categoryName,
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            hint: Text(
              'Select Business Type',
              style: TextStyle(
                  fontSize: 14,
                  color:
                  selectedCategory != null ? Colors.black : Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedCategory = value;

              });
            },
          ),
        ),
      ),
    );

  }

  getDuration() {
    return Container(
      height: 54,
      width: Get.size.width / 1.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1, color: Colors.black38)),
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown:
                true, //If false (the default), then the dropdown's menu will be wider than its button.
              )),
          child: DropdownButton<String>(
            underline: Container(
              height: 1.0,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom:
                      BorderSide(color: Colors.transparent, width: 0.0))),
            ),
            isExpanded: true,
            focusColor: Colors.white,
            value: selectedDuration,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            icon: Image.asset(
              'assets/images/dropDown_icon.png',
              height: 22,
              width: 22,
            ),
            items: listDuration
                .map<DropdownMenuItem<String>>((DurationList value) {
              print("DDD ${value.id}");
              return DropdownMenuItem<String>(
                value: value.durationTime.toString(),
                child: Text(
                  value.durationTime,
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            hint: Text(
              'Duration of Ad reuire',
              style: TextStyle(
                  fontSize: 14,
                  color:
                  selectedDuration != null ? Colors.black : Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                selectedDuration = value;

              });
            },
          ),
        ),
      ),
    );

  }

  getWhenToStart() {
    return GestureDetector(
      child:Container(
        height: 54,
        width: Get.size.width / 1.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1, color: Colors.black38)),
        child:
        Padding(
          padding:EdgeInsets.only(left:14,right:4),
          child:Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Text(dateStr==null?'When to start':dateStr,
                style: TextStyle(
                    fontSize: 14,
                    color:
                    dateStr!=null?Colors.black87:Colors.black54,
                    fontWeight: FontWeight.w500),),
              Image.asset(
                'assets/images/dropDown_icon.png',
                height: 22,
                width: 22,
              ),
            ],
          ),
        ),
      ),
      onTap:(){
        selectDate();
      },
    );
  }

  Future<Null> selectDate() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate:DateTime(2101),
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
      var myFormat = DateFormat('yyyy-MM-dd');

      dateStr = myFormat.format(picked).toString();
    });
  }

  void postAdvertise() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId=appDb.get(ApiKeys.userId);

    var map={
      "user_id": userId,
      "service": selectedService,
      "business_type": selectedCategory,
      "duration": selectedDuration,
      "when_start": dateStr.toString()
    };
    ApiHandler.
    postApi(ApiProvider.baseUrl,EndApi.postAdvertise, map).then((value){
      if (value['result']==true) {
        ToastMessages.showToast(message:'Submitted successfully',type:true);
      }
    });
  }
}