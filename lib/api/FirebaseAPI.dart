import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

import '../data_model/NotificationModel.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    await initLocalNotification();

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification != null) {
        await saveNotification(notification); // simpan di foreground
        showFlutterNotification(notification);
      }
    });
  }

  Future<void> initLocalNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(settings);
  }

  void showFlutterNotification(RemoteNotification notification) {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // harus sama dengan di Manifest
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    _localNotifications.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }

  static Future<void> saveNotification(RemoteNotification notification) async {
    print("📩 Menyimpan notifikasi: ${notification.title}");

    final box = await Hive.openBox<NotificationModel>('notifications');

    box.add(
      NotificationModel(
        title: notification.title ?? 'Tanpa Judul',
        body: notification.body ?? '',
        timestamp: DateTime.now(),
      ),
    );
  }

  // ✅ Ambil notifikasi dari Hive
  static Future<List<NotificationModel>> getStoredNotifications() async {
    final box = await Hive.openBox<NotificationModel>('notifications');
    return box.values.toList().reversed.toList();
  }

  // ✅ Simpan dari background juga ke Hive
  Future<void> saveNotificationFromBackground(
    RemoteNotification notification,
  ) async {
    await saveNotification(notification);
  }
}
