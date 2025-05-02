import 'package:enterprise/components/models/policy_mode/policy_model.dart';
import 'package:enterprise/components/models/policy_mode/policy_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';

class PolicyProvider with ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  PolicyTypeModel? _policyTypeModel;
  PolicyModel? _policyModel;

  PolicyTypeModel? get getPolicyTypeModel => _policyTypeModel;

  PolicyModel? get getPolicyModel => _policyModel;

  Future setPolicyTypeModels({value}) async {
    _policyTypeModel = PolicyTypeModel.fromJson(value);

    notifyListeners();
  }

  Future setPolicyModels({value}) async {
    _policyModel = PolicyModel.fromJson(value);

    notifyListeners();
  }

  int _thumbsUp = 0;
  Color _color = kTextGrey;

  int get thumbsUp => _thumbsUp;

  Color get color => _color;

  set color(Color newColor) {
    _color = newColor;
    notifyListeners();
  }

  set thumbsUp(int number) {
    _thumbsUp = number;
    notifyListeners();
  }

  void toggleThumbsUp() {
    if (_color == kTextGrey) {
      _thumbsUp++;
      _color = kBlueColor;
    } else {
      _thumbsUp--;
      _color = kTextGrey;
    }
    notifyListeners();
  }
}

final statePolicyProvider = ChangeNotifierProvider<PolicyProvider>((ref) {
  return PolicyProvider();
});
