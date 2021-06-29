import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/one__roof_icons.dart';
import 'package:one_roof/utils/AppStrings.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/PostRequirement.dart';
import 'package:one_roof/views/SearchSubCategories.dart';
import 'package:one_roof/views/SpecialisationPage.dart';

class SubcategoryPage extends StatefulWidget {
  String categoryId, categoryName;
  SubcategoryPage(this.categoryId, this.categoryName, this.isAssigned);
  bool isAssigned;
  SubcategoryPageState createState() => SubcategoryPageState(categoryId, categoryName, isAssigned);
}

class SubcategoryPageState extends State<SubcategoryPage> {
  String categoryId, categoryName;
  bool isAssigned;

  List<dynamic> list = [];
  SubcategoryPageState(this.categoryId, this.categoryName, this.isAssigned);
  bool showLoader = true;
  String colorCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
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
                elevation: 2,
                automaticallyImplyLeading: false,
                centerTitle: true,
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
                          child: Text(categoryName, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700)),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: Icon(
                                One_Roof.search_icon,
                                color: Colors.black26,
                                size: 22,
                              ),
                              onPressed: () {
                                List<String> listIcons = [];
                                List<String> listSubCats = [];
                                List<String> idList = [];
                                for (int i = 0; i < list.length; i++) {
                                  listSubCats.add(list[i][ApiKeys.subcategory]);
                                  listIcons.add(list[i]['image']);
                                  idList.add(list[i][ApiKeys.subCategoryId]);
                                }
                                showSearch(context: context, delegate: SearchSubCategories(listIcons, listSubCats, colorCode, idList, categoryName, isAssigned));
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
      body: Container(
          height: Get.size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height:14,),
              Expanded(
                flex: 1,
                child: getTopTextLines(),
              ),
              Expanded(
                flex: 12,
                child: getList(),
              ),
            ],
          )),
    );
  }

  getTopTextLines() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppStrings.selectBelowCat, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert('#343048'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(AppStrings.asNeed, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert('#343048'), fontWeight: FontWeight.w700, letterSpacing: 0.0)))],
        )
      ],
    );
  }

  getList() {
    return showLoader != true
        ? Container(
            width: Get.size.width / 1.1,
            height: Get.size.height - 100,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                colorCode = list[index][ApiKeys.colorCode];
                return GestureDetector(
                  onTap: () {
                    print("CCCC ${categoryName}");
                    if (categoryName != 'Marketing Solutions' && categoryName != 'Project Management' && categoryName != 'Product Vendors') {
                      Get.to(SpecialisationPage(list[index][ApiKeys.subCategoryId], list[index][ApiKeys.subcategory], list[index][ApiKeys.colorCode], categoryName, isAssigned));
                    } else {
                      Get.to(PostRequirement(
                        categoryName: categoryName,
                        specialisation: list[index][ApiKeys.subcategory],
                        isAssigned: isAssigned,
                        selectedValue: list[index][ApiKeys.subcategory],
                        colorCode: colorCode,
                      ));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 100,
                    width: Get.size.width - 30,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18.0), boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: const Offset(
                          5.0,
                          0.5,
                        ),
                        blurRadius: 10.4,
                        spreadRadius: 0.4,
                      )
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              height: 80,
                              width: 100,
                              decoration: BoxDecoration(color: color.colorConvert(list[index][ApiKeys.colorCode]).withOpacity(0.1), borderRadius: BorderRadius.circular(12.0)),
                              child: Image.network(list[index]['image'])
                              /*Image.asset('assets/images/soil investigation icon.png',scale:1.0,height:80,width:80,)*/,
                            )),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: 180,
                                  child: Text(list[index][ApiKeys.subcategory], maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SvgPicture.asset('assets/images/next.svg', color: color.colorConvert(list[index][ApiKeys.colorCode])),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : displayLoader();
  }

  void loadData() {
    var map = {'category_id': categoryId};

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.subCategory, map).then((value) {
      Map<String, dynamic> mapData;
      List<dynamic> listRes;
      setState(() {
        mapData = value;
        list = mapData[ApiKeys.subCatList];
        print("DATA ${mapData.toString()}");
        print("DATA ${listRes.toString()}");
        showLoader = false;
      });
      for (int i = 0; i < listRes.length; i++) {
        //list.add(listRes[i][ApiKeys.subcategory]);
      }
    });
  }

  displayLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
