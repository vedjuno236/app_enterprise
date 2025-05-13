import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

import '../../../components/constants/colors.dart';

class AppbarWidget extends ConsumerWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkTheme = ref.watch(darkThemeProviderProvider);
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: darkTheme.darkTheme
                  ? [Colors.black12, Colors.black26, Colors.black]
                  : kYellowGradientAppbarColors,
            ),
          ),
        ),
        Positioned(
          left: -SizeConfig.imageSizeMultiplier * 10,
          child: SvgPicture.asset(
            ImagePath.svgAppbar,
            color: const Color(0xFFE6A604),
            width: 155,
          ),
        ),
      ],
    );
  }
}
