import 'package:firebase_auth_1/data/model/message_model.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/widgets/message_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('message list widget test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MessageListWidget(
          firestoreMethods: FakeFirestoreMethods(),
          roomId: '12',
          myId: '1',
          otherUserId: '2',
        ),
      ),
    );

    //INTIAL
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    //FINAL
    expect(find.byType(Container), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsNothing);
  });
}

class FakeFirestoreMethods extends Fake implements FirestoreMethods {
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
}
