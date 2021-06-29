import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_roof/blocs/Event.dart';
import 'package:one_roof/models/NotificationsModel.dart';
import 'package:one_roof/blocs/States.dart';
import 'package:one_roof/repository/Repository.dart';

class NotificationsBloc extends Bloc<NotificationsEvent,NotificationsState>{
 final NotificationRepo notificationRepo;
List<Result>listNotifications=[];

  NotificationsBloc({this.notificationRepo}) : super(Notificationsinitial());

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event)async*
  {
  switch(event){
    case NotificationsEvent.fetchNotifications:
      yield NotificationsLoading();
      listNotifications=await notificationRepo.getNotifications();
      yield NotificationsLoaded(listNotifications:listNotifications);
      break;

  }
  }
}