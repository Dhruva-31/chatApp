import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_1/core/utils/app_lifecycle_manager.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/user_details_page.dart';
import 'package:firebase_auth_1/presentation/pages/initial_page.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppLifecycleManager().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthBloc())],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.blueGrey,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.blueGrey,
          ),
        ),

        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnap) {
            if (authSnap.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (!authSnap.hasData) {
              return LogInPage();
            }

            final uid = authSnap.data!.uid;

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, userSnap) {
                if (userSnap.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!userSnap.hasData || !userSnap.data!.exists) {
                  return LogInPage();
                }

                final data = userSnap.data!.data() as Map<String, dynamic>?;

                if (data == null) {
                  return LogInPage();
                }

                final name = data["name"] as String?;

                if (name == null || name.isEmpty) {
                  return UserDetailsPage();
                }
                final uid = FirebaseMethods().currentUser!.uid;
                FirestoreMethods().updateUserOnLogin(uid);
                return InitialPage();
              },
            );
          },
        ),
      ),
    );
  }
}
