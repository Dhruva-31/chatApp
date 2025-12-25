// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/chat_page.dart';
import 'package:firebase_auth_1/presentation/widgets/user_card_widget.dart';

class HomePage extends StatelessWidget {
  final FirestoreMethods firestoreMethods;
  final String myId;
  const HomePage({
    super.key,
    required this.firestoreMethods,
    required this.myId,
  });

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
        stream: firestoreMethods.getChatRooms(myId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                final secondUserId = (myId == chatRoom.participants[0])
                    ? chatRoom.participants[1]
                    : chatRoom.participants[0];
                return StreamBuilder(
                  stream: firestoreMethods.getUserDetail(secondUserId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final toUserData = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  secondUser: toUserData,
                                  myId: myId,
                                  firestoreMethods: firestoreMethods,
                                ),
                              ),
                            );
                          },
                          child: UserCardWidget(
                            myId: myId,
                            user: toUserData!,
                            chatroom: chatRoom,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
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
