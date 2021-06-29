import 'package:equatable/equatable.dart';
import 'package:one_roof/models/NotificationsModel.dart';

abstract class NotificationsState extends Equatable {
  @override
  List<Object> get props {}
}

class NotificationsLoading extends NotificationsState {

}

class NotificationsLoaded extends NotificationsState {
  List<Result> listNotifications;

  NotificationsLoaded({this.listNotifications});
}

class NotificationsError extends NotificationsState {
  var message;

  NotificationsError(this.message);
}

class Notificationsinitial extends NotificationsState {

}
