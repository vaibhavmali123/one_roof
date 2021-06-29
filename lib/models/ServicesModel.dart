class ServicesModel {
  List<TypeList> typeList;

  ServicesModel({this.typeList});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    if (json['Type_list'] != null) {
      typeList = new List<TypeList>();
      json['Type_list'].forEach((v) {
        typeList.add(new TypeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.typeList != null) {
      data['Type_list'] = this.typeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypeList {
  String id;
  String name;

  TypeList({this.id, this.name});

  TypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
