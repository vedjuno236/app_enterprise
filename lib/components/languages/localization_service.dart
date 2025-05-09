import 'dart:collection';

import 'package:enterprise/components/constants/key_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/shared_prefs.dart';
import '../logger/logger.dart';
import '../utils/langs/st_en_us.dart';
import '../utils/langs/st_lo_lo.dart';
import '../utils/langs/st_th_th.dart';
import '../utils/langs/st_vi_vn.dart';

SharedPrefs sharedPrefs = SharedPrefs();

class LocalizationService extends Translations {
  static final locale = _getLocaleFromLanguage();
  static const fallbackLocale = Locale('en', 'US');

  static final langCodes = [
    'en',
    'lo',
  
  ];

  static final locales = [
    const Locale('en', 'US'),
    const Locale('lo', 'LO'),
 
  ];

  static final langs = LinkedHashMap.from({
    'en': 'English',
    'lo': 'ພາສາລາວ',

  });

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'lo_LO': lo,
      
      };

  static Future<void> changeLocale(String langCode) async {
    // logger.d(langCode);
    await sharedPrefs.setStringNow(KeyShared.keyCountryName, langCode);
    final locale = _getLocaleFromLanguage(langCode: langCode);
    // logger.d(locale);
    Get.updateLocale(locale!);
  }

  static Future<Locale?> getSaveLocal() async {
    final langCode = sharedPrefs.getStringNow(KeyShared.keyCountryName);

    if (langCode != null) {
      return _getLocaleFromLanguage(langCode: langCode);
    }

    /// new
    return _getLocaleFromLanguage(langCode: Get.deviceLocale!.languageCode);
  }

  static Locale? _getLocaleFromLanguage({String? langCode}) {
    var deviceLangs = Get.deviceLocale!.languageCode;
    // var lang = langCode ?? deviceLangs;                                                         
    var lang = langCode;
    // logger.d(lang);
    for (int i = 0; i < langCodes.length; i++) {
      if (lang == langCodes[i]) {
        return locales[i];
      }
    }
    return Get.locale;
  }
}
