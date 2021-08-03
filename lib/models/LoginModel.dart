class LoginModel {
  String statusCode;
  Result result;

  LoginModel({this.statusCode, this.result});

  LoginModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['Status_code'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status_code'] = this.statusCode;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String userId;
  String firstName;
  String lastName;
  String mobileNumber;
  String email;
  String types;
  String fcmToken;
  String hireDesignation;
  String verification;
  String swithchedRole;
  String profileIncomplete;
  String categoryName;

  Result(
      {this.userId,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.types,
        this.fcmToken,
        this.hireDesignation,
        this.verification,
        this.swithchedRole,
        this.profileIncomplete,
        this.categoryName});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    types = json['types'];
    fcmToken = json['fcm_token'];
    hireDesignation = json['hire_designation'];
    verification = json['verification'];
    swithchedRole = json['swithched_role'];
    profileIncomplete = json['profile incomplete'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['types'] = this.types;
    data['fcm_token'] = this.fcmToken;
    data['hire_designation'] = this.hireDesignation;
    data['verification'] = this.verification;
    data['swithched_role'] = this.swithchedRole;
    data['profile incomplete'] = this.profileIncomplete;
    data['category_name'] = this.categoryName;
    return data;
  }
}
