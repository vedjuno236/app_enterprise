// import 'dart:async';

// import 'package:enterprise/components/constants/key_shared.dart';
// import 'package:enterprise/components/helpers/shared_prefs.dart';
// import 'package:enterprise/components/logger/logger.dart';
// import 'package:enterprise/components/poviders/check_boolean_in_out_provider/check_boolean_in_out_provider.dart';
// import 'package:enterprise/components/services/api_service/enterprise_service.dart';
// import 'package:enterprise/components/utils/dialogs.dart';
// import 'package:enterprise/views/widgets/slide_checkin_checkout_widget/slide_action_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../components/constants/colors.dart';
// import '../../../components/constants/strings.dart';
// import '../../../components/styles/size_config.dart';

// class SlideCheck extends ConsumerStatefulWidget {
//   const SlideCheck({
//     this.callback,
//     this.clockIn = false,
//     super.key,
//   });
//   final FutureOr<void> Function()? callback;
//   final bool clockIn;

//   @override
//   _SlideCheckState createState() => _SlideCheckState();
// }

// class _SlideCheckState extends ConsumerState<SlideCheck> {
//   late SharedPrefs sharedPrefs;
//   late int userID;
//   bool isLoading = false;
//   bool isClockIn = false;

//   Future fetchBooleanInOutApi() async {
//     sharedPrefs = SharedPrefs();
//     final userIdString = sharedPrefs.getStringNow(KeyShared.keyUserId);
//     userID = int.tryParse(userIdString ?? '0') ?? 0;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final value =
//           await EnterpriseAPIService().cllbooleancheckInOut(userid: userID);
//       ref
//           .watch(stateCheckBooleanInOutModel)
//           .setCheckBooleanInOutModel(value: value);
//       logger.d(value);

//       final typeClock = value['data']?['type_clock'] as String?;
//       setState(() {
//         isClockIn = typeClock == 'OUT' || typeClock == '' || widget.clockIn;
//       });
//     } catch (onError) {
//       errorDialog(
//         context: context,
//         onError: onError,
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchBooleanInOutApi();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideAction(
//       rightToLeft: !isClockIn,
//       stretchThumb: true,
//       trackBuilder: (context, state) {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             Shimmer.fromColors(
//               period: const Duration(seconds: 5),
//               baseColor: isClockIn ? kYellowFirstColor : kBackO,
//               highlightColor: Colors.white,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: isClockIn ? kYellowFirstColor : kBackO,
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.transparent,
//               ),
//               child: Center(
//                 child: Text(
//                   isClockIn
//                       ? Strings.txtSlideToClockOut.tr
//                       : Strings.txtSlideToClockIn.tr,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontSize: SizeConfig.textMultiplier * 2.2,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF37474F),
//                       ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       thumbBuilder: (context, state) {
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 100),
//           margin: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: const Color(0xFF37474F),
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: state.isPerformingAction
//               ? const CupertinoActivityIndicator(color: Colors.white)
//               : Icon(
//                   isClockIn ? Icons.chevron_right : Icons.chevron_left,
//                   color: kTextWhiteColor,
//                 ),
//         );
//       },
//       action: () async {
//         if (widget.callback != null) {
//           await widget.callback!();

//           await fetchBooleanInOutApi();
//         }
//       },
//     );
//   }
// }


import 'dart:async';

import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/poviders/home_provider/home_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/slide_checkin_checkout_widget/slide_action_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SlideCheck extends ConsumerWidget { 
  const SlideCheck({
    super.key,
    this.callback,
  });
  final FutureOr<void> Function()? callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isClockedIn = ref.watch(stateHomeProvider).isClockedIn;

    return SlideAction(
      rightToLeft: !isClockedIn,
      stretchThumb: true,
      trackBuilder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              period: const Duration(seconds: 5),
              baseColor: isClockedIn ? kYellowFirstColor : kBackO,
              highlightColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: isClockedIn ? kYellowFirstColor : kBackO,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  isClockedIn
                      ? Strings.txtSlideToClockOut.tr
                      : Strings.txtSlideToClockIn.tr,
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
              : Icon(
                  isClockedIn ? Icons.chevron_right : Icons.chevron_left,
                  color: kTextWhiteColor,
                ),
        );
      },
      action: () async {
        if (callback != null) {
          await callback!();
         
        }
      },
    );
  }
}
