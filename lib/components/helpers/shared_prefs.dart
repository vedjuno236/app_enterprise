import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  factory SharedPrefs() => SharedPrefs._internal();
  SharedPrefs._internal();
  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  setStringNow(String key, value) {
    return _sharedPrefs!.setString(key, value);
  }

  setIntNow(String key, value) {
    return _sharedPrefs!.setInt(key, value);
  }

  setBoolNow(String key, value) {
    return _sharedPrefs!.setBool(key, value);
  }

  getStringNow(String key) {
    return _sharedPrefs!.getString(key);
  }

  getIntNow(String key) {
    return _sharedPrefs!.getInt(key);
  }

  getBoolNow(String key) {
    return _sharedPrefs!.getBool(key);
  }

  remove(String key) {
    return _sharedPrefs!.remove(key);
  }
}
