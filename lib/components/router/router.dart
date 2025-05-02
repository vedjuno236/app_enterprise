import 'dart:ffi';

import 'package:enterprise/components/constants/googel.dart';
import 'package:enterprise/components/models/analytic_model/leave_type_model.dart';
import 'package:enterprise/views/screens/analytic/leave_history_screens.dart';
import 'package:enterprise/views/screens/on_leaves/on_lave_screen.dart';
import 'package:enterprise/views/screens/requestOT/requestOT_screens.dart';
import 'package:enterprise/views/screens/requestOT/request_ot_history.dart';
import 'package:enterprise/splash_screen.dart';
import 'package:enterprise/views/screens/%E0%BA%B3events_screens/all_event_screens.dart';
import 'package:enterprise/views/screens/%E0%BA%B3events_screens/events_screens.dart';
import 'package:enterprise/views/screens/analytic/AMLS_leave_screens.dart';
import 'package:enterprise/views/screens/analytic/attendance_history.dart';
import 'package:enterprise/views/screens/analytic/all_leave_screen.dart';
import 'package:enterprise/views/screens/home/home_HR/home_hr_screen.dart';
import 'package:enterprise/views/screens/home/home_screen.dart';
import 'package:enterprise/views/screens/home/widgets/attendance_Success.dart';
import 'package:enterprise/views/screens/leave/edit_leave_screen.dart';
// import 'package:enterprise/views/screens/analytic/all_leave_history_screens.dart';
import 'package:enterprise/views/screens/market_place/market_place_screen.dart';
import 'package:enterprise/views/screens/market_place/my_post.dart';
import 'package:enterprise/views/screens/notifications/notifitions_screens.dart';
import 'package:enterprise/views/screens/pay_slips/deductions_screen.dart';
import 'package:enterprise/views/screens/pay_slips/gross_income_screen.dart';
import 'package:enterprise/views/screens/pay_slips/pay_slips_screen.dart';
import 'package:enterprise/views/screens/profile_screen/editProfile_screen.dart';
import 'package:enterprise/views/screens/profile_screen/profile_screen.dart';
import 'package:enterprise/views/screens/profile_screen/ranking_screen.dart';
import 'package:enterprise/views/widgets/background/main_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../views/screens/auth/login_screen.dart';
import '../../views/screens/calendar/calendar_screen.dart';
import '../../views/screens/home/attendance_screen.dart';
import '../../views/screens/information/information_screen.dart';
import '../../views/screens/information/old_widget/structure_screen.dart';
import '../../views/screens/leave/leave_screens.dart';
import '../../views/screens/policies/policies_pdf_screen.dart';
import '../../views/screens/policies/policies_screens.dart';
import '../../views/screens/request/request_screen.dart';
import '../../views/screens/ຳevents_screens/events_details_Screen.dart';
import '../../views/widgets/bottom_navigation_bar_widget/bottom_navigation_screens.dart';

abstract class PageName {
  static const String splashRoute = '/';
  static const String homeScreenRoute = '/home_screen';
  static const String navigatorBarScreenRoute = '/navigator_bar_screen';
  static const String settingRoute = '/setting_screen';
  static const String navigationRoute = '/navigation_screen';
  static const String landingViewRoute = '/landing_view';
  static const String signInRoute = '/sign_in_screen';
  static const String signUpRoute = '/sign_up_screen';
  static const String login = '/create_account_screen';
  static const String startFaceId = '/start_faceid_screen';
  static const String faceIdSuccess = '/faceid_success_screen';
  static const String faceScan = '/face_scan_screen';
  static const String bgScreen = '/bgScreen';
  static const String marketPlace = '/market_place';
  static const String myPost = '/myPost';
  static const String paySlips = '/paySlip_screen';
  static const String grossIncome = '/gross_income_screen';
  static const String deductions = '/deductions_screen';
  static const String policiesScreensRoute = '/policies_screens';

  static const String informationScreenRoute = '/information_screen';
  static const String structureScreenRoute = '/structure_screen';
  static const String policiesPdfScreenRoute = '/policiesPdf_screen';

  static const String attendanceHistoryRoute = '/attendance_history';
  static const String calendarScreenRoute = '/calendar_screen';
  static const String all_leave_screens = '/all_leave_screens';
  static const String applyLeavesScreenRoute = '/apply_leaves_screen';
  static const String leaveHistoryScreen = '/leaves_history_screen';
  static const String annualLeavesFormScreenRoute =
      '/apply_leaves_form_screen/:keyword';
  static const String editLeaveScreenRoute = '/EditLeaveScreen';
  static const String notificationRoute = '/notification_screen';
  static const String profileRoute = '/profile_screen';
  static const String editProfileRoute = '/editProfile_screen';
  static const String rankingRoute = '/ranking_screen';
  static const String onLeaveRoute = '/OnLeave_screen';
  static const String historyRemainRoute = '/history_remaining_screen';

  static const String newsDetailsScreen = '/newsDetails_screen';
  static const String requestOtScreen = '/requestOt_screen';
  static const String requestOtHistoryScreen = '/requestOtHistory_screen';

  ////
  static const String requestScreen = '/request_screen';
  static const String reportScreen = '/report_screen';

  /// event
  static const String eventsAllScreens = '/events_all_screens';
  static const String eventsScreens = '/events_screens';
  static const String eventDetailScreen = '/event_detail_screens';

  static const String attendanceScreens = '/attendance_screens';

