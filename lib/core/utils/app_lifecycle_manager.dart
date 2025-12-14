import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:flutter/material.dart';

class AppLifecycleManager extends WidgetsBindingObserver {
  static final AppLifecycleManager _instance = AppLifecycleManager._internal();
  factory AppLifecycleManager() => _instance;
  AppLifecycleManager._internal();

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final uid = FirebaseMethods().currentUser?.uid;
    if (uid == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        FirestoreMethods().updateUserOnLogin(uid);
        break;

      case AppLifecycleState.paused:
        FirestoreMethods().updateUserOnSignOut(uid);
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.detached:
        FirestoreMethods().updateUserOnSignOut(uid);
        break;

      case AppLifecycleState.hidden:
        FirestoreMethods().updateUserOnSignOut(uid);
        break;
    }
  }
}
