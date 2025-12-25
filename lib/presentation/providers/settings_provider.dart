import 'package:firebase_auth_1/data/services/sharedPreferences_methods.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _dark = false;
  int _pageIndex = 0;

  bool get dark => _dark;

  int get pageIndex => _pageIndex;

  SettingsProvider() {
    _dark = SharedPreferencesMethods.getBool('dark') ?? false;
  }

  Future<void> toggleDark(bool value) async {
    _dark = value;
    notifyListeners();
    await SharedPreferencesMethods.saveBool('dark', value);
  }

  void setPageIndex(int index) {
    if (_pageIndex == index) return;
    _pageIndex = index;
    notifyListeners();
  }
}
