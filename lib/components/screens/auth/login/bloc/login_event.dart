part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class PasswordSecureEvent extends LoginEvent {
  bool? obSecureText;

  PasswordSecureEvent({this.obSecureText});

  @override
  List<Object?> get props => [obSecureText];
}

class RememberMeEvent extends LoginEvent {
  bool? checked;

  RememberMeEvent({this.checked});

  @override
  List<Object?> get props => [checked];
}

class UserLoginEvent extends LoginEvent {
  String? userName;
  String? password;
  Completer completer;

  UserLoginEvent({this.userName, this.password, required this.completer});

  @override
  List<Object?> get props => [userName, password, completer];
}
