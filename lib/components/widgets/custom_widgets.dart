import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmit_practical/app/constants/color_constant.dart';
import 'package:gmit_practical/app/constants/image_constants.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/constants/text_style_constants.dart';
import 'package:gmit_practical/components/widgets/custom_text_field.dart';
import 'package:gmit_practical/main.dart';

class CustomWidgets {
  static Widget getLoaderButton(BuildContext context,
      {required String buttonText,
      String? buttonIcon,
      bool? isLoading,
      Color? buttonColor,
      Color? textColor,
      Color? loaderColor,
      double? textSize,
      double? loaderSize,
      Function? onClick}) {
    return InkWell(
      onTap: () {
        onClick!();
      },
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor ?? ColorConstants.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorConstants.primaryColor, width: 1.w)),
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if ((buttonIcon ?? "").isNotEmpty) SvgPicture.asset(buttonIcon!),
              if ((buttonIcon ?? "").isNotEmpty)
                SizedBox(
                  width: 10.w,
                ),
              (isLoading ?? false)
                  ? SpinKitThreeBounce(
                      size: loaderSize ?? 23,
                      color: loaderColor ?? ColorConstants.whiteColor,
                    )
                  : Text(
                      buttonText,
                      style: CustomTextStyle.getMediumText(
                          textSize: textSize ?? 14.h,
                          textColor: textColor ?? ColorConstants.blackColor),
                    )
            ],
          ),
        ),
      ),
    );
  }

  static Widget showAuthTopView(BuildContext context, {required bool isLogin}) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SafeArea(child: welcomeText(isLogin)),
        SizedBox(
          height: size.height * 0.03,
        ),
        Image.asset(
          ImageConstants.appLogo,
          height: size.height / 8,
          width: size.height / 8,
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        pageText(isLogin),
      ],
    );
  }

  static Widget getSearchBar(BuildContext context,
      {required TextEditingController searchController,
      required FocusNode searchFocus,required Function onChange}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomTextField(
        textEditingController: searchController,
        focusNode: searchFocus,
        hintText: StringConstants.search,
        prefixIcon: const Icon(
          CupertinoIcons.search,
          size: 20,
          color: ColorConstants.hintColor,
        ),
        onChange: (value) async {
          onChange();
        },
        suffixIcon: GestureDetector(
          onTap: () {
            if (searchController.text.trim().isNotEmpty) {
              FocusScope.of(context).unfocus();
              searchController.clear();
              onChange();
            }
          },
          child: const Icon(
            Icons.cancel_outlined,
            color: ColorConstants.hintColor,
          ),
        ),
      ),
    );
  }

  static Widget getUserProfile({required String profileUrl}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.secondaryPrimaryColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            profileUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person);
            },
          ),
        ),
      ),
    );
  }

  static Widget getCenterLoading() {
    final size = MediaQuery.of(globalNavigationKey.currentState!.context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height / 2.7,
        ),
        const SpinKitThreeBounce(
          size: 40,
          color: ColorConstants.primaryColor,
        )
      ],
    );
  }

  static Widget noDataFound() {
    final size = MediaQuery.of(globalNavigationKey.currentState!.context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 2.5,
          ),
          Text(
            StringConstants.noProductFound,
            style: CustomTextStyle.getBoldText(
                textSize: 18, textColor: ColorConstants.primaryColor),
          ),
        ],
      ),
    );
  }

  static Widget welcomeText(bool isLogin) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: CustomTextStyle.getRegularText(
              textSize: 22, textColor: ColorConstants.blackColor),
          children: [
            TextSpan(
              text: (isLogin)
                  ? "${StringConstants.welcomeBack}, "
                  : "${StringConstants.helloThere}, ",
            ),
            TextSpan(
              text: (isLogin) ? StringConstants.login : StringConstants.signup,
              style: CustomTextStyle.getBoldText(
                      textSize: 22, textColor: ColorConstants.blackColor)
                  .copyWith(decoration: TextDecoration.underline),
            ),
            TextSpan(
              text: StringConstants.forContinue,
            ),
          ],
        ),
      ),
    );
  }

  static Widget pageText(bool isLogin) {
    return Text.rich(
      TextSpan(
        style: CustomTextStyle.getBoldText(
                textSize: 22, textColor: ColorConstants.primaryColor)
            .copyWith(letterSpacing: 2),
        children: [
          TextSpan(
            text: (isLogin)
                ? StringConstants.login.toUpperCase()
                : StringConstants.signup.toUpperCase(),
          ),
          TextSpan(
            text: StringConstants.page,
            style: CustomTextStyle.getBoldText(
                textSize: 22, textColor: ColorConstants.secondaryPrimaryColor),
          ),
        ],
      ),
    );
  }

  static void showLogoutDialog(BuildContext context,
      {required Function actionCallBack}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: Text(
            StringConstants.logout,
            style: CustomTextStyle.getBoldText(
                textColor: ColorConstants.primaryColor, textSize: 18),
          ),
          content: Text(
            StringConstants.areYouSureLogout,
            style: CustomTextStyle.getRegularText(
                textColor: ColorConstants.blackColor, textSize: 16),
          ),
          actions: <Widget>[
            CustomWidgets.getLoaderButton(context,
                buttonText: StringConstants.no,
                textColor: ColorConstants.primaryColor,
                buttonIcon: "", onClick: () {
              Navigator.of(context).pop();
              actionCallBack(false);
            }),
            SizedBox(
              height: 15.h,
            ),
            CustomWidgets.getLoaderButton(context,
                buttonText: StringConstants.yes,
                textColor: ColorConstants.whiteColor,
                buttonIcon: "",
                buttonColor: ColorConstants.primaryColor, onClick: () {
              Navigator.of(context).pop();
              actionCallBack(true);
            })
          ],
        );
      },
    );
  }
}
