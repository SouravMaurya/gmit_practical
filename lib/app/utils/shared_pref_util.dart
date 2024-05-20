import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  factory SharedPrefUtil() {
    return _singleton;
  }

  SharedPrefUtil._internal();

  static final SharedPrefUtil _singleton = SharedPrefUtil._internal();

  SharedPreferences? _storagePrefs;

  Future initializeSharedPreference() async {
    await SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      _storagePrefs = prefs;
    });
  }

  static String keyIsLoggedIn = "keyIsLoggedIn";
  static String keyUserToken = "keyUserToken";
  static String keyUserRemember = "keyUserRemember";
  static String keyUserProfile = "keyUserProfile";
  static String keyUserName = "keyUserName";

  String getString(String key) {
    return _storagePrefs?.getString(key) ?? "";
  }

  bool getBool(String key) {
    return _storagePrefs?.getBool(key) ?? false;
  }

  int getInt(String key) {
    return _storagePrefs?.getInt(key) ?? -1;
  }

  double getDouble(String key) {
    return _storagePrefs?.getDouble(key) ?? -1;
  }

  Future saveString(String key, String value) async {
    await _storagePrefs?.setString(key, value);
  }

  Future saveBool(String key, bool value) async {
    await _storagePrefs?.setBool(key, value);
  }

  Future saveInt(String key, int value) async {
    await _storagePrefs?.setInt(key, value);
  }

  Future saveDouble(String key, double value) async {
    await _storagePrefs?.setDouble(key, value);
  }

  Future clearPreference() async {
    await _storagePrefs?.clear();
  }
}
