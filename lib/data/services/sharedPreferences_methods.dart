import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMethods {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ====== SAVE ======

  static Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // ====== GET (SYNC) ======

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // ====== REMOVE ======

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
