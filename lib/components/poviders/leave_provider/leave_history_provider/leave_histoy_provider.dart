import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/models/analytic_model/all_leave_history_model.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveHistoryProvider with ChangeNotifier {
  allLeaveHistoryModel? _allLeaveHistoryModel;

  allLeaveHistoryModel? get getallLeaveHistoryModel => _allLeaveHistoryModel;

  Future setallLeaveHistoryModel({value}) async {
    _allLeaveHistoryModel = allLeaveHistoryModel.fromJson(value);
    notifyListeners();
  }

  int selectedIndexV = 0;

  int get selectedIndex => selectedIndexV;

  void updateSelectedIndex(int index) {
    if (selectedIndexV != index) {
      selectedIndexV = index;

      _allLeaveHistoryModel = null;
      notifyListeners();
    }
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

final leaveHistoryProvider =
    ChangeNotifierProvider<LeaveHistoryProvider>((ref) {
  return LeaveHistoryProvider();
});

