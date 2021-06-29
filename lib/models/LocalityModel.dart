class LocalityModel {
  String statusCode;
  String message;
  List<LocalityList> localityList;

  LocalityModel({this.statusCode, this.message, this.localityList});

  LocalityModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['locality_list'] != null) {
      localityList = new List<LocalityList>();
      json['locality_list'].forEach((v) {
        localityList.add(new LocalityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.localityList != null) {
      data['locality_list'] = this.localityList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocalityList {
  String localityId;
  String cityId;
  String areaName;

  LocalityList({this.localityId, this.cityId, this.areaName});

  LocalityList.fromJson(Map<String, dynamic> json) {
    localityId = json['locality_id'];
    cityId = json['city_id'];
    areaName = json['area_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locality_id'] = this.localityId;
    data['city_id'] = this.cityId;
    data['area_name'] = this.areaName;
    return data;
  }
}
