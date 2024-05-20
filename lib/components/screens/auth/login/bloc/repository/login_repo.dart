import 'package:flutter/material.dart';
import 'package:gmit_practical/app/constants/api_constants.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/model/auth_models/login_resp_model.dart';
import 'package:gmit_practical/app/utils/network_util.dart';

class LoginRepository {
  Future<LoginResponse?> userLogin(
      BuildContext context, String userName, String password) async {
    try {
      var response = await NetworkUtil().post(
        ApiConstants.loginApiRoute,
        data: {"username": userName, "password": password, "expiresInMins": 30},
      );
      if (response != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(response);
        return loginResponse;
      }
    } catch (error) {
      throw ErrorEntity(message: StringConstants.somethingWentWrong, code: -1);
    }
    return null;
  }
}
