import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gmit_practical/app/constants/app_constants.dart';
import 'package:gmit_practical/app/constants/color_constant.dart';
import 'package:gmit_practical/app/constants/image_constants.dart';
import 'package:gmit_practical/app/constants/text_style_constants.dart';
import 'package:gmit_practical/app/utils/route_util.dart';
import 'package:gmit_practical/app/utils/shared_pref_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPrefUtil sharedPrefUtil = SharedPrefUtil();
    bool isLoggedId = sharedPrefUtil.getBool(SharedPrefUtil.keyIsLoggedIn);
    bool isUserRemember = sharedPrefUtil.getBool(SharedPrefUtil.keyUserRemember);
    if (isLoggedId && isUserRemember) {
      RouteUtil.visitHomePage(context);
    } else {
      sharedPrefUtil.clearPreference();
      RouteUtil.visitLoginPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageConstants.appLogo,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              AppConstants.appName,
              style: CustomTextStyle.getBoldText(
                  textSize: 22, textColor: ColorConstants.primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
