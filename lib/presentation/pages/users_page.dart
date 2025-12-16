import 'package:firebase_auth_1/core/utils/user_options.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final _uid = FirebaseMethods().currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Users',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirestoreMethods().getUsers(_uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Users yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          final users = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: GestureDetector(
                    onTap: () async {
                      showUserOptions(context, user);
                    },
                    child: UserCardWidget(user: user),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
