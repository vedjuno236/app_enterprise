import 'dart:async';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/poviders/location_provider/location_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/services/notification/localnotification.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:enterprise/views/screens/home/widgets/box_checkIn_widgets.dart';
import 'package:enterprise/views/screens/home/widgets/function_widget.dart';
import 'package:enterprise/views/screens/home/widgets/headerProfile_widget.dart';
import 'package:enterprise/views/screens/home/widgets/team_highligts_widget.dart';
import 'package:enterprise/views/widgets/loading_platform/shimmers_loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/helpers/shared_prefs.dart';
import '../../../components/poviders/bottom_bar_provider/bottom_bar_provider.dart';
import '../../../components/poviders/users_provider/users_provider.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/easy_date_time/infinite_item.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  LocalNotificationServiceUserApp localNotificationServiceUserApp =
      LocalNotificationServiceUserApp();
  Future redirectScreen({screenToNavigate}) async {
    debugPrint("modalRoute : $screenToNavigate");

    switch (screenToNavigate) {
      case 'attendance':
        Future.delayed(const Duration(milliseconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushNamed(PageName.navigatorBarScreenRoute,
                arguments: {"index": 0});
          }
        });

        break;
      case 'Leave':
        Future.delayed(const Duration(milliseconds: 2), () {
          if (mounted) {
            Navigator.of(context)
                .pushNamed(PageName.notificationRoute, arguments: {"index": 1});
          }
        });

        break;
      case 'SetAccountScreen':
        Future.delayed(const Duration(milliseconds: 2), () {
          // if (mounted) {
          //   Navigator.pushNamed(context, AppRoutes.bankAccountRoute);
          // }
        });
        break;
      case 'NormalScreen':
        Future.delayed(const Duration(milliseconds: 2), () {
          // if (mounted) {
          //   Navigator.of(context).pushNamed(AppRoutes.notificationV2Route,
          //       arguments: {"index": 2});
          // }
        });
        break;
      default:
        Future.delayed(const Duration(milliseconds: 2), () {
          // if (mounted) {
          //   Navigator.of(context).pushNamed(AppRoutes.notificationV2Route,
          //       arguments: {"index": 0});
          // }
        });
        break;
    }
  }

  Future<void> _configureCallbacks() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      // new
      if (message != null && message.data['screen']) {
        logger.d("Initial message screen: ${message.data['screen']}");
        redirectScreen(screenToNavigate: message.data['screen']);
      }
      // new
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null && !kIsWeb) {
          LocalNotificationServiceUserApp.display(message);
        }
        logger.d("foreground : ${notification!.title}");
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final int messageId = int.parse(message.data['messageId']);

      redirectScreen(screenToNavigate: message.data["screen"]);

      logger.d(message.data["screen"]);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.subscribeToTopic('attendance');
  }

  // Future<void> _configureCallbacks() async {
  // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
  //   if (message != null && message.data['screen']) {
  //     logger.d("Initial message screen: ${message.data['screen']}");
  //     redirectScreen(screenToNavigate: message.data['screen']);
  //   }
  // });

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null && !kIsWeb) {
  //     LocalNotificationServiceUserApp.display(message);
  //   }
  //   logger.d("Foreground notification - Title: ${notification?.title}, Screen: ${message.data['screen'] ?? 'No screen data'}");
  // });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     if (message.data.containsKey('screen')) {
//       final String screen = message.data['screen'];
//       final int? messageId = int.tryParse(message.data['messageId'] ?? '');

//       logger.d("Message opened app - Screen: $screen, Message ID: $messageId");
//       if (messageId != null) {
//         redirectScreen(screenToNavigate: screen);
//       } else {
//         logger.w("Invalid messageId in notification data: ${message.data['messageId']}");
//       }
//     } else {
//       logger.w("No screen data found in notification: ${message.data}");
//     }
//   });

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   await FirebaseMessaging.instance.subscribeToTopic('attendance');
//   logger.d("Subscribed to topic: attendance");
// }

  SharedPrefs sharedPrefs = SharedPrefs();
  bool isLoadinUser = false;
  bool isLoadinLocation = false;
  bool cancelled = false;
  bool showClockIn = false;
  Future fetchUserApi() async {
    setState(() {
      isLoadinUser = true;
    });
    EnterpriseAPIService()
        .callUserInfos(token: sharedPrefs.getStringNow(KeyShared.keyToken))
        .then((value) {
      ref.watch(stateUserProvider).setUserModel(value: value);
    }).catchError((onError) {
      errorDialog(
        context: context,
        onError: onError,
      );
    }).whenComplete(() => setState(() {
              isLoadinUser = false;
            }));
  }

  late int userID;
  bool isLoading = false;
  bool isClockIn = false;

  Future<void> _callLocationApi() async {
    setState(() {
      isLoadinLocation = true;
    });
    try {
      final value = await EnterpriseAPIService().callLocationAPI();
      ref.watch(stateLocationProvider).setLocationModels(value: value);
      final data = value['data'];
      final officeLat = data['office_lat'];
      final officeLong = data['office_long'];
      final radius = data['radius'];
      await sharedPrefs.setDoubleNow(KeyShared.keylat, officeLat.toDouble());
      await sharedPrefs.setDoubleNow(KeyShared.keylong, officeLong.toDouble());
      await sharedPrefs.setDoubleNow(KeyShared.keyradius, radius.toDouble());
    } catch (onError) {
      setState(() {
        isLoadinLocation = false;
      });
    }
  }

  Future<void> checkExpiredToken() async {
    EnterpriseAPIService()
        .callUserInfos(token: sharedPrefs.getStringNow(KeyShared.keyToken))
        .then((value) {
      ref.watch(stateUserProvider).setUserModel(value: value);
      if (value != null) {
        ref.read(stateUserProvider).setUserModel(value: value);
        ref.read(stateUserProvider).setAccessToken(value['Token'] ?? '');
      }
    }).catchError((onError) async {
      String errorMessage = DioExceptions.fromDioError(onError).toString();
      if (errorMessage == "Unauthorized") {
        Fluttertoast.showToast(
            msg: 'ເຂົ້າສູ່ລະບົບໃໝ່ອີກຄັ້ງ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kYellowColor,
            textColor: kBack87,
            fontSize: 16.0,
            fontAsset: 'NotoSansLao');
        // Timer(const Duration(microseconds: 1000), () {
        context.push(PageName.login);
        // });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _configureCallbacks();
    LocalNotificationServiceUserApp.initialize(context);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkExpiredToken();
      // checkToken();
    });
    fetchUserApi();
    _callLocationApi();
    // initializeRemoteConfig();
  }

  void initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate().timeout(Duration(seconds: 5));

    setState(() {
      showClockIn = remoteConfig.getBool('showClock') ?? false;
    });

    remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) async {
      await remoteConfig.activate();
      setState(() {
        showClockIn = remoteConfig.getBool('showClock') ?? false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(stateUserProvider);
    final roleName = userProvider.getUserModel?.data?.role?.name;
    final darkTheme = ref.watch(darkThemeProviderProvider);

    darkTheme.darkTheme
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: darkTheme.darkTheme
                    ? [Colors.black12, Colors.black26, Colors.black]
                    : kPrimaryGradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userProvider.getUserModel == null ||
                            userProvider.getUserModel!.data == null)
                          Shimmer.fromColors(
                            baseColor: kGreyColor1,
                            highlightColor: kGary,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: SizeConfig.heightMultiplier * 4,
                                        child: const ClipOval(),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width:
                                                SizeConfig.widthMultiplier * 20,
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 20),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: kTextWhiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Container(
                                            width:
                                                SizeConfig.widthMultiplier * 20,
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 20),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: kTextWhiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 2,
                                  ),
                                  CircleAvatar(
                                    radius: SizeConfig.heightMultiplier * 2,
                                    child: const ClipOval(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          HeaderProfile(
                            name: userProvider.getUserModel!.data!.firstName
                                .toString(),
                            lastName: userProvider.getUserModel!.data!.lastName
                                .toString(),
                            positionName: userProvider
                                .getUserModel!.data!.positionName
                                .toString(),
                            profile: userProvider.getUserModel!.data!.profile
                                .toString(),
                            sharedPrefs: sharedPrefs,
                          )
                              .animate()
                              .fadeIn(duration: 1000.ms, delay: 300.ms)
                              .move(
                                  begin: const Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                        const SizedBox(
                          height: 10,
                        ),
                        const DateTimeBuilderWidget()
                            .animate()
                            .fadeIn(duration: 1000.ms, delay: 300.ms)
                            .move(
                                begin: const Offset(-16, 0),
                                curve: Curves.easeOutQuad),
                        if (roleName != "CEO")
                          GestureDetector(
                              onTap: () {
                                ref
                                    .read(stateBottomBarProvider.notifier)
                                    .updateTabSelection(1, 'Analytic');
                              },
                              child: userProvider.getUserModel == null ||
                                      userProvider.getUserModel!.data == null
                                  ? containShimmer(ref)
                                  : BoxCheckWidgets(sharedPrefs: sharedPrefs))
                        else
                          const SizedBox.shrink(),
                        if (roleName == "CEO") ...[
                          Text(
                            Strings.txtTeam.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          SizedBox(
                            height: SizeConfig.widthMultiplier * 2,
                          ),
                          const TeamHighlightsWidget(),
                        ] else
                          const SizedBox.shrink(),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                        Text(
                          Strings.txtFunctions.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2),
                        ),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                        const FunctionWidget()
                            .animate()
                            .fadeIn(duration: 1000.ms, delay: 300.ms)
                            .move(
                                begin: const Offset(-16, 0),
                                curve: Curves.easeOutQuad),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                        // if (roleName != "EMPLOYEE") ...[
                        Text(
                          Strings.txtTeam.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2),
                        ),
                        SizedBox(
                          height: SizeConfig.widthMultiplier * 2,
                        ),
                      const   Padding(
                          padding:  EdgeInsets.only(bottom: 20),
                          child:  TeamHighlightsWidget(),
                        ),
                        // ] else
                        //   const SizedBox.shrink(),
                        // SizedBox(height: SizeConfig.heightMultiplier * 2),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       Strings.txtEvents.tr,
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .titleLarge!
                        //           .copyWith(
                        //               fontSize: SizeConfig.textMultiplier * 2),
                        //     ),
                        //     Row(
                        //       children: [
                        //         Text(
                        //           Strings.txtSeeAll.tr,
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .titleLarge!
                        //               .copyWith(
                        //                   fontSize:
                        //                       SizeConfig.textMultiplier * 2),
                        //         ),
                        //         const Icon(Icons.arrow_right)
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: SizeConfig.heightMultiplier * 2),
                        // const ComingEventsWidget(),
                        // SizedBox(height: SizeConfig.heightMultiplier * 2),
                        // if (roleName == "HR")
                        //   const HomeHrScreen()
                        // else
                        //   const SizedBox.shrink(),
                        // Sqlite(),
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
