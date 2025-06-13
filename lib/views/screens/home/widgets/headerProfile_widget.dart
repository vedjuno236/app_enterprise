import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/poviders/bottom_bar_provider/bottom_bar_provider.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:widgets_easier/widgets_easier.dart';
import '../../../../components/constants/colors.dart';
import '../../../../components/constants/image_path.dart';
import '../../../../components/helpers/shared_prefs.dart';
import '../../../../components/router/router.dart';
import '../../../../components/styles/size_config.dart';

class HeaderProfile extends ConsumerStatefulWidget {
  final SharedPrefs sharedPrefs;
  final String? name;
  final String? lastName;
  final String? positionName;
  final String? profile;

  const HeaderProfile(
      {super.key,
      required this.sharedPrefs,
      this.name,
      this.lastName,
      this.positionName,
      this.profile});
  @override
  ConsumerState<HeaderProfile> createState() => _HeaderProfileState();
}

class _HeaderProfileState extends ConsumerState<HeaderProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Lottie.asset(
              //       'assets/lottie/pro.json',
              //       width: SizeConfig.widthMultiplier * 30,
              //       // height: SizeConfig.heightMultiplier * 30,
              //     ),
              //     CircleAvatar(
              //         radius: 35,
              //         backgroundColor: Colors.white.withOpacity(0.4),
              //         child: CircleAvatar(
              //           radius: 32,
              //           child: ClipOval(
              //               child: widget.profile != null
              //                   ? CachedNetworkImage(
              //                       imageUrl: widget.profile!,
              //                       width: SizeConfig.heightMultiplier * 8,
              //                       height: SizeConfig.heightMultiplier * 8,
              //                       fit: BoxFit.cover,
              //                       key: ValueKey(Random().nextInt(1000000)),
              //                       placeholder: (context, url) =>
              //                           const LoadingPlatformV1(),
              //                       errorWidget: (context, url, error) => Icon(
              //                           Icons.person,
              //                           size:
              //                               SizeConfig.imageSizeMultiplier * 7),
              //                     )
              //                   : CachedNetworkImage(
              //                       imageUrl:
              //                           'https://img.freepik.com/free-photo/village-bungalows-along-nam-song-river-vang-vieng-laos_335224-1252.jpg?t=st=1745551578~exp=1745555178~hmac=24020576c9080278d441b77a07e82b6c2b97718a895fc8bfb6be2ada9afb8694&w=2000',
              //                       width: SizeConfig.heightMultiplier * 8,
              //                       height: SizeConfig.heightMultiplier * 8,
              //                       fit: BoxFit.cover,
              //                       key: ValueKey(Random().nextInt(1000000)),
              //                       placeholder: (context, url) =>
              //                           const LoadingPlatformV1(),
              //                       errorWidget: (context, url, error) => Icon(
              //                           Icons.person,
              //                           size:
              //                               SizeConfig.imageSizeMultiplier * 7),
              //                     )),
              //         )),
              //   ],
              // ),
              Container(
                decoration: ShapeDecoration(
                  shape: DottedBorder(
                    dotSize: 5,
                    dotSpacing: 6,
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: headerProfileColor,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      ref
                          .read(stateBottomBarProvider.notifier)
                          .updateTabSelection(3, 'Profile');
                    },
                    child: ClipOval(
                      child: widget.profile!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.profile!,
                              width: SizeConfig.imageSizeMultiplier * 20,
                              height: SizeConfig.imageSizeMultiplier * 20,
                              fit: BoxFit.cover,
                              key: ValueKey(Random().nextInt(1000000)),
                              placeholder: (context, url) =>
                                  const LoadingPlatformV1(),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: SizeConfig.imageSizeMultiplier * 8,
                              child: const Icon(Bootstrap.person_circle),
                            ),
                    ).animate().scaleXY(
                        begin: 0,
                        end: 1,
                        delay: 500.ms,
                        duration: 500.ms,
                        curve: Curves.easeInOutCubic),
                  ),
                ),
              ),

              SizedBox(width: SizeConfig.widthMultiplier * 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier * 1.9),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.lastName!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier * 1.9),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                  Text(
                    widget.positionName!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 1.8),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // AnalyticsEventService().logAnalyticsEvent(
              //   eventName: Strings.txtLeave,
              //   eventParameter: Strings.txtLeave,
              // );
              context.push(PageName.notificationRoute);
            },
            child: Stack(
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(ImagePath.iconNotification)),
                Positioned(
                  right: 3,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: kRedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColoredDot extends StatelessWidget {
  final int index;
  final int totalDots;

  const ColoredDot({
    super.key,
    required this.index,
    required this.totalDots,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate position
    final double angle = 2 * pi * index / totalDots;
    final double radius = index % 3 == 0 ? 140 : (index % 3 == 1 ? 130 : 120);

    // Calculate position
    final double x = cos(angle) * radius + 150 - (index % 4 == 0 ? 6 : 4) / 2;
    final double y = sin(angle) * radius + 150 - (index % 4 == 0 ? 6 : 4) / 2;

    // Calculate color based on position in the circle
    final double hue = (360 * index / totalDots) % 360;
    final Color dotColor = HSVColor.fromAHSV(1.0, hue, 0.7, 0.9).toColor();

    // Dot size varies slightly
    final double size = index % 4 == 0 ? 6 : 4;

    // Add a special ring dot occasionally
    final bool isRingDot = index % 18 == 0;

    if (isRingDot) {
      return Positioned(
        left: x,
        top: y,
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: dotColor, width: 2),
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      );
    }

    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dotColor,
        ),
      ),
    );
  }
}
