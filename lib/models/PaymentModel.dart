class PaymentModel {
  String statusCode;
  String message;
  List<Result> result;

  PaymentModel({this.statusCode, this.message, this.result});

  PaymentModel.fromJson(Map<String, dynamic> json) {
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
  String srNo;
  String amount;
  String invoice;

  Result({this.id, this.userId, this.srNo, this.amount, this.invoice});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    srNo = json['sr_no'];
    amount = json['amount'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['sr_no'] = this.srNo;
    data['amount'] = this.amount;
    data['invoice'] = this.invoice;
    return data;
  }
}
