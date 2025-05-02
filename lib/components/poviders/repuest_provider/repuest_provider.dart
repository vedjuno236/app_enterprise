import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateRepuestprovider = ChangeNotifierProvider<Repuestprovider>((ref) {
  return Repuestprovider();
});

class Repuestprovider with ChangeNotifier {
  int? _selectedIndex;

  int? get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }
}

