import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/poviders/bottom_bar_provider/bottom_bar_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/views/screens/home/widgets/box_checkIn_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class AttendanceSuccess extends StatefulWidget {
  final String clockInTime;
  final String typeClock;
  final bool isLate;
  const AttendanceSuccess({
    super.key,
    required this.clockInTime,
    required this.typeClock,
    required this.isLate,
  });
  @override
  State<AttendanceSuccess> createState() => _AttendanceSuccessState();
}

class _AttendanceSuccessState extends State<AttendanceSuccess> {
  @override
  List<Color> kPrimaryGradient = [
    // const Color(0xFFFEF5E1),
    const Color(0x99FCE7BB),
    Colors.white,
    Colors.white,

    const Color(0x99FCE7BB),
    // const Color(0xFFFDF6E5),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 65,
            left: 16,
            child: GestureDetector(
              onTap: () {
                context.pop();
                context.pop();
              },
              child: const Center(
                  child: Icon(Icons.arrow_back_ios_new_outlined,
                      color: Colors.black)),
            ),
          ).animate().scaleXY(
              begin: 0,
              end: 1,
              delay: 1000.ms,
              duration: 500.ms,
              curve: Curves.easeInOutCubic),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: kPrimaryGradient,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
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
                          color: widget.typeClock == 'IN'
                              ? Colors.green.shade50
                              : Colors.yellow.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Lottie.asset(
                          widget.typeClock == 'IN'
                              ? ImagePath.imgSuccessfully
                              : ImagePath.imgSuccessOutFully,
                          width: SizeConfig.widthMultiplier * 10,
                          height: SizeConfig.heightMultiplier * 10,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          "${Strings.txtYou.tr} ${widget.typeClock == "IN" ? Strings.txtClockedIn.tr : Strings.txtClockedOut.tr} ${Strings.txtSuccessFully.tr}."
                              .tr,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        DateFormatUtil.formats(
                            DateTime.parse(widget.clockInTime)),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 3,
                              fontWeight: FontWeight.bold,
                              color: widget.isLate ? kBack : kRedColor,
                            ),
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      Text(
                        DateFormatUtil.formatA(
                            DateTime.parse(widget.clockInTime)),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                              color: kBack,
                            ),
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      Text(
                        widget.isLate
                            ? ''
                            : Strings.txtTryClockingInEarlierTomorrow.tr,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 1.9,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom button
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      context.pop();
                    }
                    if (Navigator.canPop(context)) {
                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color(0xFFF9CE4A),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    widget.isLate
                        ? Strings.txtHaveAproductiveday.tr
                        : Strings.txtHaveAgoodday.tr,
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
                  curve: Curves.easeInOutCubic),
            ],
          ),
        ],
      ),
    );
  }
}
