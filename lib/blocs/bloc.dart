import 'dart:async';

import 'package:one_roof/Validators.dart';
import 'package:rxdart/rxdart.dart';

class bloc extends Object with Validators implements BaseBloc {
  final emailController = BehaviorSubject<String>();

  final passwordController = BehaviorSubject<String>();
  final submitConroller = BehaviorSubject<bool>();

  StreamController<bool> dropDownController = StreamController<bool>.broadcast();

  StreamSink get streamSink => dropDownController.sink;
  void dropDownOpened() => streamSink.add(true);
  Stream<bool> get isdropDownOpen => dropDownController.stream;
  // void dropDownClosed()=>streamSink.add(false);

  Function(String) get emailChanged => emailController.sink.add;
  Function(String) get passwordChanged => passwordController.sink.add;
  Function(bool) get submitSink => submitConroller.sink.add;

  Stream get isDropDownOpen => dropDownController.stream;
  Stream<String> get email => emailController.stream.transform(emailValidator);
  Stream<String> get password => passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck => Observable.combineLatest2(email, password, (e, p) => true);

  @override
  void dispose() {
    emailController?.close();
    passwordController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
