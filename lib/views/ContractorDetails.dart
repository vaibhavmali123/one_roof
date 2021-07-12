import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:one_roof/firebase/NotificationService.dart';
import 'package:one_roof/models/WorkerDetailsModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/Constants.dart';
import 'package:one_roof/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerDetails extends StatefulWidget {
  String workerId, srNo, name, email, mno;

  WorkerDetails({this.workerId, this.srNo, this.name, this.email, this.mno});

  WorkerDetailsState createState() => WorkerDetailsState(workerId: workerId, srNo: srNo, name: name, email: email, mno: mno);
}

class WorkerDetailsState extends State<WorkerDetails> {
  List<String> listMachine = ['JCB', 'BOB cat', 'Dumper', 'Crane'];
  List<Order> listMac = [];
  List<dynamic> list = [];
  String workerId, srNo, name, email, mno, userType, skilled, unSkilled, techinal, turnover, experience;
  double rating = 1;

  WorkerDetailsState({this.workerId, this.srNo, this.name, this.email, this.mno});

  bool showLoader = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.configureNotification();

    getUserDetails();
    userType == Constants.hire ? getWorkerDetails() : getWorkerDetails();
    print("NAME ${name} ${srNo} ${email} ${mno}");
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
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(userType == 'hire' ? 'Vendor Details' : 'Hire Details', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900)),
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
      body: Stack(
        children: [
          showLoader == false
              ? SingleChildScrollView(
                  child: Container(
                    height: Get.size.height,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 190,
                              width: Get.size.width / 1.1,
                              decoration: BoxDecoration(color: color.colorConvert('EBF2FA').withOpacity(1), borderRadius: BorderRadius.circular(14.0)),
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, top: 12, bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Image.asset(
                                              'assets/images/profile pic.png',
                                              scale: 1,
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(name != null && name != "" && name != " " ? name : " ",
                                                            overflow: TextOverflow.ellipsis, maxLines: 2, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert('#343048'), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(mno != null && mno != "" && mno != " " ? mno.toString() : " ",
                                                          overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(email != null && email != "" && email != " " ? email.toString() : " ",
                                                          overflow: TextOverflow.ellipsis, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 13, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  height: 25,
                                                  width: 200,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        rating == 1 || rating >= 1 ? Icons.star : Icons.star_border,
                                                        color: rating == 1 || rating >= 1 ? Colors.orangeAccent : Colors.black45,
                                                        size: 18,
                                                      ),
                                                      Icon(
                                                        rating == 2 || rating >= 2 ? Icons.star : Icons.star_border,
                                                        color: rating == 2 || rating >= 2 ? Colors.orangeAccent : Colors.black45,
                                                        size: 18,
                                                      ),
                                                      Icon(
                                                        rating == 3 || rating >= 3 ? Icons.star : Icons.star_border,
                                                        color: rating == 3 || rating >= 3 ? Colors.orangeAccent : Colors.black45,
                                                        size: 18,
                                                      ),
                                                      Icon(
                                                        rating == 4 || rating >= 4 ? Icons.star : Icons.star_border,
                                                        color: rating == 4 || rating >= 4 ? Colors.orangeAccent : Colors.black45,
                                                        size: 18,
                                                      ),
                                                      Icon(
                                                        rating == 5 || rating >= 5 ? Icons.star : Icons.star_border,
                                                        size: 18,
                                                        color: rating == 5 || rating >= 5 ? Colors.orangeAccent : Colors.black45,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 25,
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 18,
                                        ),
                                        experience != "" && experience != null
                                            ? Container(
                                                width: Get.size.width / 1.4,
                                                child: Text('Experience He is been working from past ' + experience + "  in this industry!",
                                                    overflow: TextOverflow.ellipsis, softWrap: false, maxLines: 2, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12, color: color.colorConvert('#6B6977'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        userType == Constants.hire
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    width: Get.size.width / 1.1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('List of Machinaries', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0D082B').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          height: 140,
                                          child: ListView.builder(
                                            itemCount: listMac.length,
                                            itemBuilder: (context, index) {
                                              return listMac[index].name != null && listMac[index].count != null
                                                  ? Padding(
                                                      padding: EdgeInsets.only(top: 15),
                                                      child: Row(
                                                        children: [
                                                          Expanded(flex: 8, child: Text(listMac[index].name.toString())),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(listMac[index].count.toString()),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 18,
                        ),
                        userType == Constants.hire
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    width: Get.size.width / 1.1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Team strength', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0D082B').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                        userType == Constants.hire
                                            ? Container(
                                                margin: EdgeInsets.only(top: 10),
                                                height: 100,
                                                child: Column(
                                                  children: [
                                                    unSkilled != null && unSkilled != '' && unSkilled != " "
                                                        ? Row(
                                                            children: [Expanded(flex: 8, child: Text('Unskilled')), Expanded(flex: 2, child: Text(unSkilled))],
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    skilled != null && skilled != '' && skilled != " "
                                                        ? Row(
                                                            children: [Expanded(flex: 8, child: Text('Skilled')), Expanded(flex: 2, child: Text(skilled))],
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    techinal != null && techinal != '' && techinal != " "
                                                        ? Row(
                                                            children: [Expanded(flex: 8, child: Text('Technical staff')), Expanded(flex: 2, child: Text(techinal))],
                                                          )
                                                        : Container()
                                                  ],
                                                ))
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            userType == Constants.hire
                                ? Container(
                                    margin: EdgeInsets.only(left: 30),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Turnover', style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#0D082B').withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                                        SizedBox(
                                          height: 18,
                                        ),
                                        Container(
                                          width: Get.size.width / 1.1,
                                          child: Row(
                                            children: [
                                              Expanded(flex: 6, child: Text('Annual')),
                                              Expanded(
                                                flex: 2,
                                                child: turnover != null ? Text(turnover) : Container(),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        userType == Constants.hire
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 48,
                                    width: Get.size.width / 3,
                                    child: RaisedButton(
                                        child: Text(
                                          'Contact',
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                        color: color.colorConvert(color.primaryColor),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                        onPressed: () {
                                          launch("tel:" + mno);

                                          updateStatus();
                                          // Get.to(ContractorDetails());
                                        }),
                                  )
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              : displayLoader()
        ],
      ),
    );
  }

  void getWorkerDetails() {
    Box<String> appDb;

    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);

    var map = {'user_id': workerId};
    print("REQUEST ${map.toString()}");

    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.workerDetails, map).then((value) {
      setState(() {
        showLoader = false;
        print("RESPONSE ${value.toString()}");
        print("RESPONSE listMac ${listMac.length}");

        if (WorkerDetailsModel.fromJson(value).order != null) {
          listMac = WorkerDetailsModel.fromJson(value).order.toList();
        }
        print("RESPONSE ${value.toString()}");
        print("RESPONSE listMac ${listMac.length}");

        showLoader = false;
        Result result = WorkerDetailsModel.fromJson(value).result;

        name = result.firstName + result.lastName;
        mno = result.mobileNumber;
        email = result.email;
        skilled = result.skilledLabour != null && result.skilledLabour != "" && result.skilledLabour != " " ? result.skilledLabour : " ";
        unSkilled = result.nonSkilledLabour != null && result.nonSkilledLabour != "" && result.nonSkilledLabour != " " ? result.nonSkilledLabour : " ";
        techinal = result.technicalStaff != null && result.technicalStaff != "" && result.technicalStaff != " " ? result.technicalStaff : " ";
        turnover = result.turnover != null && result.turnover != "" && result.turnover != " " ? result.turnover : " ";
        experience = result.experience != null && result.experience != "" && result.experience != " " ? experience = result.experience : "";

        if (result.rating == null || result.rating == "") {
          setState(() {
            rating = 1;
          });
        } else {
          setState(() {
            rating = double.parse(result.rating);
          });
        }
        setState(() {});
        print("RATING ${result.rating}");
        showLoader = false;
      });
    });
  }

  displayLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void getUserDetails() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    setState(() {
      userType = appDb.get(ApiKeys.type);
    });
    setState(() {
      showLoader = false;

      print("NAME userType ${userType}");
    });
  }

  void updateStatus() {
    print("SST ${srNo.toString()} ${workerId.toString()}");

    var map = {"sr_no": srNo, 'worker_id': workerId};

    print("SST ${map.toString()}");
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.contactStatus, map).then((value) {
      if (value['statusCode=200']) {
        print("SST ${value.toString()}");
      }
    });
  }
}
