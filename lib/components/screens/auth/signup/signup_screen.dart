import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gmit_practical/app/constants/color_constant.dart';
import 'package:gmit_practical/app/constants/string_constants.dart';
import 'package:gmit_practical/app/constants/text_style_constants.dart';
import 'package:gmit_practical/app/utils/route_util.dart';
import 'package:gmit_practical/app/utils/strings_util.dart';
import 'package:gmit_practical/components/screens/auth/signup/bloc/signup_bloc.dart';
import 'package:gmit_practical/components/widgets/custom_text_field.dart';
import 'package:gmit_practical/components/widgets/custom_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userFirstNameController = TextEditingController();
  TextEditingController userLastNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userContactController = TextEditingController();
  TextEditingController userAgeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  FocusNode userFirstNameFocus = FocusNode();
  FocusNode userLastNameFocus = FocusNode();
  FocusNode userEmailFocus = FocusNode();
  FocusNode userContactFocus = FocusNode();
  FocusNode userAgeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupBloc signupBloc = SignupBloc();

  @override
  void initState() {
    signupBloc = context.read<SignupBloc>();
    signupBloc.add(PasswordSecureEvent(obSecureText: false));
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
                  CustomWidgets.showAuthTopView(context, isLogin: false),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _userNameTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _userFirstNameTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _userLastNameTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _userEmailTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _userPhoneTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _userAgeTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _passwordTextField(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _signUpButton(size),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _buildAccountText(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _buildSigninButton(size),
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
        FocusScope.of(context).requestFocus(userFirstNameFocus);
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

  Widget _userFirstNameTextField() {
    return CustomTextField(
      textEditingController: userFirstNameController,
      focusNode: userFirstNameFocus,
      title: StringConstants.firstName,
      isTitleField: true,
      isRequired: true,
      hintText:
          "${StringConstants.enter}${StringConstants.firstName.toLowerCase()}",
      onEditComplete: () {
        FocusScope.of(context).requestFocus(userLastNameFocus);
      },
      validator: (value) {
        if (!StringUtils.isNullOrEmpty(value)) {
          return "${StringConstants.pleaseEnter}${StringConstants.firstName.toLowerCase()}";
        }
        return null;
      },
      prefixIcon: const Icon(
        Icons.person,
        color: ColorConstants.hintColor,
      ),
    );
  }

  Widget _userLastNameTextField() {
    return CustomTextField(
      textEditingController: userLastNameController,
      focusNode: userLastNameFocus,
      title: StringConstants.lastName,
      isTitleField: true,
      isRequired: false,
      hintText:
          "${StringConstants.enter}${StringConstants.lastName.toLowerCase()}",
      onEditComplete: () {
        FocusScope.of(context).requestFocus(userEmailFocus);
      },
      validator: (value) {
        return null;
      },
      prefixIcon: const Icon(
        Icons.person_2_rounded,
        color: ColorConstants.hintColor,
      ),
    );
  }

  Widget _userEmailTextField() {
    return CustomTextField(
      textEditingController: userEmailController,
      focusNode: userEmailFocus,
      title: StringConstants.email,
      textInputType: TextInputType.emailAddress,
      isTitleField: true,
      isRequired: true,
      hintText:
          "${StringConstants.enter}${StringConstants.email.toLowerCase()}",
      onEditComplete: () {
        FocusScope.of(context).requestFocus(userContactFocus);
      },
      validator: (value) {
        if (!StringUtils.isNullOrEmpty(value)) {
          return "${StringConstants.pleaseEnter}${StringConstants.email.toLowerCase()}";
        } else if (!StringUtils.isValidEmail(value ?? "")) {
          return "${StringConstants.pleaseEnterValid}${StringConstants.email.toLowerCase()}";
        }
        return null;
      },
      prefixIcon: const Icon(
        Icons.email_outlined,
        color: ColorConstants.hintColor,
      ),
    );
  }

  Widget _userPhoneTextField() {
    return CustomTextField(
      textEditingController: userContactController,
      focusNode: userContactFocus,
      title: StringConstants.phoneNumber,
      textInputType: TextInputType.number,
      isTitleField: true,
      isRequired: true,
      maxLength: 10,
      inputFormats: [FilteringTextInputFormatter.digitsOnly],
      hintText:
          "${StringConstants.enter}${StringConstants.phoneNumber.toLowerCase()}",
      onEditComplete: () {
        FocusScope.of(context).requestFocus(userAgeFocus);
      },
      validator: (value) {
        if (!StringUtils.isNullOrEmpty(value)) {
          return "${StringConstants.pleaseEnter}${StringConstants.phoneNumber.toLowerCase()}";
        } else if (!StringUtils.isValidMobileNumber(value ?? "")) {
          return "${StringConstants.pleaseEnterValid}${StringConstants.phoneNumber.toLowerCase()}";
        }
        return null;
      },
      prefixIcon: const Icon(
        Icons.phone,
        color: ColorConstants.hintColor,
      ),
    );
  }

  Widget _userAgeTextField() {
    return CustomTextField(
      textEditingController: userAgeController,
      focusNode: userAgeFocus,
      title: StringConstants.age,
      textInputType: TextInputType.number,
      isTitleField: true,
      isRequired: true,
      inputFormats: [FilteringTextInputFormatter.digitsOnly],
      hintText: "${StringConstants.enter}${StringConstants.age.toLowerCase()}",
      onEditComplete: () {
        FocusScope.of(context).requestFocus(passwordFocus);
      },
      validator: (value) {
        if (!StringUtils.isNullOrEmpty(value)) {
          return "${StringConstants.pleaseEnter}${StringConstants.age.toLowerCase()}";
        }
        return null;
      },
      maxLength: 2,
      prefixIcon: const Icon(
        Icons.view_agenda_outlined,
        color: ColorConstants.hintColor,
      ),
    );
  }

  Widget _passwordTextField() {
    return BlocSelector<SignupBloc, SignupState, bool>(
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
              signupBloc.add(PasswordSecureEvent(obSecureText: !obSecureText));
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

  Widget _signUpButton(Size size) {
    return BlocSelector<SignupBloc, SignupState, bool>(
      selector: (state) => state.signupLoading ?? false,
      builder: (context, signupLoading) {
        return CustomWidgets.getLoaderButton(context,
            buttonText: StringConstants.signIn,
            buttonColor: ColorConstants.primaryColor,
            isLoading: signupLoading,
            textColor: ColorConstants.whiteColor, onClick: () {
          _validateUser();
        });
      },
    );
  }

  Widget _buildAccountText() {
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
            StringConstants.haveAccount,
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

  Widget _buildSigninButton(Size size) {
    return CustomWidgets.getLoaderButton(context,
        buttonText: StringConstants.login,
        textColor: ColorConstants.primaryColor, onClick: () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    });
  }

  Future<void> _validateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      Completer completer = Completer();
      signupBloc.add(UserSignupEvent(
          userName: userNameController.text.trim(),
          firstName: userFirstNameController.text.trim(),
          lastName: userLastNameController.text.trim(),
          userAge: userAgeController.text.trim(),
          userContact: userContactController.text.trim(),
          userEmail: userEmailController.text.trim(),
          userPassword: passwordController.text.trim(),
          completer: completer));
      await completer.future;
      RouteUtil.visitHomePage(context);
    }
  }
}
