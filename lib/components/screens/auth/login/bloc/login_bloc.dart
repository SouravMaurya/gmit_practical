import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/model/auth_models/login_resp_model.dart';
import 'package:gmit_practical/app/utils/network_util.dart';
import 'package:gmit_practical/app/utils/shared_pref_util.dart';
import 'package:gmit_practical/app/utils/utils.dart';
import 'package:gmit_practical/components/screens/auth/login/bloc/repository/login_repo.dart';
import 'package:gmit_practical/main.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository loginRepository = LoginRepository();

  LoginBloc() : super(LoginInitial()) {
    on<PasswordSecureEvent>(onPasswordSecureEvent);
    on<RememberMeEvent>(onRememberMeEvent);
    on<UserLoginEvent>(onUserLoginEvent);
  }

  void onPasswordSecureEvent(
      PasswordSecureEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(obSecureText: event.obSecureText));
  }

  void onRememberMeEvent(RememberMeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(checked: event.checked));
  }

  Future<void> onUserLoginEvent(
      UserLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginLoading: true));
    try {
      LoginResponse? loginResponse = await loginRepository.userLogin(
          globalNavigationKey.currentState!.context,
          event.userName ?? "",
          event.password ?? "");
      if (loginResponse != null) {
        Utils.showToast(StringConstants.loginSuccessFul);
        await saveUserDataLocally(loginResponse);
        emit(state.copyWith(loginLoading: false));
        event.completer.complete(loginResponse);
      }
    } catch (e) {
      emit(state.copyWith(loginLoading: false));
      event.completer.completeError(e);
      Utils.showToast(e.toString());
    }
  }

  Future saveUserDataLocally(LoginResponse userDataModel) async {
    SharedPrefUtil sharedPrefUtil = SharedPrefUtil();
    sharedPrefUtil.saveString(SharedPrefUtil.keyUserName,
        ("${userDataModel.firstName ?? ""} ${userDataModel.lastName ?? ""}"));
    sharedPrefUtil.saveString(
        SharedPrefUtil.keyUserToken, (userDataModel.token ?? ""));
    sharedPrefUtil.saveString(
        SharedPrefUtil.keyUserProfile, (userDataModel.image ?? ""));
    sharedPrefUtil.saveBool(SharedPrefUtil.keyIsLoggedIn, true);
    sharedPrefUtil.saveBool(
        SharedPrefUtil.keyUserRemember, state.checked ?? false);
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    super.onTransition(transition);
    debugPrint("LoginBloc Event ---> ${transition.event}");
    debugPrint("LoginBloc CurrentState ---> ${transition.currentState}");
    debugPrint("LoginBloc NextState ---> ${transition.nextState}");
  }


}
