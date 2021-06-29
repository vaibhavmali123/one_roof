class DurationModel {
  List<DurationList> durationList;

  DurationModel({this.durationList});

  DurationModel.fromJson(Map<String, dynamic> json) {
    if (json['Duration_list'] != null) {
      durationList = new List<DurationList>();
      json['Duration_list'].forEach((v) {
        durationList.add(new DurationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.durationList != null) {
      data['Duration_list'] = this.durationList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DurationList {
  String id;
  String durationTime;

  DurationList({this.id, this.durationTime});

  DurationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    durationTime = json['duration_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['duration_time'] = this.durationTime;
    return data;
  }
}
