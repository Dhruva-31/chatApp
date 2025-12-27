// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/core/utils/user_options.dart';
import 'package:firebase_auth_1/data/repository/user_repo.dart';
import 'package:firebase_auth_1/presentation/widgets/user_card_widget.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  final String myId;
  const UsersPage({super.key, required this.myId});

  @override
  Widget build(BuildContext context) {
    final UserRepo userRepo = context.read<UserRepo>();
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
        stream: userRepo.getUsers(myId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                    onTap: () {
                      showUserOptions(context, user, myId);
                    },
                    child: UserCardWidget(myId: user.uid, user: user),
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
