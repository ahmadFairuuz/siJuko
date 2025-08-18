import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jukover7/screen/SplashScreen.dart' show SplashScreen;

import '../api/FirebaseAPI.dart';
import 'data_model/NotificationModel.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(NotificationModelAdapter());
  }
  final box = await Hive.openBox<NotificationModel>('notifications');

  box.add(
    NotificationModel(
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      timestamp: DateTime.now(),
    ),
  );

  print("✅ Notifikasi tersimpan (background): ${message.notification?.title}");
}

// @pragma('vm:entry-point')
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   await Firebase.initializeApp(); // penting untuk background
//   print("📩 Background FCM: ${message.notification?.title}");
//   final notification = message.notification;
//   if (notification != null) {
//     print('Title: ${message.notification?.title}');
//     print('Body: ${message.notification?.body}');
//     print('Payload: ${message.data}');
//     await FirebaseApi.saveNotification(notification);
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Firebase
  await Firebase.initializeApp();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(NotificationModelAdapter());
  }
  await Hive.openBox<NotificationModel>('notifications');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await Firebase.initializeApp();
  // // ✅ HARUS dipanggil sebelum runApp
  // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  await FirebaseApi().initNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Listener untuk notifikasi foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final box = Hive.box<NotificationModel>('notifications');

      box.add(
        NotificationModel(
          title: message.notification?.title ?? "No Title",
          body: message.notification?.body ?? "No Body",
          timestamp: DateTime.now(),
        ),
      );

      print(
        "✅ Notifikasi tersimpan (foreground): ${message.notification?.title}",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Si Juko',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
