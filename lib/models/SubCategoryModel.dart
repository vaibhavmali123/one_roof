class SubCategoryModel {
  String statusCode;
  String message;
  List<SubcategoryList> subcategoryList;

  SubCategoryModel({this.statusCode, this.message, this.subcategoryList});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['subcategory_list'] != null) {
      subcategoryList = new List<SubcategoryList>();
      json['subcategory_list'].forEach((v) {
        subcategoryList.add(new SubcategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.subcategoryList != null) {
      data['subcategory_list'] =
          this.subcategoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubcategoryList {
  String subcstegoryId;
  String categoryId;
  String subcategory;
  String image;
  String colorCode;

  SubcategoryList(
      {this.subcstegoryId,
        this.categoryId,
        this.subcategory,
        this.image,
        this.colorCode});

  SubcategoryList.fromJson(Map<String, dynamic> json) {
    subcstegoryId = json['subcstegory_id'];
    categoryId = json['category_id'];
    subcategory = json['subcategory'];
    image = json['image'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcstegory_id'] = this.subcstegoryId;
    data['category_id'] = this.categoryId;
    data['subcategory'] = this.subcategory;
    data['image'] = this.image;
    data['color_code'] = this.colorCode;
    return data;
  }
}