  static const String attendanceSuccess = '/attendance_success_screens';
  static const String AmlsLeaveScreens = '/AmlsLeave_screens';

  // RequestScreen
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GoRouter router = GoRouter(
  initialLocation: PageName.splashRoute,
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: PageName.splashRoute,
      builder: (context, state) => const SplashScreen(),
      // routes: ,
    ),
    GoRoute(
      path: PageName.eventDetailScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: EventDetailScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: PageName.navigatorBarScreenRoute,
      builder: (context, state) => const HomeScreenPage(),
      // routes: ,
    ),
    GoRoute(
      path: PageName.login,
      builder: (conext, state) => const LoginScreen(),
    ),
    GoRoute(
      path: PageName.requestOtScreen,
      builder: (context, state) => const RequestOtScreens(),
    ),
    GoRoute(
      path: PageName.requestOtHistoryScreen,
      builder: (context, state) => const RequestOtHistory(),
    ),
    GoRoute(
      path: PageName.onLeaveRoute,
      name: PageName.onLeaveRoute,
      builder: (context, state) => const OnLeaveScreen(),
    ),
    GoRoute(
      path: PageName.homeScreenRoute,
      builder: (context, state) => const HomeScreen(
        key: Key(PageName.homeScreenRoute),
      ),
    ),
    GoRoute(
      path: PageName.calendarScreenRoute,
      builder: (context, state) => CalendarScreen(),
      // routes: ,
    ),
    GoRoute(
      path: PageName.profileRoute,
      builder: (context, state) => const ProfileScreen(
        key: Key(PageName.profileRoute),
      ),
    ),
    GoRoute(
      path: PageName.eventsScreens,
      builder: (context, state) => const EventsScreens(),
    ),
    GoRoute(
      path: PageName.eventsAllScreens,
      builder: (context, state) => const AllEventScreens(),
    ),
    GoRoute(
      path: PageName.AmlsLeaveScreens,
      pageBuilder: (context, state) {
        final data = state.extra as Data;
        return MaterialPage(
          child: AmlsLeaveScreens(data: data),
        );
      },
    ),
    GoRoute(
      path: PageName.attendanceSuccess,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final clockInTime = extra?['clockInTime'] as String? ?? '';
        final typeClock = extra?['typeClock'] as String? ?? '';
        final isLate = extra?['isLate'] as bool? ?? false;
        return AttendanceSuccess(
          clockInTime: clockInTime,
          typeClock: typeClock,
          isLate: isLate,
        );
      },
    ),

    GoRoute(
      path: PageName.editProfileRoute,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: PageName.editLeaveScreenRoute,
      builder: (context, state) => const EditLeaveScreen(),
    ),
    GoRoute(
      path: PageName.bgScreen,
      builder: (context, state) => const backGroundScreen(),
    ),
    GoRoute(
      path: PageName.marketPlace,
      builder: (context, state) => const MarketPlaceScreen(),
    ),
    GoRoute(
      path: PageName.myPost,
      builder: (context, state) => const MyPostScaeens(),
    ),
    GoRoute(
      path: PageName.paySlips,
      builder: (context, state) => const PaySlipsScreen(),
    ),
    GoRoute(
      path: PageName.deductions,
      builder: (context, state) => DeductionsScreen(),
    ),
    GoRoute(
      path: PageName.grossIncome,
      builder: (context, state) => GrossIncomeScreen(),
    ),
    GoRoute(
        path: PageName.reportScreen,
        builder: (context, state) => const HomeHrScreen()),
    GoRoute(
        path: PageName.applyLeavesScreenRoute,
        builder: (context, state) => const LeaveScreens()),
    GoRoute(
        path: PageName.leaveHistoryScreen,
        builder: (context, state) => const LeaveHistoryScreen()),
    GoRoute(
      path: PageName.all_leave_screens,
      builder: (context, state) => const AllLeaveScreen(),
    ),
    GoRoute(
        path: PageName.policiesScreensRoute,
        builder: (context, state) => const PoliciesScreens()),
    GoRoute(
        path: PageName.attendanceScreens,
        builder: (context, state) => const AttendanceScreen()),
    GoRoute(
        path: PageName.attendanceHistoryRoute,
        builder: (context, state) {
          final DateTime selectedMonth = state.extra as DateTime;
          return AttendanceHistory(selectedMonth: selectedMonth);
        }),
    GoRoute(
        path: PageName.informationScreenRoute,
        builder: (context, state) => const InformationScreen()),
    GoRoute(
        path: PageName.requestScreen,
        builder: (context, state) => const RequestScreen()),
    GoRoute(
      path: PageName.rankingRoute,
      builder: (context, state) => const RankingScreen(
        key: Key(PageName.rankingRoute),
      ),
    ),
    GoRoute(
      path: PageName.structureScreenRoute,
      builder: (context, state) {
        final information = state.extra as Map<String, dynamic>;
        return StructureScreen(information: information);
      },
    ),
    GoRoute(
      path: PageName.policiesPdfScreenRoute,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        final typeID = params?['typeId'] as int?;
        final typeName = params?['typeName'] as String?;

        return PoliciesPdfScreen(
          key: const Key(PageName.policiesPdfScreenRoute),
          typeID: typeID,
          typeName: typeName,
        );
      },
    ),
    GoRoute(
        path: PageName.notificationRoute,
        builder: (context, state) => const NotificationsNewScreens()),
    GoRoute(
        path: PageName.paySlips,
        builder: (context, state) => const PaySlipsScreen()),
  ],
);
