import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_roof/models/PaymentModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiKeys.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/utils/ToastMessages.dart';
import 'package:one_roof/utils/color.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  var isChecked = false;
  List<Result> list = [];
  List<bool> isCheckedList = [];
  int total = 0;
  Razorpay _razorpay;
  var dio;
  List<String> srNoList = [];
  String pdfUrl = 'https://sncfinancialconsulting.in/one_roof/uploads/images/60af7c4edfbff.pdf';
  var options;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio = Dio();
    _razorpay = new Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessHandler);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentFailureHandler);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, paymentWalletHandler);

    getUserPayment();
    getPermission();
  }

  void paymentSuccessHandler(PaymentSuccessResponse response) {
    print("Payment Successfull");
    ToastMessages.showToast(message: 'Payment done', type: true);
    String paymentIdStr = response.paymentId;
    updatePayment(paymentId: paymentIdStr);
  }

  void paymentFailureHandler() {
    print("Payment Failed");
    ToastMessages.showToast(message: 'Payment failed', type: false);
  }

  void paymentWalletHandler() {
    print("Wallet Payment");
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
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    'assets/images/back_icon.png',
                    scale: 1.8,
                  ),
                ),
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text('Payment', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700)),
              )
            ],
          )),
      bottomNavigationBar: bottomNav(),
      body: Container(
        width: Get.size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Due Payments", softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(color: color.colorConvert('#343048'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
            SizedBox(
              height: 24,
            ),
            getList(),
          ],
        ),
      ),
    );
  }

  void getUserPayment() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);

    var map = {'user_id': userId};
    ApiHandler.postApi(ApiProvider.baseUrl, EndApi.paymentInfo, map).then((value) {
      print("value ${value}");
      if (value['Status_code'] == "200" || value['Status_code'] == "201") {
        print("value ${value}");
        setState(() {
          list = PaymentModel.fromJson(value).result.toList();
        });
        for (int i = 0; i < list.length; i++) {
          isCheckedList.add(false);
        }
      }
    });
  }

  bottomNav() {
    return Container(
      color: Colors.white,
      height: 70,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total", softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert(color.primaryColor), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
              Text("₹ " + total.toString() + "/-", softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: color.colorConvert(color.primaryColor), fontWeight: FontWeight.w700, letterSpacing: 0.0))),
            ],
          ),
          SizedBox(
            width: 120,
            height: 45,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: color.colorConvert(color.primaryColor),
              onPressed: () {
                if (total != 0) {
                  openCheckout();
                } else {
                  ToastMessages.showToast(message: 'Please select payment', type: false);
                }
              },
              child: Text("Pay", softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.0))),
            ),
          )
        ],
      ),
    );
  }

  getList() {
    return Expanded(
        child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          height: 70,
          margin: EdgeInsets.only(top: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                child: Container(
                  height: 30,
                  child: Checkbox(
                      value: isCheckedList[index],
                      onChanged: (value) {
                        setState(() {
                          if (isCheckedList[index] == true) {
                            isCheckedList[index] = false;
                            total = total - int.parse(list[index].amount);
                          } else {
                            srNoList.add(json.encode(list[index].srNo));
                            isCheckedList[index] = true;
                            total = int.parse(list[index].amount) + total;
                          }
                        });
                      }),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list[index].srNo, softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15, color: color.colorConvert('#343048'), fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                  SizedBox(
                    height: 5,
                  ),
                  Text(list[index].amount != null ? "₹ " + list[index].amount : " ", softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.0))),
                ],
              ),
              /*RaisedButton(onPressed:()async{
                String path=await ExtStorage.getExternalStoragePublicDirectory(
                    ExtStorage.DIRECTORY_DOWNLOADS
                );
                var format=DateFormat('yyyy-MM-dd hh:MM:ss');
                DateTime date=DateTime.now();
                String fileName='invoice'+format.format(date).toString();
                String fullPath="$path/$fileName.pdf";

                downloadFile(dio,pdfUrl,fullPath);
              })*/

              GestureDetector(
                child: Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(width: 1, color: color.colorConvert(color.primaryColor))),
                  child: Center(
                    child: Text("Download Invoice", softWrap: false, style: GoogleFonts.openSans(textStyle: TextStyle(color: color.colorConvert(color.primaryColor), fontWeight: FontWeight.w500, letterSpacing: 0.0))),
                  ),
                ),
                onTap: () async {
                  String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                  var format = DateFormat('yyyy-MM-dd hh:MM:ss');
                  DateTime date = DateTime.now();
                  String fileName = 'invoice' + format.format(date).toString();
                  String fullPath = "$path/$fileName.pdf";
                  print("INVOICE ${list[index].invoice}");
                  downloadFile(dio, list[index].invoice, fullPath);
                  //downloadFile(); // click on notification to open downloaded file (for Android)
                },
              )
            ],
          ),
        );
      },
    ));
  }

/*
  void downloadFile()async {



    try{
      var response=await dio.post(pdfUrl,
        onReceiveProgress:showDownloadProgress,
        options:Options(
            responseType:ResponseType.bytes,
            followRedirects:false,
            validateStatus:(status){
              return status<500;
            }),
      );
      File file=File(savePath);
      var ref=file.openSync(mode:FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();
    }
    catch(e){
      print("ERROR IS:");

      print(e);
    }

    */
/*
    Directory document = await getApplicationDocumentsDirectory();
    String dir = (await getApplicationDocumentsDirectory()).path;

    print("document ${document}");
    final taskId = await FlutterDownloader.enqueue(
      url:'https://oneroofcm.com/admin/uploads/03.png',
      savedDir:dir,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
*/ /*


  }
*/

  void getPermission() async {
    await Permission.storage.request();
    await Permission.mediaLibrary.request();
  }

  void showDownloadProgress(int count, int total) {
    print("Progress ${total.toString()} ${count.toString()}");
  }

  void downloadFile(dio, String pdfUrl, String fullPath) async {
    try {
      var response = await dio.post(
        pdfUrl,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      File file = File(fullPath);
      var ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();
    } catch (e) {
      print("ERROR IS:");

      print(e);
    }
  }

  void openCheckout() {
    Box<String> appDb;
    appDb = Hive.box(ApiKeys.appDb);
    String mno = appDb.get(ApiKeys.mobile_number);

    var options = {
      "key": "rzp_live_Os2LKKNsvGEBQy",
      "amount": total * 100,
      "name": "One Roof",
      "description": "One roof payment",
      "prefill": {
        "contact": mno,
        "email": "abc@gmail.com",
      },
      "external": {
        "wallet": ["paytm"]
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void updatePayment({String paymentId}) {
    Box<String> appDb;

    appDb = Hive.box(ApiKeys.appDb);
    String userId = appDb.get(ApiKeys.userId);

    var map = {'user_id': userId, 'payment_id': "PID123", 'payment_status': '1', 'sr_no': json.encode(srNoList)};
    print("REQUEST ${map.toString()}");
    ApiHandler.putApi(ApiProvider.baseUrl, EndApi.paymentUpdate, map).then((value) {
      print("PAYMENT RES ${value.toString()}");
      if (value['status_code'] == '200') {
        ToastMessages.showToast(message: value['message'], type: true);
      } else {
        ToastMessages.showToast(message: value['message'], type: false);
      }
    });
  }
}
