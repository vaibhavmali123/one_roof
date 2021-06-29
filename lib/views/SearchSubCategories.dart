import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/SpecialisationPage.dart';

class SearchSubCategories extends SearchDelegate<String>
{
  List<String>listIcons=[];
  List<String>listSubCats=[];
  String colorCode,categoryName;
  List<String>idList=[];
  bool isAssigned;
  SearchSubCategories(this.listIcons,this.listSubCats,this.colorCode,this.idList,this.categoryName,this.isAssigned);


  final recentSearch=[];
  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for search bar
    return [IconButton(icon:Icon(Icons.clear), onPressed:(){
      query='';
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // actions for leading icon
    return IconButton(
      icon:AnimatedIcon(
        icon:AnimatedIcons.menu_arrow,
        progress:transitionAnimation,
      ),
      onPressed:(){
        close(context,null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some results
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // When someone searches for something
    print("RESULT query: ${query}");;

/*    final suggestionsList=query.isEmpty?
    recentSearch:listSubCats.where((element) =>element.startsWith(query)).toList();*/
 List<String>suggestionsList=[];
/*
final suggestionsList=query.isEmpty?
    recentSearch:listSubCats.where((element) =>element.startsWith(query)).toList();
*/
for(int i=0;i<listSubCats.length;i++){
  if (listSubCats[i]==query || listSubCats[i].startsWith(query) || listSubCats[i].toLowerCase()==query.toLowerCase()
  || listSubCats[i].startsWith(query.toUpperCase()) || listSubCats[i].toUpperCase()==query.toUpperCase()) {
    suggestionsList.add(listSubCats[i]);
  }
}

print("RESULT: ${suggestionsList.toString()}");;
    return
      Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Container(
            width:Get.size.width/1.1,
            height:Get.size.height-100,
            child:
            ListView.builder(
              itemCount:suggestionsList.length,
              itemBuilder:(context,index){
                return GestureDetector(
                  onTap:(){
                    Get.to(SpecialisationPage(idList[index],listSubCats[index],
                        colorCode,categoryName,isAssigned));
                  },
                  child:
                  Container(
                    margin:EdgeInsets.only(top:20),
                    height:100,
                    width:Get.size.width-30,
                    decoration:BoxDecoration(
                        color:Colors.white,
                        borderRadius:BorderRadius.circular(18.0),
                        boxShadow:[
                          BoxShadow(
                            color:Colors.black12,
                            offset: const Offset(
                              5.0,
                              0.5,
                            ),
                            blurRadius:10.4,
                            spreadRadius:0.4,
                          )
                        ]
                    ),
                    child:Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex:2,
                            child:
                            Container(
                              margin:EdgeInsets.only(left:8),
                              height:80,
                              width:100,
                              decoration:BoxDecoration(
                                  color:color.colorConvert(colorCode).withOpacity(0.1),
                                  borderRadius:BorderRadius.circular(12.0)
                              ),
                              child:
                              Image.network(listIcons[index])
                              /*Image.asset('assets/images/soil investigation icon.png',scale:1.0,height:80,width:80,)*/,
                            )
                        ),
                        Expanded(
                          flex:5,
                          child:Column(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Center(
                                child:Container(
                                  width:140,
                                  child:Text(suggestionsList[index],
                                      maxLines:2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              fontSize:13,
                                              color:color.colorConvert('#6B6977'),
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.0))),
                                ),
                              )

                            ],
                          ),
                        ),
                        Expanded(
                          flex:1,
                          child:SvgPicture.asset('assets/images/next.svg',color:color.colorConvert(colorCode)),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
  }

}