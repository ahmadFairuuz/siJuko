import 'package:hive/hive.dart';

part 'NotificationModel.g.dart';

@HiveType(typeId: 0) // wajib, setiap model harus punya typeId unik
class NotificationModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String body;

  @HiveField(2)
  DateTime timestamp;

  NotificationModel({
    required this.title,
    required this.body,
    required this.timestamp,
  });
}
