class UnitsModel {
  List<UnitsList> unitsList;

  UnitsModel({this.unitsList});

  UnitsModel.fromJson(Map<String, dynamic> json) {
    if (json['Units_list'] != null) {
      unitsList = new List<UnitsList>();
      json['Units_list'].forEach((v) {
        unitsList.add(new UnitsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.unitsList != null) {
      data['Units_list'] = this.unitsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnitsList {
  String id;
  String unit;

  UnitsList({this.id, this.unit});

  UnitsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unit'] = this.unit;
    return data;
  }
}
