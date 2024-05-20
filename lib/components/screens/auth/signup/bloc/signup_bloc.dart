import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/model/auth_models/signup_resp_model.dart';
import 'package:gmit_practical/app/utils/shared_pref_util.dart';
import 'package:gmit_practical/app/utils/utils.dart';
import 'package:gmit_practical/components/screens/auth/signup/bloc/repository/signup_repo.dart';
import 'package:gmit_practical/main.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupRepository signupRepository = SignupRepository();

  SignupBloc() : super(SignupInitial()) {
    on<PasswordSecureEvent>(onPasswordSecureEvent);
    on<UserSignupEvent>(onUserSignupEvent);
  }

  void onPasswordSecureEvent(
      PasswordSecureEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(obSecureText: event.obSecureText));
  }

  Future<void> onUserSignupEvent(
      UserSignupEvent event, Emitter<SignupState> emit) async {
    emit(state.copyWith(signupLoading: true));
    try {
      Map<String, dynamic> requestBody = {
        "firstName": event.firstName,
        "lastName": event.lastName,
        "age": event.userAge,
        "phone": event.userContact,
        "email": event.userEmail,
        "username": event.userName,
        "password": event.userPassword
      };
      SignupResponse? loginResponse = await signupRepository.userRegister(
          globalNavigationKey.currentState!.context,
          requestBody: requestBody);
      if (loginResponse != null) {
        Utils.showToast(StringConstants.loginSuccessFul);
        await saveUserDataLocally(loginResponse);
        emit(state.copyWith(signupLoading: false));
        event.completer.complete();
      }
    } catch (e) {
      emit(state.copyWith(signupLoading: false));
      event.completer.completeError(e);
      Utils.showToast(e.toString());
    }
  }

  Future saveUserDataLocally(SignupResponse userDataModel) async {
    SharedPrefUtil sharedPrefUtil = SharedPrefUtil();
    sharedPrefUtil.saveString(SharedPrefUtil.keyUserName,
        ("${userDataModel.firstName ?? ""} ${userDataModel.lastName ?? ""})"));
    sharedPrefUtil.saveString(
        SharedPrefUtil.keyUserProfile, (userDataModel.image ?? ""));
    sharedPrefUtil.saveBool(SharedPrefUtil.keyIsLoggedIn, true);
    sharedPrefUtil.saveBool(SharedPrefUtil.keyUserRemember, true);
  }

  @override
  void onTransition(Transition<SignupEvent, SignupState> transition) {
    super.onTransition(transition);
    debugPrint("SignupBloc Event ---> ${transition.event}");
    debugPrint("SignupBloc CurrentState ---> ${transition.currentState}");
    debugPrint("SignupBloc NextState ---> ${transition.nextState}");
  }
}
