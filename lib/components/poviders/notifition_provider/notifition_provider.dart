import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/models/notification_model/notification_model.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateNotifitionProvider =
    ChangeNotifierProvider<NotifitionProvider>((ref) {
  return NotifitionProvider();
});

class NotifitionProvider with ChangeNotifier {
  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;
  set selectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }
  NotificationModel? _notificationModel;
  NotificationModel? get getNotificationModel => _notificationModel;
  Future setNotificationModel({value}) async {
    _notificationModel = NotificationModel.fromJson(value);
    notifyListeners();
  }

   DateTime? _selectedMonth;

  String _selectedMonthText = Strings.txtThisMonth;

  // Getters
  DateTime? get selectedMonth => _selectedMonth;

  String get selectedMonthText => _selectedMonthText;

  // Setters
  set selectedMonth(DateTime? month) {
    _selectedMonth = month;
    // _selectedMonthText = DateFormat.MMMM().format(month!);
    _selectedMonthText = DateFormatUtil.formatM(month!);
    notifyListeners();
  }
}



final teamHighlightsProvider = ChangeNotifierProvider<TeamHighlightsNotifier>((ref) {
  return TeamHighlightsNotifier();
});

class TeamHighlightsNotifier with ChangeNotifier {
  NotificationModel? _notificationModel;
  NotificationModel? get getNotificationModel => _notificationModel;

  Future<void> setNotificationModel({required dynamic value}) async {
    _notificationModel = NotificationModel.fromJson(value);
    notifyListeners();
  }
}