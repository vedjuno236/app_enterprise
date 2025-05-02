import 'package:enterprise/components/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  const AppShimmer({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // baseColor: Theme.of(context).hoverColor,
      // highlightColor: Theme.of(context).highlightColor,
      baseColor: kGreyColor1,
      highlightColor: kGary,
      enabled: true,
      child: child,
    );
  }
}
