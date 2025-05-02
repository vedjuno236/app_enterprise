import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/constants/colors.dart';

class AppbarWidget extends StatefulWidget {
  const AppbarWidget({super.key});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: kYellowGradientAppbarColors),
          ),
        ),
        Positioned(
          left: -SizeConfig.imageSizeMultiplier * 10,
          child: SvgPicture.asset(
            color: const Color(0xFFE6A604),
            ImagePath.svgAppbar,
            width: 155,
          ),
        ),
      ],
    );
  }

}



