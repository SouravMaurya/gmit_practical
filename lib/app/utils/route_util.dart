import 'package:flutter/material.dart';
import 'package:gmit_practical/app/constants/routing_constants.dart';
import 'package:gmit_practical/components/screens/auth/login/login_screen.dart';
import 'package:gmit_practical/components/screens/auth/signup/signup_screen.dart';
import 'package:gmit_practical/components/screens/dashboard/home/home_screen.dart';
import 'package:gmit_practical/components/screens/splash/splash_screen.dart';

class RouteUtil {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map arguments = {};
    if (settings.arguments != null) {
      arguments.clear();
      arguments = settings.arguments as Map;
    }

    switch (settings.name) {
      case RoutingConstants.splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutingConstants.loginScreenRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RoutingConstants.signupScreenRoute:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case RoutingConstants.homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static visitLoginPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutingConstants.loginScreenRoute,
      (route) => false,
    );
  }

  static visitHomePage(BuildContext context,) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutingConstants.homeScreenRoute,
          (route) => false,
    );
  }

  static visitSignUpPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutingConstants.signupScreenRoute,
    );
  }
}
