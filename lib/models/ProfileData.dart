class ProfileData {
  String statusCode;
  String message;
  List<Result> result;

  ProfileData({this.statusCode, this.message, this.result});

  ProfileData.fromJson(Map<String, dynamic> json) {
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
  String firstName;
  String lastName;
  String mobileNumber;
  String email;
  String types;
  String organizationNameHire;
  String organizationNameWork;
  String address;
  String panNo;
  String gstNo;
  String experience;

  Result({this.id, this.firstName, this.lastName, this.mobileNumber, this.email, this.types, this.organizationNameHire, this.organizationNameWork, this.address, this.panNo, this.gstNo, this.experience});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    types = json['types'];
    organizationNameHire = json['organization_name_hire'];
    organizationNameWork = json['organization_name_work'];
    address = json['address'];
    panNo = json['pan_no'];
    gstNo = json['gst_no'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['types'] = this.types;
    data['organization_name_hire'] = this.organizationNameHire;
    data['organization_name_work'] = this.organizationNameWork;
    data['address'] = this.address;
    data['pan_no'] = this.panNo;
    data['gst_no'] = this.gstNo;
    data['experience'] = this.experience;
    return data;
  }
}
