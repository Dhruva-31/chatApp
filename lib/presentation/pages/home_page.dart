import 'package:firebase_auth_1/data/repository/firestore_repo.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/chat_page.dart';
import 'package:firebase_auth_1/presentation/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _firestoreRepo = FirestoreRepo();
  final _uid = FirebaseMethods().currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Chats',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _firestoreRepo.chatRoomsData(_uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No chats yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          final chatRooms = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatRooms[index];
                final secondUserId = _uid == chatRoom.participants[0]
                    ? chatRoom.participants[1]
                    : chatRoom.participants[0];
                return StreamBuilder(
                  stream: FirestoreMethods().getUserDetail(secondUserId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Card(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final toUserData = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(secondUser: toUserData),
                            ),
                          );
                        },
                        child: UserCardWidget(
                          user: toUserData!,
                          chatroom: chatRoom,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
