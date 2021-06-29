class WorkerDetailsModel {
  List<Order> order;
  String statusCode;
  String message;
  Result result;

  WorkerDetailsModel({this.order, this.statusCode, this.message, this.result});

  WorkerDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['order'] != null) {
      order = new List<Order>();
      json['order'].forEach((v) {
        order.add(new Order.fromJson(v));
      });
    }
    statusCode = json['Status_code'];
    message = json['message'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order.map((v) => v.toJson()).toList();
    }
    data['Status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Order {
  String subcategory;
  Null id;
  String name;
  int count;

  Order({this.subcategory, this.id, this.name, this.count});

  Order.fromJson(Map<String, dynamic> json) {
    subcategory = json['subcategory'];
    id = json['id'];
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcategory'] = this.subcategory;
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}

class Result {
  String id;
  String firstName;
  String lastName;
  String mobileNumber;
  String email;
  String category;
  String skilledLabour;
  String nonSkilledLabour;
  String technicalStaff;
  String turnover;
  String rating;

  Result({this.id, this.firstName, this.lastName, this.mobileNumber, this.email, this.category, this.skilledLabour, this.nonSkilledLabour, this.technicalStaff, this.turnover, this.rating});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    category = json['category'];
    skilledLabour = json['skilled_labour'];
    nonSkilledLabour = json['non_skilled_labour'];
    technicalStaff = json['technical_staff'];
    turnover = json['turnover'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['category'] = this.category;
    data['skilled_labour'] = this.skilledLabour;
    data['non_skilled_labour'] = this.nonSkilledLabour;
    data['technical_staff'] = this.technicalStaff;
    data['turnover'] = this.turnover;
    data['rating'] = this.rating;
    return data;
  }
}
