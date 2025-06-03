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
  // String _selectedMonthText = Strings.txtThisMonth;
  String _selectedMonthText = '';

  DateTime _startDate;
  DateTime _endDate;
  int? _selectedIndex;

  LeaveHistoryProvider()
      : _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1),
        _endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0) {
    _selectedMonth = DateTime.now();
  }
  // Getters
  DateTime? get selectedMonth => _selectedMonth;
  String get selectedMonthText => _selectedMonthText;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  // Methods
  set selectedMonth(DateTime? month) {
    if (month != null) {
      _selectedMonth = month;
      _selectedMonthText = DateFormatUtil.formatM(month);
      _startDate = DateTime(month.year, month.month, 1);
      _endDate = DateTime(month.year, month.month + 1, 0);
      notifyListeners();
    }
  }
}

final leaveHistoryProvider =
    ChangeNotifierProvider<LeaveHistoryProvider>((ref) {
  return LeaveHistoryProvider();
});

