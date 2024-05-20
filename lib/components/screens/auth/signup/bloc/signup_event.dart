part of 'signup_bloc.dart';

class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class PasswordSecureEvent extends SignupEvent {
  bool? obSecureText;

  PasswordSecureEvent({this.obSecureText});

  @override
  List<Object?> get props => [obSecureText];
}

class UserSignupEvent extends SignupEvent {
  String? firstName;
  String? lastName;
  String? userName;
  String? userEmail;
  String? userContact;
  String? userAge;
  String? userPassword;
  Completer completer;

  UserSignupEvent(
      {this.firstName,
      this.lastName,
      this.userName,
      this.userEmail,
      this.userContact,
      this.userAge,
      this.userPassword,
      required this.completer});

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        userName,
        userEmail,
        userContact,
        userAge,
        userPassword,
        completer
      ];
}
