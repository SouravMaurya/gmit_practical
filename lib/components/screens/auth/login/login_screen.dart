import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gmit_practical/app/constants/color_constant.dart';
import 'package:gmit_practical/app/constants/image_constants.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/constants/text_style_constants.dart';
import 'package:gmit_practical/app/utils/route_util.dart';
import 'package:gmit_practical/app/utils/strings_util.dart';
import 'package:gmit_practical/components/screens/auth/login/bloc/login_bloc.dart';
import 'package:gmit_practical/components/widgets/custom_text_field.dart';
import 'package:gmit_practical/components/widgets/custom_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginBloc loginBloc = LoginBloc();

  @override
  void initState() {
    loginBloc = context.read<LoginBloc>();
    loginBloc.add(PasswordSecureEvent(obSecureText: false));
    loginBloc.add(RememberMeEvent(checked: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorConstants.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomWidgets.showAuthTopView(context, isLogin: true),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _userNameTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _passwordTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _rememberForgetText(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _signInButton(size),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _buildNoAccountText(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _buildCreateButton(size),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userNameTextField() {
    return CustomTextField(
      textEditingController: userNameController,
      focusNode: userNameFocus,
      title: StringConstants.userName,
      isTitleField: true,
      isRequired: true,
      hintText:
          "${StringConstants.enter}${StringConstants.userName.toLowerCase()}",
      onEditComplete: () {
        FocusScope.of(context).requestFocus(passwordFocus);
      },
      validator: (value) {
        if (!StringUtils.isNullOrEmpty(value)) {
          return "${StringConstants.pleaseEnter}${StringConstants.userName.toLowerCase()}";
        }
        return null;
      },
      prefixIcon: const Icon(
        Icons.person_2_outlined,
        color: ColorConstants.hintColor,
      ),
    );
  }

  Widget _passwordTextField() {
    return BlocSelector<LoginBloc, LoginState, bool>(
      selector: (state) => state.obSecureText ?? false,
      builder: (context, obSecureText) {
        return CustomTextField(
          textEditingController: passwordController,
          focusNode: passwordFocus,
          title: StringConstants.password,
          isRequired: true,
          isTitleField: true,
          onSecureText: !obSecureText,
          hintText:
              "${StringConstants.enter}${StringConstants.password.toLowerCase()}",
          validator: (value) {
            if (!StringUtils.isNullOrEmpty(value)) {
              return "${StringConstants.pleaseEnter}${StringConstants.password.toLowerCase()}";
            }
            return null;
          },
          onEditComplete: () {
            FocusScope.of(context).unfocus();
            _validateUser();
          },
          prefixIcon: const Icon(
            Icons.lock_outlined,
            color: ColorConstants.hintColor,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              loginBloc.add(
                  PasswordSecureEvent(obSecureText: !(obSecureText ?? false)));
            },
            child: Icon(
              obSecureText ? Icons.visibility : Icons.visibility_off,
              color: ColorConstants.hintColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _rememberForgetText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 5.w,
        ),
        SizedBox(
          height: 15.h,
          width: 15.w,
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Checkbox(
                value: state.checked ?? false,
                onChanged: (value) {
                  loginBloc
                      .add(RememberMeEvent(checked: !(state.checked ?? false)));
                },
                activeColor: ColorConstants.primaryColor,
              );
            },
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                loginBloc
                    .add(RememberMeEvent(checked: !(state.checked ?? false)));
              },
              child: Text(
                StringConstants.rememberMe,
                style: CustomTextStyle.getRegularText(
                    textSize: 13,
                    textColor: ColorConstants.blackColor.withOpacity(0.6)),
              ),
            );
          },
        ),
        Expanded(
          child: Text(
            StringConstants.forgotPassword,
            style: CustomTextStyle.getRegularText(
                textSize: 14, textColor: ColorConstants.primaryColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _signInButton(Size size) {
    return BlocSelector<LoginBloc, LoginState, bool>(
      selector: (state) => state.loginLoading ?? false,
      builder: (context, loginLoading) {
        return CustomWidgets.getLoaderButton(context,
            buttonText: StringConstants.signIn,
            buttonColor: ColorConstants.primaryColor,
            isLoading: loginLoading,
            textColor: ColorConstants.whiteColor, onClick: () {
          _validateUser();
        });
      },
    );
  }

  Widget _buildNoAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Expanded(
          child: Divider(
            color: ColorConstants.hintColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            StringConstants.dontHaveAccount,
            textAlign: TextAlign.center,
            style: CustomTextStyle.getRegularText(
                textSize: 13,
                textColor: ColorConstants.blackColor.withOpacity(0.6)),
          ),
        ),
        const Expanded(
          child: Divider(
            color: ColorConstants.hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(Size size) {
    return CustomWidgets.getLoaderButton(context,
        buttonText: StringConstants.createAccount,
        textColor: ColorConstants.primaryColor, onClick: () {
      FocusScope.of(context).unfocus();
      RouteUtil.visitSignUpPage(context);
    });
  }

  Future<void> _validateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      Completer completer = Completer();
      loginBloc.add(UserLoginEvent(
          userName: userNameController.text.trim(),
          password: passwordController.text.trim(),
          completer: completer));
      await completer.future.then((value) {
        RouteUtil.visitHomePage(context,);
      },);
    }
  }
}
