import 'package:equatable/equatable.dart';
import 'package:one_roof/models/SubCategoryModel.dart';
import 'package:meta/meta.dart';
abstract class SubcatState extends Equatable
{

}
class SubcatInitialState extends SubcatState
{
  @override
  // TODO: implement props
  List<Object> get props =>[];

}
class SubCatLoadingState extends SubcatState
{
  @override
  // TODO: implement props
  List<Object> get props =>[];

}
class SubCatLoadedState extends SubcatState
{
  List<SubcategoryList>list;

  SubCatLoadedState({@required this.list});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class SubCatErrorState extends SubcatState
{
  String message;


  SubCatErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}