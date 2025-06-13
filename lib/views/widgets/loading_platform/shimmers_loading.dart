import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

Widget containShimmer(WidgetRef ref) {
  final darkTheme = ref.watch(darkThemeProviderProvider);
  final isDarkMode =
      darkTheme.darkTheme; // Adjust based on actual property name
  return Container(
    height: SizeConfig.heightMultiplier * 19,
    child: Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.black12 : Color(0xFFFEF5E1).withAlpha(180),
      highlightColor: Colors.white10,
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
      ),
    ),
  );
}
