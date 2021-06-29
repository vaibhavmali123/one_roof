import 'dart:async';

class DeepLinkBloc
{
  StreamController<bool> streamController=StreamController<bool>.broadcast();

  Stream<bool>get isFromDeepLink=>streamController.stream;

}