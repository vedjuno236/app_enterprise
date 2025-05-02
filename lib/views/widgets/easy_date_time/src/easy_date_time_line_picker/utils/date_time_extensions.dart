import 'package:flutter/material.dart' show DateUtils;

extension DateTimeExtension on DateTime {
  DateTime toDateOnly() => DateUtils.dateOnly(this);
}

extension DateTimeExtensions on DateTime {
  /// Returns a new DateTime instance with the time set to midnight.
  DateTime get normalized {
    return DateTime(year, month, day);
  }

  /// Returns a new DateTime instance with the original time component restored.
  DateTime unNormalized(Duration originalTime) {
    return normalized.add(originalTime);
  }

  /// Calculates the original time duration from the focus date.
  Duration calculateOriginalTime(DateTime focusDate) {
    return Duration(
      hours: focusDate.hour,
      minutes: focusDate.minute,
      seconds: focusDate.second,
      milliseconds: focusDate.millisecond,
      microseconds: focusDate.microsecond,
    );
  }
}
