part of 'signup_bloc.dart';

class SignupState extends Equatable {
  bool? obSecureText = false;
  bool? signupLoading;

  SignupState({
    this.obSecureText,
    this.signupLoading,
  });

  SignupState copyWith({
    bool? obSecureText,
    bool? signupLoading,
  }) {
    return SignupState(
      obSecureText: obSecureText ?? this.obSecureText,
      signupLoading: signupLoading ?? this.signupLoading,
    );
  }

  @override
  List<Object?> get props => [
        obSecureText,
        signupLoading,
      ];
}

final class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}
