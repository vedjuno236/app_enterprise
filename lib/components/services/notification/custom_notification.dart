import 'package:enterprise/components/router/router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications(GoRouter router) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap or button click
      if (response.payload == 'navigate_to_new_screen') {
        // router.go(PageName.newsRoute); // Use GoRouter to navigate
      }
    },
  );
}

void showCustomNotification() async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(''),
    category: AndroidNotificationCategory.alarm,
    visibility: NotificationVisibility.public,
    actions: [
      AndroidNotificationAction(
        'action_id',
        'Navigate',
        showsUserInterface: true,
      ),
    ],
  );

  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Custom Notification',
    'This is a custom notification with a button',
    platformChannelSpecifics,
    payload: 'navigate_to_new_screen', // Payload to trigger navigation
  );
}
