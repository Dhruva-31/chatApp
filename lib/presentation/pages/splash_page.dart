// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/login_page.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/user_details_page.dart';
import 'package:firebase_auth_1/presentation/pages/navigation_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!authSnap.hasData) {
          return const LogInPage();
        }

        final uid = authSnap.data!.uid;
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (!userSnap.hasData || !userSnap.data!.exists) {
              return const LogInPage();
            }

            final data = userSnap.data!.data() as Map<String, dynamic>?;

            if (data == null) {
              return const LogInPage();
            }

            final name = data["name"] as String?;

            if (name == null || name.isEmpty) {
              return UserDetailsPage(myId: uid);
            }

            context.read<UserRepo>().updateUserOnLogin(userSnap.data!.id);
            return NavigationPage(myId: uid);
          },
        );
      },
    );
  }
}
