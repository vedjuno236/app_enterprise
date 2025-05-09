import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/poviders/analytic_provider/analytic_provider.dart';
import '../../../components/poviders/leave_provider/leave_history_provider/leave_histoy_provider.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/date_month_year/shared/month_picker.dart';

class LeaveHistoryScreen extends ConsumerStatefulWidget {
  const LeaveHistoryScreen({super.key});

  @override
  LeaveHistoryScreenState createState() => LeaveHistoryScreenState();
}

class LeaveHistoryScreenState extends ConsumerState<LeaveHistoryScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLoadingLeave = false;
  late SharedPrefs sharedPrefs;
  late int userID;
  String currentStatus = '';
  DateTime selectedMonth = DateTime.now();

  final categories = [
    {'label': Strings.txtReview.tr, 'status': ''},
    {'label': Strings.txtApproved.tr, 'status': 'APPROVED'},
    {'label': Strings.txtRejected.tr, 'status': 'REJECTED'},
  ];

  @override
  void initState() {
    super.initState();
    sharedPrefs = SharedPrefs();
    final userIdString = sharedPrefs.getStringNow(KeyShared.keyUserId);
    userID = int.tryParse(userIdString ?? '0') ?? 0; // Safe parsing
    final initialIndex = ref.read(leaveHistoryProvider).selectedIndex;
    final initialStatus = categories[initialIndex]['status']!;
    fetchAllLeaveApi(status: initialStatus);
  }

  @override
  void dispose() {
    _refreshController.dispose(); // Dispose RefreshController
    super.dispose();
  }

  Future<void> fetchAllLeaveApi({required String status}) async {
    setState(() {
      isLoadingLeave = true;
      currentStatus = status;
    });

    try {
      final value = await EnterpriseAPIService().callAllLeaveHistory(
        UserId: userID,
        LeaveTypeID: 0,
        Status: status,
      );
      ref
          .read(leaveHistoryProvider.notifier)
          .setallLeaveHistoryModel(value: value);
    } catch (onError) {
      errorDialog(context: context, onError: onError);
      // logger.e(DioExceptions.fromDioError(onError));
    } finally {
      setState(() {
        isLoadingLeave = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    try {
      await fetchAllLeaveApi(status: currentStatus);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void showDatePickerDialog(BuildContext context, bool isMonthPicker) {
    final dateProvider = ref.read(leaveHistoryProvider);
    DateTime initialDate = dateProvider.selectedMonth ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: kYellowFirstColor,
          backgroundColor: kTextWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SizedBox(
              height: 300,
              width: 450,
              child: MonthPicker(
                selectedCellDecoration: const BoxDecoration(
                  color: kYellowFirstColor,
                  shape: BoxShape.circle,
                ),
                selectedCellTextStyle: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: kTextWhiteColor),
                enabledCellsTextStyle: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: kBack87),
                disabledCellsTextStyle: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: kGary),
                currentDateTextStyle: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: kYellowColor),
                currentDateDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: kYellowColor),
                ),
                splashColor: kYellowFirstColor,
                slidersColor: kBack,
                centerLeadingDate: true,
                minDate: DateTime(2000),
                maxDate: DateTime(2100),
                initialDate: initialDate,
                onDateSelected: (month) {
                  ref.read(stateAnalyticProvider.notifier).selectedMonth =
                      month;
                  // logger.d(DateFormat.MMMM().format(month));
                },
              )),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kGary,
              ),
              child: Text(Strings.txtCancel.tr),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kYellowFirstColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(Strings.txtOkay.tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaveHistoryNotifier = ref.watch(leaveHistoryProvider);
    final selectedIndex = leaveHistoryNotifier.selectedIndex;
    final dataAPI = leaveHistoryNotifier;

    int totalLeaveDays = 0;
    if (dataAPI.getallLeaveHistoryModel?.data != null) {
      totalLeaveDays = dataAPI.getallLeaveHistoryModel!.data!
          .where((item) => item.status == "APPROVED")
          .fold(0, (sum, item) => sum + (item.totalDays ?? 0));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtAllLeaveHistory.tr,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(IonIcons.ellipsis_vertical, color: kBack),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kTextWhiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Strings.txtYoutakeleaves.tr} : ${Strings.txtApproved.tr}',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.5,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$totalLeaveDays ${Strings.txtDay.tr}',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDatePickerDialog(context, true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: SizeConfig.heightMultiplier * 6,
                        decoration: BoxDecoration(
                          color: kYellowFirstColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                DateFormat.MMMM().format(ref
                                        .watch(leaveHistoryProvider)
                                        .selectedMonth ??
                                    DateTime.now()),
                                style: GoogleFonts.notoSansLao(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: SizeConfig.textMultiplier * 2,
                                      ),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().scaleXY(
                  begin: 0,
                  end: 1,
                  delay: 500.ms,
                  duration: 500.ms,
                  curve: Curves.easeInOutCubic,
                ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kTextWhiteColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(categories.length, (index) {
                    final item = categories[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(leaveHistoryProvider.notifier)
                              .updateSelectedIndex(index);
                          fetchAllLeaveApi(status: item['status']!);
                        },
                        child: Container(
                          width: SizeConfig.widthMultiplier * 25,
                          decoration: BoxDecoration(
                            color: selectedIndex == index ? kYellowColor : null,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              item['label']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.7,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ).animate().scaleXY(
                  begin: 0,
                  end: 1,
                  delay: 600.ms,
                  duration: 600.ms,
                  curve: Curves.easeInOutCubic,
                ),
            const SizedBox(height: 20),
            Expanded(
              child: dataAPI.getallLeaveHistoryModel == null
                  ? Center(child: _buildShimmerItem())
                  : dataAPI.getallLeaveHistoryModel!.data! == null ||
                          dataAPI.getallLeaveHistoryModel!.data!.isEmpty
                      ? Center(child: Image.asset(ImagePath.imgIconCreateAcc))
                      : SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          header: const WaterDropMaterialHeader(
                            backgroundColor: kYellowFirstColor,
                            color: kTextWhiteColor,
                          ),
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = Text(Strings.txtPull.tr);
                              } else if (mode == LoadStatus.loading) {
                                body = const LoadingPlatformV1(
                                  color: kYellowColor,
                                );
                              } else if (mode == LoadStatus.failed) {
                                body = Text(Strings.txtLoadFailed.tr);
                              } else if (mode == LoadStatus.canLoading) {
                                body = Text(Strings.txtLoadMore.tr);
                              } else {
                                body = Text(Strings.txtMore.tr);
                              }
                              return SizedBox(
                                height: 55.0,
                                child: Center(child: body),
                              );
                            },
                          ),
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount:
                                dataAPI.getallLeaveHistoryModel!.data!.length,
                            itemBuilder: (context, index) {
                              final data =
                                  dataAPI.getallLeaveHistoryModel!.data![index];

                              final dataColor =
                                  getItemColor(data.keyWord ?? '');
                              Color color = dataColor['color'];
                              String txt = dataColor['txt'];

                              final dataStatus =
                                  getCheckStatus(data.status ?? '');
                              Color colorStatus = dataStatus['color'];
                              String txtStatus = dataStatus['txt'];

                              String? formattedDate;
                              if ((data.status == "APPROVED" ||
                                      data.status == "REJECTED") &&
                                  data.updatedAt != null) {
                                formattedDate = DateFormat("d MMM yyyy")
                                    .format(DateTime.parse(data.updatedAt!));
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 5),
                                child: Container(
                                  height: SizeConfig.heightMultiplier * 25,
                                  decoration: BoxDecoration(
                                    color: kTextWhiteColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius:
                                                  SizeConfig.heightMultiplier *
                                                      2.2,
                                              backgroundColor:
                                                  color.withOpacity(0.10),
                                              child: CachedNetworkImage(
                                                imageUrl: data.logo ?? '',
                                                placeholder: (context, url) =>
                                                    LoadingPlatformV1(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                color: color,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              txt,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.8,
                                                    color: kBack,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height:
                                              SizeConfig.heightMultiplier * 9,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: kGary,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Strings.txtLeaveDate.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: const Color(
                                                                  0xFF979797)),
                                                    ),
                                                    Text(
                                                      '${DateFormatUtil.formatDD(DateTime.parse(data.startDate ?? DateTime.now().toString()))} - '
                                                      '${DateFormatUtil.formatdm(DateTime.parse(data.endDate ?? DateTime.now().toString()))}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.9),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Strings.txtTotalLeave.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: const Color(
                                                                  0xFF979797)),
                                                    ),
                                                    Text(
                                                      '${data.totalDays ?? 0} ${Strings.txtDay.tr}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.9),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: SizeConfig
                                                          .heightMultiplier *
                                                      1.2,
                                                  backgroundColor: colorStatus,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: SizeConfig
                                                            .imageSizeMultiplier *
                                                        4,
                                                    color: kTextWhiteColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  formattedDate != null
                                                      ? '$txtStatus $formattedDate'
                                                      : txtStatus,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            1.5,
                                                        color: colorStatus,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            if (data.approvedBy != null &&
                                                data.approvedBy!.isNotEmpty)
                                              Row(
                                                children: data.approvedBy!
                                                    .map<Widget>((approver) {
                                                  final String profileUrl =
                                                      approver.profile
                                                              ?.trim() ??
                                                          '';
                                                  final bool hasValidProfile =
                                                      profileUrl.isNotEmpty &&
                                                          profileUrl !=
                                                              "https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg";

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Align(
                                                      widthFactor: 0.5,
                                                      child: CircleAvatar(
                                                        radius: SizeConfig
                                                                .imageSizeMultiplier *
                                                            5,
                                                        backgroundColor:
                                                            kTextWhiteColor,
                                                        child: Stack(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: SizeConfig
                                                                      .imageSizeMultiplier *
                                                                  4.3,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                hasValidProfile
                                                                    ? profileUrl
                                                                    : 'https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg',
                                                              ),
                                                            ),
                                                            // ClipOval(
                                                            //   child:
                                                            //       CachedNetworkImage(
                                                            //     imageUrl: hasValidProfile
                                                            //         ? profileUrl
                                                            //         : 'https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg',
                                                            //     placeholder:
                                                            //         (context,
                                                            //                 url) =>
                                                            //             SizedBox(
                                                            //       width: SizeConfig
                                                            //               .imageSizeMultiplier *
                                                            //           12,
                                                            //       height: SizeConfig
                                                            //               .imageSizeMultiplier *
                                                            //           12,
                                                            //       child: const Center(
                                                            //           child:
                                                            //               LoadingPlatformV1()),
                                                            //     ),
                                                            //     errorWidget: (context,
                                                            //             url,
                                                            //             error) =>
                                                            //         const Icon(Icons
                                                            //             .error),
                                                            //     width: SizeConfig
                                                            //             .imageSizeMultiplier *
                                                            //         12,
                                                            //     height: SizeConfig
                                                            //             .imageSizeMultiplier *
                                                            //         12,
                                                            //     fit: BoxFit
                                                            //         .cover,
                                                            //   ),
                                                            // ),

                                                            if (txtStatus ==
                                                                Strings
                                                                    .txtRejected
                                                                    .tr)
                                                              Positioned.fill(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .red
                                                                        .withOpacity(
                                                                            0.5),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animate().scaleXY(
                                    begin: 0,
                                    end: 1,
                                    delay: 400.ms,
                                    duration: 400.ms,
                                    curve: Curves.easeInOutCubic,
                                  );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildShimmerItem() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          AppShimmer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 20,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 20,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 20,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Map<String, dynamic> getItemColor(String? keywrd) {
  switch (keywrd) {
    case "ANNUAL":
      return {'color': const Color(0xFF3085FE), 'txt': Strings.txtAnnual.tr};
    case "LAKIT":
      return {'color': const Color(0xFFF45B69), 'txt': Strings.txtLakit.tr};
    case "SICK":
      return {'color': const Color(0xFFF59E0B), 'txt': Strings.txtSick.tr};
    case "MATERNITY":
      return {'color': const Color(0xFF23A26D), 'txt': Strings.txtMaternity.tr};
    default:
      return {'color': Colors.blueAccent, 'txt': 'Unknown'};
  }
}

Map<String, dynamic> getCheckStatus(String? title) {
  switch (title) {
    case "APPROVED":
      return {'color': const Color(0xFF23A26D), 'txt': Strings.txtApproved.tr};
    case "REJECTED":
      return {'color': const Color(0xFFF45B69), 'txt': Strings.txtRejected.tr};
    case "PENDING":
      return {'color': const Color(0xFFF59E0B), 'txt': Strings.txtWaiting.tr};
    default:
      return {'color': Colors.blueAccent, 'txt': 'Unknown'};
  }
}
