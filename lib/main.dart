import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/helpers/dark_mode_preference.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/languages/localization_service.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/styles/dark_theme_style.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// String? initialNotificationPayload;
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

//   if (message.notification != null) {
//     flutterLocalNotificationsPlugin.show(
//       message.notification!.hashCode,
//       message.notification!.title,
//       message.notification!.body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       payload: message.data['type'],
//     );
//   }
// }

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('Handling a background message ${message.messageId}');
  if (message.notification != null) {
    if (kDebugMode) {
      print(message.notification!.title);
    }
    if (kDebugMode) {
      print(message.notification!.body);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  ));

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await FirebaseMessaging.instance.subscribeToTopic('attendance');

  // // Initialize local notifications with iOS settings
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');
  // const DarwinInitializationSettings initializationSettingsIOS =
  //     DarwinInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  // );
  // const InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsIOS,
  // );
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse:
  //       (NotificationResponse notificationResponse) async {
  //     initialNotificationPayload = notificationResponse.payload;

  //     Future.delayed(const Duration(milliseconds: 100), () {
  //       router.goNamed(PageName.applyLeavesScreenRoute);
  //     });
  //   },
  // );

  // // Create notification channel
  // const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   'high_importance_channel',
  //   'High Importance Notifications',
  //   importance: Importance.high,
  //   playSound: true,
  //   sound: RawResourceAndroidNotificationSound('notification_sound'),
  //   enableVibration: true,
  // );
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           importance: Importance.high,
  //           priority: Priority.high,
  //           showWhen: true,
  //         ),
  //       ),
  //       payload: message.data['type'],
  //     );
  //   }
  // });

  AndroidNotificationChannel? channel;
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();

    FirebaseAnalytics.instance.logAppOpen();
  }

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  await FirebaseMessaging.instance.subscribeToTopic('attendance');

  await Firebase.initializeApp();
  FirebaseAnalytics.instance.logAppOpen();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  await SharedPrefs().init();

  final fcmToken = await FirebaseMessaging.instance.getToken();
  logger.d('FCM Token: $fcmToken');

  FirebaseAnalytics.instance.logAppOpen();
  await SharedPrefs().init();
  runApp(const ProviderScope(child: App()));

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  DarkThemePreference darkThemePreference = DarkThemePreference();

  // void initState() {
  //   super.initState();
  //   getCurrentAppTheme();
  //   getSavedLocale();
  //   // getToken();
  // }
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSavedLocale();
    });
    // getToken();
  }

  void getCurrentAppTheme() async {
    final themeChangeProvider = ref.read(darkThemeProviderProvider);
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  Future<void> getSavedLocale() async {
    final locale = await LocalizationService.getSaveLocal();
    if (locale != null) {
      Get.updateLocale(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChangeProvider = ref.watch(darkThemeProviderProvider);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);

            return GetMaterialApp.router(
              fallbackLocale: LocalizationService.fallbackLocale,
              locale: LocalizationService.locale,
              supportedLocales: LocalizationService.locales,
              translations: LocalizationService(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              title: " ${Strings.txtAppName.tr} ",
              debugShowCheckedModeBanner: false,
              theme: AppTheme.themeData(themeChangeProvider.darkTheme, context),
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              routeInformationProvider: router.routeInformationProvider,
            );
          },
        );
      },
    );
  }
}
