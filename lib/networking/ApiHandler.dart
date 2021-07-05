import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_roof/utils/ToastMessages.dart';

class ApiHandler {
  static var client = http.Client();

  static Future<Map<String, dynamic>> postApi(String baseUrl, String endApi, var map) async {
    var response = await http.post(baseUrl + endApi, body: map);
    print("RESPONSE body: ${response.body}");
    debugPrint("RESPONSE LONG: ${response.body}", wrapWidth: 1024);

    Map<String, dynamic> mapResponse;
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RESPONSE: ${response.body.toString()}");

        mapResponse = json.decode(response.body);
        return mapResponse;
      }
    } finally {}
  }

  static Future<Map<String, dynamic>> requestApi(String baseUrl, String endApi) async {
    var response = await client.get(baseUrl + endApi);
    Map<String, dynamic> mapResponse;

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RESPONSE: ${response.body.toString()}");

        mapResponse = json.decode(response.body);
        return mapResponse;
      } else {
        ToastMessages.showToast(message: response.body.toString(), type: false);
      }
    } finally {}
  }

  static Future<Map<String, dynamic>> putApi(
    String baseUrl,
    String endApi,
    var map,
  ) async {
    Map<String, dynamic> mapResponse;

    var response = await client.put(baseUrl + endApi, body: json.encode(map));
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RESPONSE: ${response.body.toString()}");

        mapResponse = json.decode(response.body);
        return mapResponse;
      } else {
        ToastMessages.showToast(message: response.body.toString(), type: false);
      }
    } finally {}
  }
}
