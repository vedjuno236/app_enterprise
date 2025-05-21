import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/models/leave_all_model/leave_all_model.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateAllLeaveProvider = ChangeNotifierProvider<AllLeaveProvider>((ref) {
  return AllLeaveProvider();
});

class AllLeaveProvider with ChangeNotifier {
  AllLeaveModel? _allLeaveModel;
  AllLeaveModel? get getAllLeaveModel => _allLeaveModel;

  Future setAllleaveModel({value}) async {
    _allLeaveModel = AllLeaveModel.fromJson(value);
    notifyListeners();
  }

  AllLeaveModel? _AllLeaveModel;
  DateTime? _selectedMonth;
  // String _selectedMonthText = Strings.txtThisMonth;
  String _selectedMonthText = '';

  DateTime _startDate;
  DateTime _endDate;
  int? _selectedIndex;

  AllLeaveProvider()
      : _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1),
        _endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0) {
    _selectedMonth = DateTime.now();
  }

  // Getters

  DateTime? get selectedMonth => _selectedMonth;
  String get selectedMonthText => _selectedMonthText;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  int? get selectedIndex => _selectedIndex;

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
