// // notification_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   // Initialize Firebase Messaging and Local Notifications
//   Future<void> initializeNotifications() async {
//     // Initialize Firebase Messaging
//     await FirebaseMessaging.instance.requestPermission();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon'); // Replace with your app icon

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Handle foreground notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         flutterLocalNotificationsPlugin.show(
//           0,
//           message.notification!.title,
//           message.notification!.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               'cooldown_channel', // Channel ID
//               'Cooldown Notifications', // Channel Name
//               importance: Importance.max,
//               priority: Priority.high,
//             ),
//           ),
//         );
//       }
//     });

//     // Get FCM token (for sending notifications later)
//     String? token = await _firebaseMessaging.getToken();
//     print("FCM Token: $token");
//     // Store this token in Firestore for sending notifications later
//   }

//   // Show local notification
//   Future<void> showLocalNotification(String message) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'cooldown_channel',
//       'Cooldown Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       'Cooldown Over!',
//       message, // Custom message
//       notificationDetails,
//     );
//   }

//   // Send push notification using Firebase Cloud Messaging (FCM)
//   Future<void> sendPushNotification(String token, String message) async {
//     final payload = {
//       "notification": {
//         "title": "Cooldown Over!",
//         "body": message,
//       },
//       "priority": "high",
//       "to": token,
//     };

//     await http.post(
//       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=<your-server-key>',
//       },
//       body: json.encode(payload),
//     );
//   }
// }
