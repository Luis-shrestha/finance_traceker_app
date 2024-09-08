import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager{
  static const String isWalkthroughShown = "isWalkthroughShown";

  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static setWalkthroughShown(bool status) async {
    (await prefs).setBool(isWalkthroughShown, status);
  }

  static getWalkthroughShown() async {
    return (await prefs).getBool(isWalkthroughShown) ?? false;
  }

}