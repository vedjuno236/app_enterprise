import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateRequestOTProvider = ChangeNotifierProvider<RequestOTProvider>((ref) {
  return RequestOTProvider();
});

class RequestOTProvider with ChangeNotifier {



   String? _selectedOtType;
    String? get selectedOtType => _selectedOtType;

  bool _isDropdownOpen = false;


  bool get isDropdownOpen => _isDropdownOpen;

  set isDropdownOpen(bool dropdownOpen) {
    _isDropdownOpen = dropdownOpen;
    notifyListeners();
  }

  set selectedOtType(String? typeLeave) {
    _selectedOtType = typeLeave;
    notifyListeners();
  }



  DateTime? _selectedDateStart;

  DateTime? _selectedDateEnd;

  DateTime? get selectedDateStart => _selectedDateStart;

  set selectedDateStart(DateTime? date) {
    _selectedDateStart = date;
    notifyListeners();
  }

  DateTime? get selectedDateEnd => _selectedDateEnd;

  // Setter for end date
  set selectedDateEnd(DateTime? date) {
    _selectedDateEnd = date;
    notifyListeners();
  }

  /// Time
  DateTime? _selectedTimeStart;
  DateTime? _selectedTimeEnd;

  DateTime? get selectedTimeStart => _selectedTimeStart;

  set selectedTimeStart(DateTime? date) {
    _selectedTimeStart = date;
    notifyListeners();
  }

  DateTime? get selectedTimeEnd => _selectedTimeEnd;

  // Setter for end date
  set selectedTimeEnd(DateTime? date) {
    _selectedTimeEnd = date;
    notifyListeners();
  }
}
