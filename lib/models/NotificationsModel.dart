class NotificationsModel {
  String statusCode;
  String message;
  List<Result> result;

  NotificationsModel({this.statusCode, this.message, this.result});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['Status_code'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String id;
  String userId;
  String notification;
  String type;
  String date;

  Result({this.id, this.userId, this.notification, this.type, this.date});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    notification = json['notification'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['notification'] = this.notification;
    data['type'] = this.type;
    data['date'] = this.date;
    return data;
  }
}
