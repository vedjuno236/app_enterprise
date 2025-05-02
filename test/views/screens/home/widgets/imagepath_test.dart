
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enterprise/components/constants/image_path.dart';

void main() {

  
  group('_getImagePath Tests', () {
    String _getImagePath(TimeOfDay now) {
      final currentMinutes = now.hour * 60 + now.minute;

      /// 8:00 = 480 minutes, 17:00 = 1020 minutes
      if (currentMinutes >= 480 && currentMinutes < 1020) {
        return ImagePath.svgSunny;
      } else {
        return ImagePath.svgMoon;
      }
    }

    test('returns svgSunny during the day', () {
      final time = TimeOfDay(hour: 9, minute: 0);
      expect(_getImagePath(time), ImagePath.svgSunny);
    });

    test('returns svgMoon during the night', () {
      final time = TimeOfDay(hour: 7, minute: 0);
      expect(_getImagePath(time), ImagePath.svgMoon);
    });

    test('returns svgMoon after work hours', () {
      final time = TimeOfDay(hour: 18, minute: 0);
      expect(_getImagePath(time), ImagePath.svgMoon);
    });

    test('returns svgSunny at the start of work hours', () {
      final time = TimeOfDay(hour: 8, minute: 0);
      expect(_getImagePath(time), ImagePath.svgSunny);
    });

    test('returns svgMoon just before work hours', () {
      final time = TimeOfDay(hour: 7, minute: 59);
      expect(_getImagePath(time), ImagePath.svgMoon);
    });
  });
}
