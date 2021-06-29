class CitiesModel {
  List<CitiesList> citiesList;

  CitiesModel({this.citiesList});

  CitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['Cities_list'] != null) {
      citiesList = new List<CitiesList>();
      json['Cities_list'].forEach((v) {
        citiesList.add(new CitiesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.citiesList != null) {
      data['Cities_list'] = this.citiesList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CitiesList {
  String id;
  String cityName;

  CitiesList({this.id, this.cityName});

  CitiesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_name'] = this.cityName;
    return data;
  }
}
