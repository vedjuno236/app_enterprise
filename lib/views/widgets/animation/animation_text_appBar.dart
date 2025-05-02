import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedTextAppBarWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AnimatedTextAppBarWidget({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
    )
        .animate()
        .slideY(duration: 900.ms, curve: Curves.easeOutCubic)
        .fadeIn();
  }
}
