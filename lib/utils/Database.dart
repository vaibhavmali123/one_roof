import 'package:hive/hive.dart';
import 'package:one_roof/networking/ApiKeys.dart';

class Database{
  static Box<String> appDb= Hive.box(ApiKeys.appDb);

  static setUserId(String userId){
    appDb.put(ApiKeys.userId,
        userId);
  }


  static getUserId (){
    return appDb.get(ApiKeys.userId);
  }

}