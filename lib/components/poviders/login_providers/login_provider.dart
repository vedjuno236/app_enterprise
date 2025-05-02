import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logger/logger.dart';

class LoginProvider with ChangeNotifier {
  int a = 1;

  int get getA => a;

  void calculate() {
    a += a;
    notifyListeners();
    logger.d(a);
  }

  bool _passwordVisibility = false;
  bool _isLoading = false;

  bool get passwordVisibility => _passwordVisibility;

  set passwordVisibility(bool visibility) {
    _passwordVisibility = visibility;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}

final stateLoginProvider = ChangeNotifierProvider<LoginProvider>((ref) {
  return LoginProvider();
});
