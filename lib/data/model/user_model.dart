// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final bool isOnline;
  final String fcmToken;
  final DateTime lastSeen;
  final DateTime createdAt;
  final String typingTo;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.isOnline,
    required this.fcmToken,
    required this.lastSeen,
    required this.createdAt,
    this.typingTo = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'fcmToken': fcmToken,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'typingTo': typingTo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
      isOnline: map['isOnline'],
      fcmToken: map['fcmToken'],
      lastSeen: (map['lastSeen'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      typingTo: map['typingTo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
