// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/repository/chat_repo.dart';
import 'package:firebase_auth_1/presentation/widgets/message_list_widget.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('MessageList widget test - ', () {
    testWidgets('when messages exists', (tester) async {
      final fakeChatRepo = FakeChatRepoWithMessages();

      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<ChatRepo>.value(value: fakeChatRepo)],
          child: const MaterialApp(
            home: MessageListWidget(roomId: '12', myId: '1', otherUserId: '2'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Hello'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byIcon(Icons.done_all), findsNothing);
    });

    testWidgets('when messages doesnt exists', (tester) async {
      final fakeChatRepo = FakeChatRepoWithNoMessages();

      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<ChatRepo>.value(value: fakeChatRepo)],
          child: const MaterialApp(
            home: MessageListWidget(roomId: '12', myId: '1', otherUserId: '2'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Hello'), findsNothing);
      expect(find.byType(ListView), findsNothing);
      expect(find.text('No messages yet'), findsOneWidget);
    });
  });
}

class FakeChatRepoWithMessages extends Mock implements ChatRepo {
  final fakeMessages = [
    MessageModel(
      messageId: '1',
      text: 'Hello',
      senderId: '2',
      isSeen: true,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Stream<List<MessageModel>> getMessages({
    required String roomId,
    required String uid,
  }) {
    return Stream.value(fakeMessages);
  }

  @override
  String formatMessageTime(DateTime date) => '10:00 AM';
}

class FakeChatRepoWithNoMessages extends Mock implements ChatRepo {
  @override
  Stream<List<MessageModel>> getMessages({
    required String roomId,
    required String uid,
  }) {
    return Stream.value([]);
  }

  @override
  String formatMessageTime(DateTime date) => '10:00 AM';
}
