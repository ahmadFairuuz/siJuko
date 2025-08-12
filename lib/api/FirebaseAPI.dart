import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        await _saveNotification(notification); // simpan di foreground
        showFlutterNotification(notification);
      }
    });
  }

  Future<void> initLocalNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(settings);
  }

  void showFlutterNotification(RemoteNotification notification) {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
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

  Future<void> _saveNotification(RemoteNotification notification) async {
    print("📩 Menyimpan notifikasi: ${notification.title}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stored = prefs.getString('notifications');
    List<Map<String, dynamic>> notifList = [];

    if (stored != null) {
      notifList = List<Map<String, dynamic>>.from(json.decode(stored));
    }

    notifList.insert(0, {
      'title': notification.title ?? 'Tanpa Judul',
      'body': notification.body ?? '',
      'time': DateTime.now().toString(),
    });

    // Batasi max 50 notifikasi
    if (notifList.length > 50) notifList = notifList.sublist(0, 50);

    prefs.setString('notifications', json.encode(notifList));
  }

  static Future<List<Map<String, dynamic>>> getStoredNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stored = prefs.getString('notifications');
    if (stored != null) {
      return List<Map<String, dynamic>>.from(json.decode(stored));
    }
    return [];
  }

  Future<void> saveNotificationFromBackground(
    RemoteNotification notification,
  ) async {
    await _saveNotification(notification);
  }
}
