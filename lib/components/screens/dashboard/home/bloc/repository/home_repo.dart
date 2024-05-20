import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmit_practical/app/constants/api_constants.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/model/dashboard/product_list_resp_model.dart';
import 'package:gmit_practical/app/utils/network_util.dart';

class HomeRepository {
  static CancelToken cancelToken = CancelToken();

  Future<ProductListResponse?> getProducts(BuildContext context) async {
    try {
      var response = await NetworkUtil().get(
        ApiConstants.productsListApiRoute,
      );
      if (response != null) {
        ProductListResponse loginResponse =
            ProductListResponse.fromJson(response);
        return loginResponse;
      }
    } catch (error) {
      throw ErrorEntity(message: StringConstants.somethingWentWrong, code: -1);
    }
    return null;
  }

  Future<ProductListResponse?> getSearchProducts(BuildContext context,
      {required searchText}) async {
    try {
      var response = await NetworkUtil().get(
          ApiConstants.productsSearchApiRoute,
          queryParameters: {"q": searchText},
          cancelToken: cancelToken);
      if (response != null) {
        ProductListResponse loginResponse =
            ProductListResponse.fromJson(response);
        return loginResponse;
      }
    } catch (error) {
      throw ErrorEntity(message: StringConstants.somethingWentWrong, code: -1);
    }
    return null;
  }
}
