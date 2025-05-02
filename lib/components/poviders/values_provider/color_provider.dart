import 'dart:math';
import 'dart:ui';

final List<Color> customColors = [
  const Color(0xFF3085FE), // Blue
  const Color(0xFFF45B69),
  const Color(0xFFFFA132), // Orange
  const Color(0xFF23A26D), //
  const Color(0xFFAF52DE) // Green
];

List<Color> getUniqueRandomColors(List<Color> colorList, int count) {
  if (count > colorList.length) {
    throw Exception(
        "Cannot select more unique colors than available in the list");
  }
  colorList.shuffle(Random());
  return colorList.sublist(0, count);
}
