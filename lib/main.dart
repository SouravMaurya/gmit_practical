import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gmit_practical/app/constants/app_constants.dart';
import 'package:gmit_practical/app/constants/routing_constants.dart';
import 'package:gmit_practical/app/utils/route_util.dart';
import 'package:gmit_practical/app/utils/shared_pref_util.dart';
import 'package:gmit_practical/components/screens/auth/login/bloc/login_bloc.dart';
import 'package:gmit_practical/components/screens/auth/signup/bloc/signup_bloc.dart';
import 'package:gmit_practical/components/screens/dashboard/home/bloc/home_bloc.dart';

GlobalKey<NavigatorState> globalNavigationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SharedPrefUtil().initializeSharedPreference();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => SignupBloc(),
          ),
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appName,
          navigatorKey: globalNavigationKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteUtil.generateRoute,
          initialRoute: RoutingConstants.splashScreenRoute,
          themeMode: ThemeMode.light,
        ),
      );
    });
  }
}
