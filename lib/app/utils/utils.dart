import 'package:fluttertoast/fluttertoast.dart';

class Utils {

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
    );
  }
}