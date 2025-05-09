import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/analytic_provider/analytic_provider.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';

class AllLeaveScreen extends ConsumerStatefulWidget {
  const AllLeaveScreen({
    super.key,
  });

  @override
  ConsumerState createState() => _AllLeaveScreenState();
}

class _AllLeaveScreenState extends ConsumerState<AllLeaveScreen> {
  int userID = int.parse(SharedPrefs().getStringNow(KeyShared.keyUserId));
  bool isloadingLeave = false;
  Future fetchLeaveTypeApi() async {
    setState(() {
      isloadingLeave = true;
    });
    EnterpriseAPIService()
        .callLeaveType(
          userID: userID,
        )
        .then((value) {
          ref.read(stateLeaveProvider).setLeaveTypeModels(value: value);
          logger.d(value);
        })
        .catchError((onError) {})
        .whenComplete(() {
          setState(() {
            isloadingLeave = false;
          });
        });
  }

  @override
  void initState() {
    super.initState();
    fetchLeaveTypeApi();
  }

  Widget build(BuildContext context) {
    final leaveType = ref.watch(stateLeaveProvider);

    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            leaveType.getLeaveTypeModel!.data == null
                ? GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2),
                    itemCount: 4,
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: kGreyColor1,
                      highlightColor: kGary,
                      child: Container(
                        height: 10,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: kTextWhiteColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: leaveType.getLeaveTypeModel!.data!.length,
                      itemBuilder: (context, index) {
                        final leave = leaveType.getLeaveTypeModel!.data![index];
                        var dataColor = getItemColor(leaveType
                            .getLeaveTypeModel!.data![index].keyWord
                            .toString());
                        Color color = dataColor['color'];
                        String txt = dataColor['txt'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: kTextWhiteColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: kTextWhiteColor,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          SizeConfig.imageSizeMultiplier * 4,
                                      backgroundColor: color.withOpacity(0.1),
                                      child: CachedNetworkImage(
                                        imageUrl: leave.logo!,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                LoadingPlatformV2(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          txt,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 80,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6FCFB),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kBColor,
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: SizeConfig
                                                          .heightMultiplier *
                                                      1,
                                                  backgroundColor: kBColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  // 'Available',
                                                  Strings.txtAvailables.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          fontSize: SizeConfig
                                                                  .textMultiplier *
                                                              1.7),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              leave.total.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        height: 80,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: kTextWhiteColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: kPinkColor,
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: SizeConfig
                                                          .heightMultiplier *
                                                      0.9,
                                                  backgroundColor: kPinkColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  // 'Leave Used',
                                                  Strings.txtLeaveUsed.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          fontSize: SizeConfig
                                                                  .textMultiplier *
                                                              1.7),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              leave.used.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const Column(
              children: [],
            )
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> getItemColor(String keywrd) {
    switch (keywrd) {
      case "ANNUAL":
        return {'color': Color(0xFF3085FE), 'txt': Strings.txtAnnual.tr};
      case "LAKIT":
        return {'color': Color(0xFFF45B69), 'txt': Strings.txtLakit.tr};
      case "SICK":
        return {'color': Color(0xFFF59E0B), 'txt': Strings.txtSick.tr};
      case "MATERNITY":
        return {'color': Color(0xFF23A26D), 'txt': Strings.txtMaternity.tr};

      default:
        return {
          'color': Colors.blueAccent,
        };
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: const AppbarWidget(),
      title: Text(
        Strings.txtAllLeaveHistory,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize Column height
            children: [
              GestureDetector(
                onTap: () {},
                // child: const Icon(
                //   Ionicons.ellipsis_vertical_outline,
                //   color: kBack,
                // ),
                child: const Icon(
                  IonIcons.ellipsis_vertical,
                  color: kBack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
