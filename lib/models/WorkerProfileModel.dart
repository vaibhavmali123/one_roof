class WorkerProfileModel {
  String id;
  String machinariesEquipments;
  Equipments equipments;
  int skilledLabour;
  int nonSkilledLabour;
  int technicalStaff;
  int turnover;
  String file;

  WorkerProfileModel({this.id, this.machinariesEquipments, this.equipments, this.skilledLabour, this.nonSkilledLabour, this.technicalStaff, this.turnover, this.file});

  WorkerProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    machinariesEquipments = json['machinaries_equipments'];
    equipments = json['equipments'] != null ? new Equipments.fromJson(json['equipments']) : null;
    skilledLabour = json['skilled_labour'];
    nonSkilledLabour = json['non_skilled_labour'];
    technicalStaff = json['technical_staff'];
    turnover = json['turnover'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['machinaries_equipments'] = this.machinariesEquipments;
    if (this.equipments != null) {
      data['equipments'] = this.equipments.toJson();
    }
    data['skilled_labour'] = this.skilledLabour;
    data['non_skilled_labour'] = this.nonSkilledLabour;
    data['technical_staff'] = this.technicalStaff;
    data['turnover'] = this.turnover;
    data['file'] = this.file;
    return data;
  }
}

class Equipments {
  List<Machine> machine;

  Equipments({this.machine});

  Equipments.fromJson(Map<String, dynamic> json) {
    if (json['Machine'] != null) {
      machine = new List<Machine>();
      json['Machine'].forEach((v) {
        machine.add(new Machine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.machine != null) {
      data['Machine'] = this.machine.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Machine {
  String subcategory;
  Null id;
  String name;
  int count;

  Machine({this.subcategory, this.id, this.name, this.count});

  Machine.fromJson(Map<String, dynamic> json) {
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
