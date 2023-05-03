import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/launcher_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );

    // end of initNotification function
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }

  // End of NotificationService class
}
