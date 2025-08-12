import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jukover7/screen/SplashScreen.dart' show SplashScreen;

import '../api/FirebaseAPI.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(); // penting untuk background
  final notification = message.notification;
  if (notification != null) {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();

  // ✅ HARUS dipanggil sebelum runApp
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }

  // Widget build(BuildContext context) => MaterialApp(
  //   title: 'Push Notif',
  //   theme: ThemeData(
  //     primarySwatch: Colors.blue,
  //     textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 40)),
  //   ),
  //   navigatorKey: navigatorKey,
  //   home: HomeScreen(),
  // );
}
