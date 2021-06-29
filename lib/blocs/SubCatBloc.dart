/*
import 'package:bloc/bloc.dart';
import 'package:one_roof/blocs/SubCatEvent.dart';
import 'package:one_roof/blocs/SubcatState.dart';
import 'package:one_roof/models/SubCategoryModel.dart';
import 'package:one_roof/repository/SubCategoriesRepository.dart';
class SubCatBloc extends Bloc<SubCatEvent,SubcatState>
{
//  SubCategoriesRepository subCategoriesRepository;

//  SubCatBloc({SubcatState initialState,this.subCategoriesRepository}) : super(initialState);

  SubcatState get initialState =>SubcatInitialState();


  @override
  Stream<SubcatState> mapEventToState(SubCatEvent event)
  async*{
  if (event is FetchSubCatEvent) {
    yield SubCatLoadingState();
    try{
      //List<SubcategoryList>list=await subCategoriesRepository.getSubCategories();
      //yield SubCatLoadedState(list:list);
    }
    catch(e){
    yield SubCatErrorState(message:e.toString());
    }
  }    
  }
}*/
