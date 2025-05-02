import 'package:enterprise/components/models/analytic_model/overview_attendance_month_model.dart';
import 'package:enterprise/components/models/analytic_model/attendance_model.dart';

import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants/strings.dart';

final stateAnalyticProvider = ChangeNotifierProvider<AnalyticProvider>((ref) {
  return AnalyticProvider();
});

class AnalyticProvider with ChangeNotifier {
  /// API
  OverviewAttendanceMonthModel? _overviewAttendanceMonthModel;

  OverviewAttendanceMonthModel? get getOverviewAttendanceMonthModel => _overviewAttendanceMonthModel;

  Future setAnalyticModel({value}) async {
    _overviewAttendanceMonthModel = OverviewAttendanceMonthModel.fromJson(value);
    notifyListeners();
  }

  AttendanceModel? _AttendanceModel;

  AttendanceModel? get getAttendanceModel => _AttendanceModel;

  Future setAnalyticMonthModel({value}) async {
    _AttendanceModel = AttendanceModel.fromJson(value);
    notifyListeners();
  }

  DateTime? _selectedMonth;
  DateTime? _selectedYear;

  String _selectedMonthText = Strings.txtThisMonth;
  String _selectedYearText = Strings.txtThisYear;

  // Getters
  DateTime? get selectedMonth => _selectedMonth;

  DateTime? get selectedYear => _selectedYear;

  String get selectedMonthText => _selectedMonthText;

  String get selectedYearText => _selectedYearText;

  // Setters
  set selectedMonth(DateTime? month) {
    _selectedMonth = month;
    // _selectedMonthText = DateFormat.MMMM().format(month!);
    _selectedMonthText = DateFormatUtil.formatM(month!);
    notifyListeners();
  }

  set selectedYear(DateTime? year) {
    _selectedYear = year;
    _selectedYearText = DateFormat.y().format(year!);
    notifyListeners();
  }
int _currentPage = 1;

  int get currentPageIndex => _currentPage;

  set currentPageIndex(int index) {
    _currentPage = index;
    notifyListeners();
  }

  // void incrementPage() {
  //   _currentPage++;
  //   notifyListeners();
  // }

  // void decrementPage() {
  //   if (_currentPage > 1) {
  //     _currentPage--;
  //     notifyListeners();
  //   }
  // }

  void resetPage() {
    _currentPage = 1;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool index) {
    _isLoading = index;
    notifyListeners();
  }



  Map<int, bool> _dropdownState = {};

  Map<int, bool> get dropdownState => _dropdownState;

  void toggleDropdown(int index) {
    _dropdownState[index] = !(_dropdownState[index] ?? false);
    notifyListeners();
  }

}
