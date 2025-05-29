import 'dart:async';

import 'package:enterprise/views/widgets/slide_checkin_checkout_widget/slide_action_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/poviders/home_provider/home_provider.dart';
import '../../../components/styles/size_config.dart';

class SlideCheck extends ConsumerStatefulWidget {
  const SlideCheck({
    this.callback,
    this.clockIn = false,
    super.key,
  });
  final FutureOr<void> Function()? callback;
  final bool clockIn;
  @override
  // ignore: library_private_types_in_public_api
  _SlideCheckState createState() => _SlideCheckState();
}

class _SlideCheckState extends ConsumerState<SlideCheck> {
  @override
  Widget build(BuildContext context) {
    final isClockIn = ref.watch(stateHomeProvider).isClockedIn;

    return SlideAction(
      rightToLeft: isClockIn,
      stretchThumb: true,
      trackBuilder: (context, state) {
        // return Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(100),
        //     color: isClockIn ? kBackO : kYellowFirstColor,
        //   ),
        //   child: Shimmer.fromColors(
        //     period: const Duration(seconds: 5),
        //     baseColor: const Color(0xFF37474F),
        //     highlightColor: Colors.white70,
        //     child: Center(
        //       child: Text(
        //         isClockIn
        //             ? Strings.txtSlideToClockIn.tr
        //             : Strings.txtSlideToClockOut.tr,
        //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //             fontSize: SizeConfig.textMultiplier * 2.2,
        //             fontWeight: FontWeight.bold,
        //             color: const Color(0xFF37474F)),
        //       ),
        //     ),
        //   ),
        // );
        return Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              period: const Duration(seconds: 5),
              baseColor: isClockIn ? kBackO : kYellowFirstColor,
              highlightColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: isClockIn ? kBackO : kYellowFirstColor,
                ),
              ),
            ),
            // Content layer
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  isClockIn
                      ? Strings.txtSlideToClockIn.tr
                      : Strings.txtSlideToClockOut.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: SizeConfig.textMultiplier * 2.2,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF37474F),
                      ),
                ),
              ),
            ),
          ],
        );
      },
      thumbBuilder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF37474F),
            borderRadius: BorderRadius.circular(100),
          ),
          child: state.isPerformingAction
              ? const CupertinoActivityIndicator(color: Colors.white)
              : Icon(isClockIn ? Icons.chevron_left : Icons.chevron_right,
                  color: kTextWhiteColor),
        );
      },
      action: () async {
        if (widget.callback != null) {
          await widget.callback!();
        }
        // Optionally update local state or do other actions
      },
    );
  }
}
