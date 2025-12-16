// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_1/core/theme/dark_theme.dart';
import 'package:firebase_auth_1/core/theme/light_theme.dart';
import 'package:firebase_auth_1/core/utils/app_lifecycle_manager.dart';
import 'package:firebase_auth_1/data/services/sharedPreferences_methods.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/splash_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesMethods.init();
  AppLifecycleManager().initialize();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.watch<SettingsProvider>().dark;

    return AnimatedTheme(
      data: dark ? buildDarkTheme() : buildLightTheme(),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        home: const SplashPage(),
      ),
    );
  }
}
