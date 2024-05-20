part of 'login_bloc.dart';

class LoginState extends Equatable {
  bool? obSecureText = false;
  bool? checked = false;
  bool? loginLoading;

  LoginState({
    this.obSecureText,
    this.checked,
    this.loginLoading,
  });

  LoginState copyWith({
    bool? obSecureText,
    bool? checked,
    bool? loginLoading,
  }) {
    return LoginState(
      obSecureText: obSecureText ?? this.obSecureText,
      checked: checked ?? this.checked,
      loginLoading: loginLoading ?? this.loginLoading,
    );
  }

  @override
  List<Object?> get props => [
        obSecureText,
        checked,
        loginLoading,
      ];
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}
