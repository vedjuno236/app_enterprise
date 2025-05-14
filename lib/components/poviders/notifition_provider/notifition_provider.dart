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
  NotificationModel? _notificationModel;
  NotificationModel? get getNotificationModel => _notificationModel;
  Future setNotificationModel({value}) async {
    _notificationModel = NotificationModel.fromJson(value);
    notifyListeners();
  }

  DateTime? _selectedMonth;
  String _selectedMonthText = Strings.txtThisMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  // Getters
  DateTime? get selectedMonth => _selectedMonth;
  String get selectedMonthText => _selectedMonthText;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  set selectedMonth(DateTime? month) {
    if (month != null) {
      _selectedMonth = month;
      _selectedMonthText = DateFormatUtil.formatM(month);
      _startDate = DateTime(month.year, month.month, 1);
      _endDate =
          DateTime(month.year, month.month + 1, 1).subtract(Duration(days: 1));
      notifyListeners();
    }
  }
}

