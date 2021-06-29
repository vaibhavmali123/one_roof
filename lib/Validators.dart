import 'dart:async';

class Validators
{
  var emailValidator=StreamTransformer<String,String>.fromHandlers(
    handleData:(email,sink){
      if (email.contains('@')) {
        sink.add(email);
      }
      else
        {
          sink.addError('Email is invalid');
        }
    }
  );
  var passwordValidator=StreamTransformer<String,String>.fromHandlers(
      handleData:(password,sink){
        if (password.length>0) {
          sink.add(password);
        }
        else
        {
          sink.addError('Password should not empty');
        }
      }
  );
}