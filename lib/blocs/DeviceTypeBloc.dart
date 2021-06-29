import 'dart:async';
import 'package:one_roof/blocs/bloc.dart';
import 'package:rxdart/rxdart.dart';

class DeviceTypeBloc implements BaseBloc
{
  final deviceTypeController=BehaviorSubject<String>();

  Function (String) get deviceChanged => deviceTypeController.sink.add;

  Stream<String> get deviceType =>deviceTypeController.stream;

  @override
  void dispose() {
    deviceTypeController?.close();
  }

}