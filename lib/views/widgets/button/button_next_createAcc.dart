import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';

class buttonNext extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final Color color;
  final TextStyle? textStyle;

  const buttonNext(
      {super.key,
      this.text = Strings.txtNext,
      required this.width,
      required this.height,
      this.onPressed,
      this.color = kYellowSecondColor,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kYellowFirstColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.textMultiplier * 1.7,
              ),
        ),
      ),
    );
  }
}
