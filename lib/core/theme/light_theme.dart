import 'package:firebase_auth_1/core/theme/base_theme.dart';
import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final base = buildBaseTheme();

  return base.copyWith(
    scaffoldBackgroundColor: Colors.blueGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueGrey,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: const Color.fromARGB(255, 111, 142, 156),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromARGB(229, 255, 255, 255),
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.blueGrey,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: base.elevatedButtonTheme.style!.copyWith(
        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey),
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
            ? Colors.black
            : Colors.blueGrey;
      }),
      trackColor: const WidgetStatePropertyAll(Colors.white),
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
    ),
  );
}
