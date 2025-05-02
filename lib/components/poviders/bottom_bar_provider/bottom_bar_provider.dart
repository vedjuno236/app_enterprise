import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBarProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  String _currentTab = "Home";

  String get currentTab => _currentTab;

  void updateTabSelection(int index, String buttonText) {
    _selectedIndex = index;
    _currentTab = buttonText;
    notifyListeners();
  }
    void resetState() {
    _selectedIndex = 0;
    _currentTab = "Home";
    notifyListeners();
  }
}

final stateBottomBarProvider = ChangeNotifierProvider<BottomBarProvider>((ref) {
  return BottomBarProvider();
});
