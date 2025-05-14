import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/models/notification_model/notification_model.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onLeaveProvider = ChangeNotifierProvider<OnLeaveNotifier>((ref) {
  return OnLeaveNotifier();
});

class OnLeaveNotifier with ChangeNotifier {
  NotificationModel? _notificationModel;
  DateTime? _selectedMonth;
  // String _selectedMonthText = Strings.txtThisMonth;
  String _selectedMonthText = '';

  DateTime _startDate;
  DateTime _endDate;
  int? _selectedIndex;

  OnLeaveNotifier()
      : _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1),
        _endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0) {
    _selectedMonth = DateTime.now();
  }

  // Getters
  NotificationModel? get getNotificationModel => _notificationModel;
  DateTime? get selectedMonth => _selectedMonth;
  String get selectedMonthText => _selectedMonthText;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  int? get selectedIndex => _selectedIndex;

  // Methods
  Future<void> setNotificationModel({required dynamic value}) async {
    _notificationModel = NotificationModel.fromJson(value);
    notifyListeners();
  }

  set selectedMonth(DateTime? month) {
    if (month != null) {
      _selectedMonth = month;
      _selectedMonthText = DateFormatUtil.formatM(month);
      _startDate = DateTime(month.year, month.month, 1);
      _endDate = DateTime(month.year, month.month + 1, 0);
      notifyListeners();
    }
  }

  set selectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }

  void resetSelectedMonth() {
    _selectedMonth = null;
    _selectedMonthText = Strings.txtThisMonth;

    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    notifyListeners();
  }

  int selectedIndexOnleave = 0;

  int get selectedIndexleave => selectedIndexOnleave;

  void updateSelectedIndexOnleave(int index) {
    selectedIndexOnleave = index;

    notifyListeners();
  }

  void clearSelectedIndex() {
    selectedIndexOnleave = 0;
    notifyListeners();
  }
}
