import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/department_model/department_model.dart';

final stateReportHRProvider = ChangeNotifierProvider<ReportHRProvider>((ref) {
  return ReportHRProvider();
});

class ReportHRProvider with ChangeNotifier {
  /// CallAPI
  DepartmentModel? _departmentModel;

  DepartmentModel? get getDepartmentModel => _departmentModel;

  Future setDepartmentModel({value}) async {
    _departmentModel = DepartmentModel.fromJson(value);
    notifyListeners();
  }

  /// Day  DateTime
  DateTime? _selectedDay;

  DateTime? get selectedDay => _selectedDay;

  set selectedDay(DateTime? day) {
    if (day != null) {
      _selectedDay = day;
      notifyListeners();
    }
  }

  ///
  String? _selectedDepartment;

  String? get selectedDepartment => _selectedDepartment;

  set selectedDepartment(String? department) {
    _selectedDepartment = department;
    notifyListeners();
  }

  ///
}
