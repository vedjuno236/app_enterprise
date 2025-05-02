
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model/user_model.dart';

class UsersProvider with ChangeNotifier {
  bool _isLoading = true;
  UserModel? _userModel;

  bool get isLoading => _isLoading;
  UserModel? get getUserModel => _userModel;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> setUserModel({required value}) async {
    _userModel = UserModel.fromJson(value);
    notifyListeners();
  }
}

final stateUserProvider = ChangeNotifierProvider<UsersProvider>((ref) {
  return UsersProvider();
});
