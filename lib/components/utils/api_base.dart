import 'package:flutter/foundation.dart';

// const String kBaseURL = 'http://172.20.10.2:9922';
const String kBaseURL = 'http://192.168.1.26:9922';
const String kAppVersion = '1.0.0';
const int kConnectTimeout = 10000;
const int kReceiveTimeout = 10000;

class ApiBase {
  static String get baseURL {
    if (kReleaseMode) {
      return kBaseURL;
    } else {
      return kBaseURL;
    }
  }
}
//ipconfig getifaddr en0




