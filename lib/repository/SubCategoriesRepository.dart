/*
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:one_roof/models/SubCategoryModel.dart';
import 'package:one_roof/networking/ApiProvider.dart';
import 'package:one_roof/networking/EndApi.dart';

abstract class SubCategoriesRepository {
  Future<List<SubcategoryList>> getSubCategories();
}

class SubCategoryImpl implements SubCategoriesRepository {
  var map = {'category_id': 2};

  @override
  Future<List<SubcategoryList>> getSubCategories() async {
    var response = await http.post(ApiProvider.baseUrl + EndApi.subCategpory, body: map);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);
      List<SubcategoryList> list = SubCategoryModel.fromJson(data).subcategoryList;

      return list;
    } else {
      throw Exception();
    }
  }
}
*/
