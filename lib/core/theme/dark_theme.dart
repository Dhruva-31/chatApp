import 'package:firebase_auth_1/core/theme/base_theme.dart';
import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  final base = buildBaseTheme();

  return base.copyWith(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 62, 61, 61),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: const Color.fromARGB(255, 62, 61, 61),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.blueGrey,
      unselectedItemColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 62, 61, 61),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: base.elevatedButtonTheme.style!.copyWith(
        backgroundColor: WidgetStatePropertyAll(Colors.black),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? Colors.blueGrey
            : Colors.black;
      }),
      trackColor: const WidgetStatePropertyAll(Colors.white),
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: const Color.fromARGB(255, 62, 61, 61),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color.fromARGB(255, 62, 61, 61),
    ),
  );
}
