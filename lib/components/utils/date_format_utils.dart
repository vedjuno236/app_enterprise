// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class DateFormatUtil {
//   static String get currentLocale => Get.locale?.toString() ?? 'lo';

//   static String format(DateTime date, {String? locale}) {
//     final formatter = DateFormat.yMMMd(locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatA(DateTime date, {String? locale}) {
//     final formatter = DateFormat.yMMMMd(locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatB(DateTime date, {String? locale}) {
//     final formatter = DateFormat.MMMMd(locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatC(
//     DateTime date,
//   ) {
//     // final formatter = DateFormat.yMd( currentLocale);
//     // return formatter.format(date);
//     final formatter = DateFormat('d-MM-yyyy');
//     return formatter.format(date);
//   }

//   static String formatD(DateTime date, {String? locale}) {
//     final formatter = DateFormat.EEEE(locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatDD(DateTime date, {String? locale}) {
//     final formatter = DateFormat.d(locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatM(DateTime date, {String? locale}) {
//     final formatter = DateFormat.MMMM(locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formats(DateTime date, {String? locale}) {
//     final formatter = DateFormat('hh:mm a', locale ?? 'en');
//     return formatter.format(date);
//   }

//   static String formatms(DateTime date, {String? locale}) {
//     final formatter = DateFormat('HH:mm:ss ', locale ?? 'en');
//     return formatter.format(date);
//   }

//   static String formatdm(DateTime date, {String? locale}) {
//     final formatter = DateFormat('dd MMMM', locale ?? 'en');
//     return formatter.format(date);
//   }

//   static String formatH(DateTime date, {String? locale}) {
//     final formatter = DateFormat('hh:mm', locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatDM(DateTime date, {String? locale}) {
//     final formatter = DateFormat('dd-MM', locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatDMY(DateTime date, String? locale) {
//     final formatter = DateFormat('dd-MMMM', locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatedm(DateTime date, String? locale) {
//     final formatter = DateFormat('EEE, dd MMMM', locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatddMMy(DateTime date, {String? locale}) {
//     final formatter = DateFormat.yMMMMd(locale ?? currentLocale);
//     return formatter.format(date);
//   }

//   static String formatMMM(DateTime date, {String? locale}) {
//     final formatter = DateFormat.MMM(locale ?? currentLocale);
//     return formatter.format(date);
//   }
// }



import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateFormatUtil {
  static String get currentLocale => Get.locale?.toString() ?? 'lo';

  static String format(DateTime date, {String? locale}) {
    final formatter = DateFormat.yMMMd(locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatA(DateTime date, {String? locale}) {
    final formatter = DateFormat.yMMMMd(locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatB(DateTime date, {String? locale}) {
    final formatter = DateFormat.MMMMd(locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatC(
    DateTime date,
  ) {
    // final formatter = DateFormat.yMd( currentLocale);
    // return formatter.format(date);
    final formatter = DateFormat('d-MM-yyyy');
    return formatter.format(date);
  }

  static String formatD(DateTime date, {String? locale}) {
    final formatter = DateFormat.EEEE(locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatDD(DateTime date, {String? locale}) {
    final formatter = DateFormat.d(locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatM(DateTime date, {String? locale}) {
    final formatter = DateFormat.MMMM(locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formats(DateTime date, {String? locale}) {
    final formatter = DateFormat('hh:mm a', locale ?? 'en');
    return formatter.format(date);
  }

  static String formatms(DateTime date, {String? locale}) {
    final formatter = DateFormat('HH:mm:ss ', locale ?? 'en');
    return formatter.format(date);
  }

  static String formatdm(DateTime date, {String? locale}) {
    final formatter = DateFormat('dd MMMM', locale ?? 'en');
    return formatter.format(date);
  }

  // แก้ไขตรงนี้: เปลี่ยนจาก 'hh:mm' เป็น 'HH:mm' 
  static String formatH(DateTime date, {String? locale}) {
    final formatter = DateFormat('HH:mm', locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatDM(DateTime date, {String? locale}) {
    final formatter = DateFormat('dd-MM', locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatDMY(DateTime date, String? locale) {
    final formatter = DateFormat('dd-MMMM', locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatedm(DateTime date, String? locale) {
    final formatter = DateFormat('EEE, dd MMMM', locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatddMMy(DateTime date, {String? locale}) {
    final formatter = DateFormat.yMMMMd(locale ?? currentLocale);
    return formatter.format(date);
  }

  static String formatMMM(DateTime date, {String? locale}) {
    final formatter = DateFormat.MMM(locale ?? currentLocale);
    return formatter.format(date);
  }
}