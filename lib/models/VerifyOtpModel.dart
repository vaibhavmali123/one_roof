class VerifyOtpModel {
  String statusCode;
  String message;
  Result result;

  VerifyOtpModel({this.statusCode, this.message, this.result});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String id;
  String firstName;
  String lastName;
  String mobileNumber;
  String email;
  String types;

  Result({this.id, this.firstName, this.lastName, this.mobileNumber, this.email, this.types});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    types = json['types'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['types'] = this.types;
    return data;
  }
}
