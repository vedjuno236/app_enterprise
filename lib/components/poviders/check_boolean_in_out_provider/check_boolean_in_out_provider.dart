import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/models/check_boolean_in_out_model/check_boolean_in_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckLastAttendanceToday with ChangeNotifier {
  CheckBooleanInOutModel? _checkBooleanInOutModel;

  CheckBooleanInOutModel? get getCheckBooleanInOutModel =>
      _checkBooleanInOutModel;

  Future setCheckBooleanInOutModel({value}) async {
    _checkBooleanInOutModel = CheckBooleanInOutModel.fromJson(value);
    notifyListeners();
    logger.d(value);
  }
}

final stateCheckBooleanInOutModel =
    ChangeNotifierProvider<CheckLastAttendanceToday>((ref) {
  return CheckLastAttendanceToday();
});
