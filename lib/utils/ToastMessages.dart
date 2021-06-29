import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessages {
  static void showToast({String message, bool type}) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 10, backgroundColor: type == false ? Colors.red : Colors.green, textColor: Colors.white, fontSize: 16.0);
  }
}
