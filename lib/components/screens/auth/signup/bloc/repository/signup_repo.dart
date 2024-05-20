import 'package:flutter/material.dart';
import 'package:gmit_practical/app/constants/api_constants.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/model/auth_models/signup_resp_model.dart';
import 'package:gmit_practical/app/utils/network_util.dart';

class SignupRepository {
  Future<SignupResponse?> userRegister(
      BuildContext context, {required Map<String, dynamic> requestBody}) async {
    try {
      var response = await NetworkUtil().post(
        ApiConstants.registerApiRoute,
        data: requestBody,
      );
      if (response != null) {
        SignupResponse signupResponse = SignupResponse.fromJson(response);
        return signupResponse;
      }
    } catch (error) {
      throw ErrorEntity(message: StringConstants.somethingWentWrong, code: -1);
    }
    return null;
  }
}
