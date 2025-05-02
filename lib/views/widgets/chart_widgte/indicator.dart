import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/styles/size_config.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
              borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: GoogleFonts.notoSansLao(
            textStyle: Theme.of(context).textTheme.titleLarge,
            fontSize: SizeConfig.textMultiplier * 1.5,
          ),
        )
      ],
    );
  }
}
