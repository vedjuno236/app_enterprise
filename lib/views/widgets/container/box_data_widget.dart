import 'package:flutter/material.dart';

class BoxDataWidget extends StatelessWidget {
  final String text;
  final Color? colorIndicator;
  final String? value;
  final TextStyle? styleTitle;
  final TextStyle? styleContent;
  final Color? colorContainer;
  final bool isSquare;
  final double sizeWidthIndicator;
  final double sizeHeightIndicator;
  final double? width;
  final double? height;

  final Color colorBorder;

  const BoxDataWidget(
      {super.key,
      required this.text,
      this.value,
      this.colorIndicator,
      this.colorContainer,
      required this.colorBorder,
      this.width,
      this.height,
      required this.isSquare,
      required this.sizeWidthIndicator,
      required this.sizeHeightIndicator,
      this.styleTitle,
      this.styleContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: colorContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: colorBorder,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: sizeWidthIndicator,
                height: sizeHeightIndicator,
                decoration: BoxDecoration(
                  shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                  color: colorIndicator,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: styleTitle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(value.toString(), style: styleContent),
        ],
      ),
    );
  }
}
