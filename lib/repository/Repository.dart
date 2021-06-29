import 'dart:async';
import 'package:one_roof/models/NotificationsModel.dart';
import 'package:one_roof/networking/ApiHandler.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';
import 'package:one_roof/networking/ApiKeys.dart';
abstract class NotificationRepository{
  Future <List<Result>> getNotifications();
}

class NotificationRepo implements NotificationRepository{
  @override
  Future<List<Result>> getNotifications() {
    var map;
    List<Result>listNotifications=[];
    ApiHandler.postApi(ApiProvider.baseUrl,EndApi.notification, map).then((value) {
      map=value;
      listNotifications=NotificationsModel.fromJson(map).result.toList();
      return listNotifications;
    });
  }
}