import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/utils/color.dart';
import 'package:one_roof/views/OrderDetails.dart';

import 'FeedbackPage.dart';

class SearchOrders extends SearchDelegate {
  List<dynamic> list = [];
  List<dynamic> suggestionsList = [];
  List<dynamic> listId = [];
  String userType;

  SearchOrders(this.list);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black87,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          color: Colors.black87,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestionsList.clear();
    for (int i = 0; i < list.length; i++) {
      if (list[i][ApiKeys.crNo] == query || list[i][ApiKeys.crNo].toString().contains(new RegExp(query, caseSensitive: false)) || list[i][ApiKeys.crNo].toString().startsWith(query) || list[i][ApiKeys.crNo].toString().toLowerCase().startsWith(query.toLowerCase())) {
        suggestionsList.add(list[i]);
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: Get.size.width / 1.2,
          child: list != null
              ? ListView.builder(
                  itemCount: suggestionsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Box<String> appDb;
                        appDb = Hive.box(ApiKeys.appDb);
                        userType = appDb.get(ApiKeys.type);

                        switch (userType) {
                          case "hire":
                            if (list[index]['status'] != '4') {
                              list[index]['status'] != '2' ? Get.to(OrderDetails(list[index][ApiKeys.crNo], list[index]['status'], list[index]['project_name'])) : Get.to(FeedbackPage(list[index][ApiKeys.crNo]));
                            }
                            break;
                          case "work":
                            if (list[index]['worker_feedback_status '] == '1') {
                            } else {
                              if (list[index]['status'] == '1' || list[index]['status'] == '3') {
                                Get.to(OrderDetails(list[index][ApiKeys.crNo], list[index]['status'], list[index]['project_name']));
                              }
                              print('LLLLLLLLLLLLLLL ${list[index]['status']} ${list[index]['worker_feedback_status']}');
                              if (list[index]['status'] == '2' && list[index]['worker_feedback_status'] == '0') {
                                Get.to(FeedbackPage(list[index][ApiKeys.crNo]));
                              }
                              if (list[index]['worker_feedback_status '] == '1') {}
                              /*list[index]['worker_feedback_status ']=='1'?
                              Get.to(OrderDetails(list[index][ApiKeys.crNo],list[index]['status'])):
                              list[index]['worker_feedback_status ']=='1'
                              ?Get.to(FeedbackPage(list[index][ApiKeys.crNo])):null;*/
                            }
                            break;
                        }
                        /*suggestionsList[index]['status']!='2'?
                      Get.to(OrderDetails(list[index][ApiKeys.crNo],list[index]['status'],list[index]['project_name'])):
                      Get.to(FeedbackPage(list[index][ApiKeys.crNo]));*/
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          suggestionsList[index]['status'] == '2'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Completed',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color.colorConvert('#2AAD9C')),
                                    ),
                                  ],
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 20),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(top: 0),
                                width: Get.size.width / 1.2,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.0), border: Border.all(width: 1, color: Colors.black45)),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          width: 100,
                                          child: Center(
                                            child: Text(
                                              "SR no. " + suggestionsList[index][ApiKeys.crNo],
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: color.colorConvert('#6B6977')),
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(14.0), bottomRight: Radius.circular(14.0)),
                                              color: suggestionsList[index]['status'] == '1'
                                                  ? color.colorConvert('#FEBA3D')
                                                  : suggestionsList[index]['status'] == '3'
                                                      ? color.colorConvert('#DEDCE6')
                                                      : color.colorConvert('#2AAD9C'),
                                            ),
                                            child: Center(
                                              child: userType != 'work'
                                                  ? Text(
                                                      suggestionsList[index]['status'] == '1'
                                                          ? 'In Progress'
                                                          : suggestionsList[index]['status'] == '3'
                                                              ? 'Open'
                                                              : suggestionsList[index]['status'] == '4'
                                                                  ? 'Feedback Given'
                                                                  : 'Feedback',
                                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                                    )
                                                  : Text(
                                                      list[index]['status'] == '1'
                                                          ? 'In Progress'
                                                          : suggestionsList[index]['status'] == '3'
                                                              ? 'Open'
                                                              : list[index]['worker_feedback_status'] == '1'
                                                                  ? 'Feedback Given'
                                                                  : suggestionsList[index]['worker_feedback_status'] == '1'
                                                                      ? 'Feedback Given'
                                                                      : 'Feedback',
                                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                                    ),
                                            )))
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  })
              : Center(
                  child: Text(
                    "No Orders found",
                    style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w600),
                  ),
                ),
        )
      ],
    );
  }
}
