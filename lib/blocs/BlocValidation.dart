import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:one_roof/blocs/bloc.dart';
import 'package:rxdart/rxdart.dart';

class BlocValidation implements BaseBloc
{


  final firstNameStreamController=BehaviorSubject<String>();
  final lastNameStreamController=BehaviorSubject<String>();
  final mnoStreamController=BehaviorSubject<String>();
  final emailStreamController=BehaviorSubject<String>();
  final passwordStreamController=BehaviorSubject<String>();
     updateData(String fName,lName,mno,email,password){
       print("DATA FNAME ${fName}");
       firstNameStreamController.sink.add("fName");
       /*fName.length>0?firstNameStreamController.sink.add(fName):
    firstNameStreamController.sink.addError('First name should not empty');
*/
    firstNameStreamController.sink.add(lName);
    firstNameStreamController.sink.add(mno);
    firstNameStreamController.sink.add(email);
    firstNameStreamController.sink.add(password);
  }
/*
  Function(String) get fNameSink=>firstNameStreamController.sink.add;
  Function(String) get lNameSink=>firstNameStreamController.sink.add;
  Function(String) get mnoSink=>firstNameStreamController.sink.add;
  Function(String) get emailSink=>firstNameStreamController.sink.add;
  Function(String) get passwordSink=>firstNameStreamController.sink.add;
*/

  Stream<String> get fNameStream => firstNameStreamController.stream;
  Stream<String> get sNameStream=>firstNameStreamController.stream;
  Stream<String> get mnoStream=>firstNameStreamController.stream;
  Stream<String> get emailStream=>firstNameStreamController.stream;
  Stream<String> get passwordStream=>firstNameStreamController.stream;


  @override
  void dispose() {
    // TODO: implement dispose
  }

}