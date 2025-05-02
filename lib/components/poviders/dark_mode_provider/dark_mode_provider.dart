import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enterprise/components/helpers/dark_mode_preference.dart';


class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value: value);
    notifyListeners();
  }
}

final darkThemeProviderProvider =
    ChangeNotifierProvider<DarkThemeProvider>((ref) {
  return DarkThemeProvider();
});
