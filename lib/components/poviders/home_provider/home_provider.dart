import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/function_model/funcation_model.dart';

final stateHomeProvider = ChangeNotifierProvider<HomeProvider>((ref) {
  return HomeProvider();
});

class HomeProvider with ChangeNotifier {
  HomeProvider();
  
  bool _isClockedIn = false;
  bool get isClockedIn => _isClockedIn;
  void updateClockStatus(String typeClock) {
    _isClockedIn = typeClock == 'OUT' || typeClock == '';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  FunctionsMenuModel? _menuModel;
  FunctionsMenuModel? get getMenuModel => _menuModel;

  Future setMenuModel({value}) async {
    _menuModel = FunctionsMenuModel.fromJson(value);
    notifyListeners();
  }

  /// report
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// function
  int _pageIndex = 0;
  int _currentPage = 0;

  int get pageIndex => _pageIndex;

  int get currentPage => _currentPage;

  set pageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  set currentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }
}
