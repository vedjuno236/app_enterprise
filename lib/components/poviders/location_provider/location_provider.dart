import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/location_model/location_model.dart';

class ConditionSettingProvider with ChangeNotifier {
  ConditionSettingModel? _conditionSettingModel;

  ConditionSettingModel? get getConditionSettingModel => _conditionSettingModel;

  Future setLocationModels({value}) async {
    _conditionSettingModel = ConditionSettingModel.fromJson(value);

    notifyListeners();
  }
}

final stateLocationProvider =
    ChangeNotifierProvider<ConditionSettingProvider>((ref) {
  return ConditionSettingProvider();
});
