// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_1/data/repository/chat_repo.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth_1/core/theme/dark_theme.dart';
import 'package:firebase_auth_1/core/theme/light_theme.dart';
import 'package:firebase_auth_1/core/utils/app_lifecycle_manager.dart';
import 'package:firebase_auth_1/data/repository/auth_repo.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/data/services/sharedPreferences_methods.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/splash_page.dart';
import 'package:firebase_auth_1/presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await SharedPreferencesMethods.init();
  AppLifecycleManager().initialize();

  final firebaseMethods = FirebaseMethods();
  final firestoreMethods = FirestoreMethods();
  final authRepo = AuthRepo(firebaseMethods, firestoreMethods);
  final chatRepo = ChatRepo(firestoreMethods: firestoreMethods);
  final userRepo = UserRepo(firestoreMethods: firestoreMethods);

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepo)),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        Provider(create: (_) => chatRepo),
        Provider(create: (_) => userRepo),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.select<SettingsProvider, bool>(
      (provider) => provider.dark,
    );

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
        home: SplashPage(),
      ),
    );
  }
}
