import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart'hide Response;
import 'package:path/path.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'dart:io';

class Upload
{
static Future<void> uploadFile(file)async{

  print("path ${file.runtimeType}");
  print("path ${file.toString()}");
  String fileName = file.path.split('/').last;

  FormData data = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      file.path,
      filename: fileName,
    ),
  });

  Dio dio = new Dio();

  dio.post("http://sncfinancialconsulting.in/one_roof/index.php/api/FileUpload/uploadFile", data: data)
      .then((response) => print(response))
      .catchError((error) => print(error));
}
static Future<Map<String,dynamic>>uploader(file)async{
  dynamic prog;
  Map<String,dynamic>map;
  final uploader = FlutterUploader();
  String fileName = await file.path.split('/').last;

  final taskId=await uploader.enqueue(url:'http://sncfinancialconsulting.in/one_roof/index.php/api/FileUpload/uploadFile',
      files:[FileItem(filename:fileName,
          savedDir:'/storage/emulated/0/Android/data/com.arraypointer.one_roof/files/Pictures/', fieldname:"file")],
    method:UploadMethod.POST,
      headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
      showNotification:true
  );
  final subscription = uploader.progress.listen((progress) {

  });

  final subscription1 = uploader.result.listen((result) {
//    print("Progress result ${result.response}");

   // return result.response;
    }, onError: (ex, stacktrace) {
  });
  subscription1.onData((data)async {

map=await json.decode(data.response);

  });
  return map;
}
}