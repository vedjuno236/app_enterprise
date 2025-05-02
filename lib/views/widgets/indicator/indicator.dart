import 'package:enterprise/components/constants/colors.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSqare;
  final double size;
  final Color? textColor;
  final String? value;
  const Indicator(
      {super.key,
      required this.color,
      required this.text,
      required this.isSqare,
      required this.size,
      this.value,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Container(
              width: 5,
              height: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // shape: isSqare ? BoxShape.rectangle : BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: kGreyColor2),
            ),
          ],
        ),
        SizedBox(width: 20),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.right,
        ),
      ],
    ));
  }
}
