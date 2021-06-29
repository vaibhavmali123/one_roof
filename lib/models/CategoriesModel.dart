class CategoriesModel {
  List<CategoryList> categoryList;

  CategoriesModel({this.categoryList});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['Category_list'] != null) {
      categoryList = new List<CategoryList>();
      json['Category_list'].forEach((v) {
        categoryList.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryList != null) {
      data['Category_list'] = this.categoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  String id;
  String categoryName;
  String colorCode;
  String image;

  CategoryList({this.id, this.categoryName, this.colorCode, this.image});

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    colorCode = json['color_code'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['color_code'] = this.colorCode;
    data['image'] = this.image;
    return data;
  }
}
