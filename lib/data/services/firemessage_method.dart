// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_auth_1/data/services/firestore_methods.dart';

// // This key lets us navigate from anywhere (even when app is killed)
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Background handler (MUST be top-level function)
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Background notification received: ${message.messageId}");
// }

// class FiremessageMethod {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   // Local notifications plugin
//   static final FlutterLocalNotificationsPlugin localNotifications =
//       FlutterLocalNotificationsPlugin();

//   // Notification channel (Android 8+ requirement)
//   static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'chat_messages_channel',
//     'Chat Messages',
//     description: 'Notifications for new chat messages',
//     importance: Importance.high,
//     playSound: true,
//   );

//   Future<void> initNotifications() async {
//     // 1. Request permission
//     await _messaging.requestPermission(alert: true, badge: true, sound: true);

//     // 2. Get and save FCM token
//     String? token = await _messaging.getToken();
//     if (token != null) {
//       await FirestoreMethods().updateUserFcmToken(token);
//       print("FCM Token saved: $token");
//     }

//     // 3. Update token if it changes later
//     _messaging.onTokenRefresh.listen((newToken) {
//       FirestoreMethods().updateUserFcmToken(newToken);
//     });

//     // 4. Setup local notifications (for foreground)
//     await _setupLocalNotifications();

//     // 5. Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });

//     // 6. When user taps notification (app in background)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _navigateToChat(message);
//     });

//     // 7. When app is opened from killed state via notification
//     RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _navigateToChat(initialMessage);
//     }

//     // 8. Set background handler
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   }

//   Future<void> _setupLocalNotifications() async {
//     // Android settings
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // iOS settings
//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings();

//     // Initialize
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload != null && details.payload!.isNotEmpty) {
//           final data = <String, dynamic>{'chatId': details.payload};
//           _navigateToChat(RemoteMessage(data: data));
//         }
//       },
//     );

//     // Create Android channel
//     await localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }

//   void _showNotification(RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     if (notification == null) return;

//     localNotifications.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           importance: Importance.high,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//         ),
//         iOS: const DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       payload: message.data['chatId'] ?? message.data['senderId'],
//     );
//   }

//   void _navigateToChat(RemoteMessage message) {
//     final String? chatId = message.data['chatId'] ?? message.data['senderId'];
//     final senderId = message.data['senderId'];

//     if (chatId == null || senderId == null) return;

//     final senderData = FirestoreMethods().getUserDetail(senderId);

//     // This will work even if app was completely killed
//     Future.delayed(const Duration(milliseconds: 500), () {
//       navigatorKey.currentState?.pushNamed(
//         '/chat',
//         arguments: {'chatId': chatId, 'senderData': senderData},
//       );
//     });
//   }
// }
