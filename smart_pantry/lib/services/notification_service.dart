import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Track previous messages to avoid duplicate alerts
  Map<String, String> _lastNotifiedMessages = {};

  Future<void> init() async {
    // Local notification init
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
    _database.ref('notifications').onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null) {
        data.forEach((key, value) {
          final message = value.toString();

          if (_lastNotifiedMessages[key] != message) {
            _lastNotifiedMessages[key] = message;
            _showNotification(_formatTitle(key), message);
          }
        });
      }
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'restaurant_pantry_system_channel',
      'GrubGuard Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }

  String _formatTitle(String input) {
    return input.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
