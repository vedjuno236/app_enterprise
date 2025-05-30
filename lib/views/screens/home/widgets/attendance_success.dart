import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/bottom_bar_provider/bottom_bar_provider.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/views/screens/home/widgets/box_checkIn_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class AttendanceSuccess extends ConsumerWidget {
  final String clockInTime;
  final String typeClock;
  final bool isLate;

  const AttendanceSuccess({
    super.key,
    required this.clockInTime,
    required this.typeClock,
    required this.isLate,
  });

  List<Color> get kPrimaryGradient => [
        const Color(0x99FCE7BB),
        Colors.white,
        Colors.white,
        const Color(0x99FCE7BB),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkTheme = ref.watch(darkThemeProviderProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Back button
          // Positioned(
          //   top: 65,
          //   left: 16,
          //   child: InkWell(
          //     onTap: () {
          //       logger.d('1234567');
          //       if (Navigator.canPop(context)) context.pop();
          //       if (Navigator.canPop(context)) context.pop();
          //     },
          //     child: const Center(
          //       child: Icon(
          //         Icons.arrow_back_ios_new_outlined,
          //         color: kBack,
          //       ),
          //     ),
          //   ),
          // ),

          // Gradient background
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: darkTheme.darkTheme
                    ? [Colors.black12, Colors.black26, Colors.black]
                    : kPrimaryGradient,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: typeClock == 'IN'
                              ? Colors.green.shade50
                              : Colors.yellow.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Lottie.asset(
                          typeClock == 'IN'
                              ? ImagePath.imgSuccessfully
                              : ImagePath.imgSuccessOutFully,
                          width: SizeConfig.widthMultiplier * 10,
                          height: SizeConfig.heightMultiplier * 10,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          "${Strings.txtYou.tr} ${typeClock == "IN" ? Strings.txtClockedIn.tr : Strings.txtClockedOut.tr} ${Strings.txtSuccessFully.tr}.",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        DateFormatUtil.formats(DateTime.parse(clockInTime)),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 3,
                              fontWeight: FontWeight.bold,
                              color: isLate ? kRedColor : kBack,
                            ),
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      Text(
                        DateFormatUtil.formatA(DateTime.parse(clockInTime)),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                              color: kBack,
                            ),
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      Text(
                        isLate ? Strings.txtTryclockingearliertomorrow.tr : '',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 1.9,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) context.pop();
                    if (Navigator.canPop(context)) context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    isLate
                        ? Strings.txtHaveAgoodday.tr
                        : Strings.txtHaveaproductiveday.tr,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: SizeConfig.textMultiplier * 2,
                        ),
                  ),
                ),
              ).animate().scaleXY(
                    begin: 0,
                    end: 1,
                    delay: 1000.ms,
                    duration: 500.ms,
                    curve: Curves.easeInOutCubic,
                  ),
              SizedBox(height: SizeConfig.heightMultiplier * 5),
            ],
          ),
        ],
      ),
    );
  }
}
