import 'package:flutter/material.dart';

class color
{
  static String primaryColor='#0457BE';
  static Color hintColor=Colors.red;
  static Color textColor=Colors.red;

  static String accountCardColor='#e9f7f5';
  static Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    }
  }
}