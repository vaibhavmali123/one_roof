class SpecialisationsModel {
  String statusCode;
  String message;
  List<SpecialisationList> specialisationList;

  SpecialisationsModel(
      {this.statusCode, this.message, this.specialisationList});

  SpecialisationsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['specialisation_list'] != null) {
      specialisationList = new List<SpecialisationList>();
      json['specialisation_list'].forEach((v) {
        specialisationList.add(new SpecialisationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.specialisationList != null) {
      data['specialisation_list'] =
          this.specialisationList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecialisationList {
  String id;
  String subcategoryId;
  String specialisation;

  SpecialisationList({this.id, this.subcategoryId, this.specialisation});

  SpecialisationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subcategoryId = json['subcategory_id'];
    specialisation = json['specialisation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subcategory_id'] = this.subcategoryId;
    data['specialisation'] = this.specialisation;
    return data;
  }
}
