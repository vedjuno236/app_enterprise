import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventProvider with ChangeNotifier {
  int? _selectedIndexAllEvnet;
  int? get selectedIndexEventAll => _selectedIndexAllEvnet;
  set selectedIndexAllEvnet(int? value) {
    _selectedIndexAllEvnet = value;
    notifyListeners();
  }

  int? _selectedIndexEvnet;
  int? get selectedIndexEvent => _selectedIndexEvnet;
  set selectedIndex(int? value) {
    _selectedIndexEvnet = value;
    notifyListeners();
  }
}

final stateEventProvider = ChangeNotifierProvider<EventProvider>((ref) {
  return EventProvider();
});
