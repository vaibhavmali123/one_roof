class SignupModel {
  String statusCode;
  String isExist;
  Result result;

  SignupModel({this.statusCode, this.isExist, this.result});

  SignupModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    isExist = json['is_exist'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['is_exist'] = this.isExist;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String userId;
  String mobileNumber;
  String otp;

  Result({this.userId, this.mobileNumber, this.otp});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    mobileNumber = json['mobile_number'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['mobile_number'] = this.mobileNumber;
    data['otp'] = this.otp;
    return data;
  }
}
