import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));

    // Android 13+ butuh izin notifikasi saat runtime
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Immediate Notification: langsung tampil saat dipanggil
  static Future<void> showDeleteNotification(String spellName) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'delete_channel',
        'Delete notification',
        channelDescription: 'Notifikasi saat spell favorite dihapus',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // id unik
      'Delete notification',
      'You deleted $spellName from your fav list!',
      details,
    );
  }
}
