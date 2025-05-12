import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_history_provider/leave_histoy_provider.dart';
import 'package:enterprise/components/poviders/notifition_provider/notifition_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/app_dialog/alerts_dialog.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/date_month_year/shared/month_picker.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../../widgets/text_input/custom_text_filed.dart';

class NotificationsNewScreens extends ConsumerStatefulWidget {
  const NotificationsNewScreens({super.key});

  @override
  ConsumerState<NotificationsNewScreens> createState() =>
      _NotifitionsNewScreensState();
}

class _NotifitionsNewScreensState
    extends ConsumerState<NotificationsNewScreens> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  SharedPrefs sharedPrefs = SharedPrefs();
  bool isLoading = false;
  int userID = int.parse(SharedPrefs().getStringNow(KeyShared.keyUserId));
  bool isLoadingLeave = false;

  Future fetchNotificationApi() async {
    // ຍ້ອນຫລັງ 10 วัน
    DateTime now = DateTime.now();
    DateTime twoWeeksAgo = now.subtract(const Duration(days: 10));

    final lastDayOfWeek =
        now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    String thisweek = DateFormat('yyyy-MM-dd').format(lastDayOfWeek);
    final nextWeekEnd = lastDayOfWeek.add(const Duration(days: 7));
    logger.d(thisweek);

    String formattedTwoWeeksAgo = DateFormat('yyyy-MM-dd').format(twoWeeksAgo);
    String nextweek = DateFormat('yyyy-MM-dd').format(nextWeekEnd);

    setState(() {
      isLoading = true;
    });

    EnterpriseAPIService()
        .callNotification(
      token: sharedPrefs.getStringNow(KeyShared.keyToken),
      start_date: formattedTwoWeeksAgo,
      end_date: nextweek,
    )
        .then((value) {
      ref.watch(stateNotifitionProvider).setNotificationModel(value: value);
      // logger.d(value);
    }).catchError((onError) {
      errorDialog(
        context: context,
        onError: onError,
      );
    }).whenComplete(() => setState(() {
              isLoading = false;
            }));
  }

  Future fetchAllLeaveApi() async {
    setState(() {
      isLoadingLeave = true;
    });

    EnterpriseAPIService()
        .callAllLeaveHistory(UserId: userID, LeaveTypeID: 0, Status: '')
        .then((value) {
      ref.watch(leaveHistoryProvider).setallLeaveHistoryModel(value: value);
    }).catchError((onError) {
      errorDialog(
        // ignore: use_build_context_synchronously
        context: context,
        onError: onError,
      );
      logger.e(DioExceptions.fromDioError(onError));
    }).whenComplete(() => setState(() {
              isLoadingLeave = false;
            }));
  }

  Future<void> _onRefresh() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllLeaveApi();
    fetchNotificationApi();
  }

  DateTime selectedMonth = DateTime.now();

  Future showDateDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final dateProvider = ref.read(stateNotifitionProvider);
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
                  .bodySmall!
                  .copyWith(color: kBack87),
              enabledCellsTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: kBack87),
              disabledCellsTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: kGreyColor2),
              currentDateTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: kBack87),
              currentDateDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: kBack87),
              ),
              splashColor: kYellowFirstColor,
              slidersColor: kBack,
              centerLeadingDate: true,
              minDate: DateTime(2000),
              maxDate: DateTime(2030),
              currentDate: initialDate,
              selectedDate: initialDate,
              onDateSelected: (month) {
                setState(() {
                  selectedMonth = month;
                });
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => context.pop(),
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
                ref.read(stateNotifitionProvider.notifier).selectedMonth =
                    selectedMonth;

                context.pop();
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
    final notiProvider = ref.watch(stateNotifitionProvider);
    final dataAPI = ref.watch(leaveHistoryProvider);

    int totalLeaveDaysHR = 0;
    if (notiProvider.getNotificationModel != null &&
        notiProvider.getNotificationModel!.data != null) {
      totalLeaveDaysHR = notiProvider.getNotificationModel!.data!.length;
    }

    int totalLeaveDaysUser = 0;
    if (dataAPI.getallLeaveHistoryModel != null &&
        dataAPI.getallLeaveHistoryModel!.data != null) {
      totalLeaveDaysUser = dataAPI.getallLeaveHistoryModel!.data!.length;
    }

    String? role = sharedPrefs.getStringNow(KeyShared.keyRole);
    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: const AppbarWidget(),
          title: AnimatedTextAppBarWidget(
            text: Strings.txtAllNotifications.tr,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showDateDialog(context, ref);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(
                    //   Ionicons.ellipsis_vertical_outline,
                    //   color: kBack,
                    // ),
                    Icon(
                      IonIcons.ellipsis_vertical,
                      color: kBack,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (role == "HR" || role == "MANAGER") ...[
                  Text.rich(TextSpan(
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: SizeConfig.textMultiplier * 1.9,
                          color: const Color(0xFF99A1BE),
                        ),
                    text: "Approvals",
                    children: [
                      TextSpan(
                        text: '($totalLeaveDaysHR requests)',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 1.9,
                              color: kRedColor,
                            ),
                      ),
                    ],
                  ))
                      .animate()
                      .scale(duration: 600.ms, alignment: Alignment.centerLeft),
                  const SizedBox(height: 20),
                  notiProvider.getNotificationModel == null
                      ? Expanded(child: Center(child: _buildShimmerItem()))
                      : notiProvider.getNotificationModel!.data!.isEmpty
                          ? Center(
                              child: Image.asset(ImagePath.imgIconCreateAcc))
                          : Expanded(
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                header: const WaterDropMaterialHeader(
                                  backgroundColor: kYellowFirstColor,
                                  color: kTextWhiteColor,
                                ),
                                footer: CustomFooter(
                                  builder:
                                      (BuildContext context, LoadStatus? mode) {
                                    Widget body;
                                    if (mode == LoadStatus.idle) {
                                      body = const Text(Strings.txtPull);
                                    } else if (mode == LoadStatus.loading) {
                                      body = const LoadingPlatformV1(
                                        color: kYellowColor,
                                      );
                                    } else if (mode == LoadStatus.failed) {
                                      body = const Text(Strings.txtLoadFailed);
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = const Text(Strings.txtLoadMore);
                                    } else {
                                      body = const Text(Strings.txtMore);
                                    }
                                    return SizedBox(
                                      height: 55.0,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                child: ListView.builder(
                                    // physics: CarouselScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: notiProvider.getNotificationModel
                                            ?.data?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      final data = notiProvider
                                          .getNotificationModel?.data?[index];
                                      if (data == null) {
                                        return const SizedBox.shrink();
                                      }

                                      var dataColor = getItemColorAndIcon(
                                          data.keyWord.toString());
                                      Color color = dataColor['color'];
                                      String txt = dataColor['txt'];

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    // CircleAvatar(
                                                    //   radius: SizeConfig
                                                    //           .imageSizeMultiplier *
                                                    //       9.5,
                                                    //   backgroundImage:
                                                    //       NetworkImage(
                                                    //           data.profile ??
                                                    //               ''),
                                                    // ),
                                                    ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl: data.profile !=
                                                                    null &&
                                                                data.profile!
                                                                    .isNotEmpty
                                                            ? data.profile
                                                                .toString()
                                                            : '',
                                                        placeholder:
                                                            (context, url) =>
                                                                SizedBox(
                                                          width: SizeConfig
                                                                  .imageSizeMultiplier *
                                                              12,
                                                          height: SizeConfig
                                                                  .imageSizeMultiplier *
                                                              12,
                                                          child: const Center(
                                                              child:
                                                                  LoadingPlatformV1()),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                        width: SizeConfig
                                                                .imageSizeMultiplier *
                                                            12,
                                                        height: SizeConfig
                                                                .imageSizeMultiplier *
                                                            12,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: -6,
                                                      bottom: 0,
                                                      child: CircleAvatar(
                                                        radius: SizeConfig
                                                                .heightMultiplier *
                                                            1.4,
                                                        backgroundColor: color,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                data.logo ?? '',
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    const LoadingPlatformV1(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.username ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                2,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      // data.typeName ?? '',
                                                      txt,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: const Color(
                                                                0xFF99A1BE),
                                                          ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      'On ${DateFormatUtil.formatDD(DateTime.parse(data.startDate ?? ''))}-${DateFormatUtil.formatddMMy(DateTime.parse(data.endDate ?? ''))}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: const Color(
                                                                0xFF99A1BE),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (data.status == 'REJECTED')
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .widthMultiplier *
                                                        8.5,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        widgetBottomSheetREJECTEDandAPPROVED(
                                                            context, data);
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: const BorderSide(
                                                            color: Color(
                                                                0xFFF28C84)),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        backgroundColor:
                                                            const Color(
                                                                0xFFF28C84),
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Bootstrap
                                                                .check_circle_fill,
                                                            color: Colors.white,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            Strings
                                                                .txtReject.tr,
                                                            style:
                                                                Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          SizeConfig.textMultiplier *
                                                                              1.5,
                                                                      color:
                                                                          kTextWhiteColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                if (data.status ==
                                                    'PENDING') ...[
                                                  SizedBox(
                                                    width: SizeConfig
                                                            .widthMultiplier *
                                                        25,
                                                    height: SizeConfig
                                                            .widthMultiplier *
                                                        8.5,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        widgetBottomSheetFormHR(
                                                            context, data);
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                              side: const BorderSide(
                                                                  color:
                                                                      kYellowColor),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                              backgroundColor:
                                                                  kYellowColor,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero),
                                                      child: Text(
                                                        Strings.txtApprov.tr,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.5,
                                                              color: const Color(
                                                                  0xFF37474F),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                    width: SizeConfig
                                                            .widthMultiplier *
                                                        25,
                                                    height: SizeConfig
                                                            .widthMultiplier *
                                                        8.5,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        widgetBottomSheetFormHR(
                                                            context, data);
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                              side: const BorderSide(
                                                                  color:
                                                                      kGreyBGColor),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                              backgroundColor:
                                                                  kGary,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero),
                                                      child: Text(
                                                        Strings.txtReject.tr,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.5,
                                                              color: const Color(
                                                                  0xFF99A1BE),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                if (data.status == 'APPROVED')
                                                  SizedBox(
                                                    width: SizeConfig
                                                            .widthMultiplier *
                                                        25,
                                                    height: SizeConfig
                                                            .widthMultiplier *
                                                        8.5,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        widgetBottomSheetREJECTEDandAPPROVED(
                                                            context, data);
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                              side: const BorderSide(
                                                                  color: Color(
                                                                      0xFF23A26D)),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF23A26D),
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Bootstrap
                                                                .check_circle_fill,
                                                            color: Colors.white,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            Strings
                                                                .txtApprov.tr,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
                                                                            1.5,
                                                                    color:
                                                                        kTextWhiteColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ).animate().scaleXY(
                                          begin: 0,
                                          end: 1,
                                          delay: 300.ms,
                                          duration: 300.ms,
                                          curve: Curves.easeInOutCubic);
                                    }),
                              ),
                            ),
                  const SizedBox(height: 20),
                ],
                if (role == "EMPLOYEE") ...[
                  Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFF99A1BE),
                          ),
                      text: Strings.txtRequests.tr,
                      children: [
                        TextSpan(
                          text:
                              '($totalLeaveDaysUser ${Strings.txtRequests.tr})',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF23A26D),
                                  ),
                        ),
                      ],
                    ),
                  ).animate().scaleXY(
                      begin: 0,
                      end: 1,
                      delay: 600.ms,
                      duration: 600.ms,
                      curve: Curves.easeInOutCubic),
                  const SizedBox(height: 10),
                  dataAPI.getallLeaveHistoryModel == null
                      ? Expanded(child: Center(child: _buildShimmerItem()))
                      : dataAPI.getallLeaveHistoryModel!.data!.isEmpty ?? true
                          ? Center(
                              child: Image.asset(ImagePath.imgIconCreateAcc))
                          : Expanded(
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                header: const WaterDropMaterialHeader(
                                  backgroundColor: kYellowFirstColor,
                                  color: kTextWhiteColor,
                                ),
                                footer: CustomFooter(
                                  builder:
                                      (BuildContext context, LoadStatus? mode) {
                                    Widget body;
                                    if (mode == LoadStatus.idle) {
                                      body = const Text(Strings.txtPull);
                                    } else if (mode == LoadStatus.loading) {
                                      body = const LoadingPlatformV1(
                                        color: kYellowColor,
                                      );
                                    } else if (mode == LoadStatus.failed) {
                                      body = const Text(Strings.txtLoadFailed);
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = const Text(Strings.txtLoadMore);
                                    } else {
                                      body = const Text(Strings.txtMore);
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
                                  itemCount: dataAPI
                                      .getallLeaveHistoryModel!.data!.length,
                                  itemBuilder: (context, index) {
                                    final data = dataAPI
                                        .getallLeaveHistoryModel!.data![index];
                                    var txtSattus = getItemColorAndIcon(
                                        data.keyWord.toString());
                                    String txt = txtSattus['txt'];
                                    var dataStatus = getCheckStatusUser(
                                        data.status.toString());
                                    Color colorStatus = dataStatus['color'];
                                    String txtStatus = dataStatus['txt'];
                                    Icon iconStatus = dataStatus['icon'];
                                    if (data == null) {
                                      return const SizedBox
                                          .shrink(); // Skip if data is null
                                    }
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: SizeConfig
                                                        .imageSizeMultiplier *
                                                    15,
                                                child: Column(
                                                  children:
                                                      (data.approvedBy ?? [])
                                                          .map((user) {
                                                    final imageUrl =
                                                        user.profile != null &&
                                                                user.profile!
                                                                    .isNotEmpty
                                                            ? user.profile
                                                                .toString()
                                                            : null;

                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4.0,
                                                          vertical: 5),
                                                      child: SizedBox(
                                                        width: SizeConfig
                                                                .imageSizeMultiplier *
                                                            12,
                                                        height: SizeConfig
                                                                .imageSizeMultiplier *
                                                            12,
                                                        child: ClipOval(
                                                          child: imageUrl !=
                                                                  null
                                                              ? CachedNetworkImage(
                                                                  imageUrl:
                                                                      imageUrl,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      const Center(
                                                                    child:
                                                                        LoadingPlatformV1(),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              Colors.grey),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : ClipOval(
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    child: const Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children:
                                                        (data.approvedBy != null
                                                                ? data
                                                                    .approvedBy!
                                                                : [])
                                                            .map((user) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        child: Text(user
                                                            .username
                                                            .toString()),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    // data.typeName.toString(),
                                                    txt,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: const Color(
                                                              0xFF99A1BE),
                                                        ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    'On ${DateFormatUtil.formatDD(DateTime.parse(data.startDate.toString()))}-${DateFormatUtil.formatddMMy(DateTime.parse(data.endDate.toString()))}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: const Color(
                                                              0xFF99A1BE),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                SizeConfig.heightMultiplier *
                                                    4.5,
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                widgetBottomSheetUser(
                                                    context, data);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: colorStatus),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  padding: EdgeInsets.all(8),
                                                  backgroundColor: colorStatus),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  iconStatus,
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    txtStatus.toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color:
                                                                kTextWhiteColor),
                                                  ),
                                                ],
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
                                        curve: Curves.easeInOutCubic);
                                  },
                                ),
                              ),
                            ),
                ],
              ],
            )));
  }

  Map<String, dynamic> getItemColorAndIcon(String keywrd) {
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

  Map<String, dynamic> getCheckStatus(String title) {
    switch (title) {
      case "APPROVED":
        return {
          'color': const Color(0xFF23A26D),
          'txt': "Approved",
        };
      case "REJECTED":
        return {
          'color': const Color(0xFFF28C84),
          'txt': "Rejected",
        };

      case "PENDING":
        return {
          'color': const Color(0xFFFFCE08),
          'txt': "Waiting for approval ",
        };

      default:
        return {
          'color': Colors.blueAccent,
        };
    }
  }

  Map<String, dynamic> getCheckStatusUser(String title) {
    switch (title) {
      case "APPROVED":
        return {
          'color': const Color(0xFF23A26D),
          'txt': Strings.txtApproved.tr,
          'icon': const Icon(
            Bootstrap.check_circle_fill,
            color: Colors.white,
            size: 15,
          ),
        };
      case "REJECTED":
        return {
          'color': const Color(0xFFF28C84),
          'txt': Strings.txtRejected.tr,
          'icon': const Icon(
            Bootstrap.check_circle_fill,
            color: Colors.white,
            size: 15,
          ),
        };

      case "PENDING":
        return {
          'color': const Color(0xFFFFCE08),
          'txt': Strings.txtWaiting.tr,
          'icon': const Icon(
            Bootstrap.check_circle_fill,
            color: Colors.white,
            size: 15,
          ),
        };

      default:
        return {
          'color': Colors.blueAccent,
        };
    }
  }

  Future<dynamic> widgetBottomSheetREJECTEDandAPPROVED(
      BuildContext context, dynamic leaveData) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                var dataStatus =
                    getItemColorAndIcon(leaveData.keyWord.toString());
                Color colorStatus = dataStatus['color'];
                String txt = dataStatus['txt'];
                var dataColor = getCheckStatus(leaveData.status.toString());
                var dataText = getCheckStatusUser(leaveData.status.toString());
                Color colorButton = dataColor['color'];
                String txtButton = dataText['txt'];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F6F9),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.close))),
                          Align(
                            alignment: Alignment.center,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: leaveData.profile,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const Center(child: LoadingPlatformV1()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  leaveData.username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const CircleAvatar(
                                radius: 8,
                                backgroundColor: kBlueColor,
                                child: Icon(
                                  Icons.check,
                                  color: kTextWhiteColor,
                                  size: 13,
                                ),
                              ),
                            ],
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              leaveData.departmentName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      color: Color(0XFF99A1BE)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async {},
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colorButton),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  backgroundColor: colorButton),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Bootstrap.check_circle_fill,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'You re ${txtButton.toString()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.5,
                                            color: kTextWhiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: kTextWhiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius:
                                            SizeConfig.heightMultiplier * 1.6,
                                        backgroundColor:
                                            colorStatus.withOpacity(0.1),
                                        child: CachedNetworkImage(
                                          imageUrl: leaveData.logo!,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              LoadingPlatformV1(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          color: colorStatus,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // leaveData.typeName,
                                            txt.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.5,
                                                    color: kBack87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 70,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: kTextWhiteColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0xFf23A26D),
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
                                                  const SizedBox(width: 10),
                                                  Text(
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
                                                leaveData.total.toString(),
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 70,
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
                                                  const SizedBox(width: 10),
                                                  Text(
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
                                                leaveData.used.toString(),
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
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          Text.rich(
                            TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                              text: Strings.txtRequestdetails.tr,
                              children: [
                                TextSpan(
                                  text: leaveData.typeName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF99A1BE)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            prefixIcon: Image.asset(ImagePath.iconCalendar),
                            hintText:
                                '${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatdm(DateTime.parse(leaveData.endDate.toString()))} ',
                          ),

                          const SizedBox(height: 16),

                          // Reason
                          Text(
                            Strings.txtReason.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 1.9,
                                ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            maxLines: 4,
                            hintText: leaveData.reason ?? '',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Strings.txtImage.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 1.9,
                                ),
                          ),
                          const SizedBox(height: 8),

                          leaveData.document != null &&
                                  leaveData.document.isNotEmpty
                              ? Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: DashedBorder(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: leaveData.document,
                                        placeholder: (context, url) =>
                                            LoadingPlatformV1(),
                                        errorWidget: (context, url, error) {
                                          // Add logging for errors
                                          return const Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ]),
                  ),
                );
              });
        });
  }

  Future<dynamic> widgetBottomSheetFormHR(
      BuildContext context, dynamic leaveData) {
    TextEditingController description = TextEditingController();

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                var dataStatus =
                    getItemColorAndIcon(leaveData.keyWord.toString());
                Color colorStatus = dataStatus['color'];
                String txt = dataStatus['txt'];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F6F9),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.close))),
                          Align(
                            alignment: Alignment.center,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: leaveData.profile,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  leaveData.username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const CircleAvatar(
                                radius: 8,
                                backgroundColor: kBlueColor,
                                child: Icon(
                                  Icons.check,
                                  color: kTextWhiteColor,
                                  size: 13,
                                ),
                              ),
                            ],
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              leaveData.departmentName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      color: Color(0XFF99A1BE)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 40,
                                height: SizeConfig.heightMultiplier * 5,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertSuccessDialog(
                                            title: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF23A26D)
                                                    .withOpacity(.12),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Bootstrap.check_circle_fill,
                                                color: const Color(0xFF23A26D),
                                                size: SizeConfig
                                                        .imageSizeMultiplier *
                                                    10,
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Strings.txtApprov.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  '${leaveData.username}  ${leaveData.typeName} day off on ${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatA(DateTime.parse(leaveData.endDate.toString()))} ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: const Color(
                                                            0xFF23A26D),
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            onTapOK: () async {
                                              logger.d(leaveData.id);
                                              final response =
                                                  await EnterpriseAPIService()
                                                      .updateLeaveNoti(
                                                          id: leaveData.id,
                                                          status: "APPROVED",
                                                          comment: "",
                                                          token: sharedPrefs
                                                              .getStringNow(
                                                                  KeyShared
                                                                      .keyToken))
                                                      .whenComplete(
                                                          () => context.pop());
                                              if (response['data'] ==
                                                  "You have already approved this leave") {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'ອະນຸມັດ    ${leaveData.username}  ໄປແລ້ວ',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: kYellowColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'ອະນຸມັດ ການຂໍລາພັກ   ${leaveData.username} ສໍາເລັດ',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: kBColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              }
                                              await fetchNotificationApi();
                                              context.pop();

                                              print('🎖️🤾‍♂️${response}');
                                            },
                                          );
                                        });
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: kYellowFirstColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      backgroundColor: kYellowFirstColor),
                                  child: Text(
                                    Strings.txtApprov.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 40,
                                height: SizeConfig.heightMultiplier * 5,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          insetPadding:
                                              const EdgeInsets.all(40),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.widthMultiplier *
                                                      5,
                                              vertical:
                                                  SizeConfig.widthMultiplier *
                                                      2,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFF6563)
                                                            .withOpacity(.12),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Bootstrap.check_circle_fill,
                                                    color:
                                                        const Color(0xFFFF6563),
                                                    size: SizeConfig
                                                            .imageSizeMultiplier *
                                                        13,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  Strings.txtReject.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            1.9,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    Strings.txtReason.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontSize: SizeConfig
                                                                  .textMultiplier *
                                                              1.5,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: TextField(
                                                    controller: description,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: const Color(
                                                          0xFFFCE6E4),
                                                      hintText: Strings
                                                          .txtPLeaseEnter.tr,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    kRedColor,
                                                                width: 0.6),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFFCE6E4)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          kYellowFirstColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      logger.d(leaveData.id);
                                                      final response = await EnterpriseAPIService()
                                                          .updateLeaveNoti(
                                                              id: leaveData.id,
                                                              status:
                                                                  "REJECTED",
                                                              comment:
                                                                  description
                                                                      .text,
                                                              token: sharedPrefs
                                                                  .getStringNow(
                                                                      KeyShared
                                                                          .keyToken))
                                                          .whenComplete(() =>
                                                              context.pop());
                                                      context.pop();
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'ປະຕິເສດການຂໍລາພັກ  ${leaveData.username}',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            kRedColor,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                      await fetchNotificationApi();

                                                      print(
                                                          '🎖️🤾‍♂️${response}');
                                                    },
                                                    child: Text(
                                                      Strings.txtOkay.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                1.9,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: kGreyBGColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      backgroundColor: kGary),
                                  child: Text(
                                    Strings.txtReject.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: kTextWhiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius:
                                            SizeConfig.heightMultiplier * 1.6,
                                        backgroundColor:
                                            colorStatus.withOpacity(0.1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CachedNetworkImage(
                                            imageUrl: leaveData.logo!,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            color: colorStatus,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // leaveData.typeName,
                                            txt.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.5,
                                                    color: kBack87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 70,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: kTextWhiteColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0xFf23A26D),
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
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    // "Available",
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
                                                leaveData.total.toString(),
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 70,
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
                                                  const SizedBox(width: 10),
                                                  Text(
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
                                                leaveData.used.toString(),
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
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          Text.rich(
                            TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                              text: Strings.txtRequestdetails.tr,
                              children: [
                                TextSpan(
                                  text: leaveData.typeName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF99A1BE)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            prefixIcon: Image.asset(ImagePath.iconCalendar),
                            hintText:
                                '${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatdm(DateTime.parse(leaveData.endDate.toString()))} ',
                          ),

                          const SizedBox(height: 16),

                          // Reason
                          Text(
                            Strings.txtReason.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 1.9,
                                ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            maxLines: 4,
                            hintText: leaveData.reason ?? '',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Strings.txtImage.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 1.9,
                                ),
                          ),
                          const SizedBox(height: 8),

                          leaveData.document != null &&
                                  leaveData.document.isNotEmpty
                              ? Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: DashedBorder(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: leaveData.document,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'ບໍ່ມີຮູບພາບ',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                        ]),
                  ),
                );
              });
        });
  }

  Future<dynamic> widgetBottomSheetUser(
      BuildContext context, dynamic leaveData) {
    TextEditingController description = TextEditingController();

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.6,
              builder: (context, scrollController) {
                var status = getCheckStatusUser(leaveData.status.toString());
                var dataStatus =
                    getItemColorAndIcon(leaveData.status.toString());
                var colorStatus =
                    getItemColorAndIcon(leaveData.keyWord.toString());
                Color colorS = colorStatus['color'];
                Color color = dataStatus['color'];
                Color colorstatus = status['color'];
                String txtStatus = status['txt'];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F6F9),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.close))),
                          if (leaveData.approvedBy != null &&
                              leaveData.approvedBy!.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  leaveData.approvedBy!.map<Widget>((user) {
                                final username = user.username ?? 'username';
                                final positionName =
                                    user.positionName ?? 'positionName';

                                final profileUrl = (user.profile != null &&
                                        user.profile!.isNotEmpty)
                                    ? user.profile.toString()
                                    : 'https://static.vecteezy.com/system/resources/previews/012/621/570/large_2x/dwarf-dachshund-in-a-striped-dog-jumpsuit-and-a-red-cap-is-sunbathing-on-a-sandy-beach-dog-traveler-blogger-travelblogger-dog-enjoys-a-walk-in-the-fresh-air-outdoors-high-quality-photo.jpg';

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundColor: kTextWhiteColor,
                                        child: CircleAvatar(
                                          radius: 55,
                                          backgroundColor: Colors.grey[
                                              200], // optional fallback color
                                          child: ClipOval(
                                            child: Image.network(
                                              profileUrl,
                                              width: 110,
                                              height: 110,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const Center(
                                                  child: LoadingPlatformV1(),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(Icons.error,
                                                    size: 40,
                                                    color: Colors.red);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.9),
                                          ),
                                          const SizedBox(width: 10),
                                          const CircleAvatar(
                                            radius: 8,
                                            backgroundColor: kBlueColor,
                                            child: Icon(
                                              Icons.check,
                                              color: kTextWhiteColor,
                                              size: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          positionName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.5,
                                                  color: Color(0XFF99A1BE)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: SizeConfig.heightMultiplier * 5,
                            child: OutlinedButton(
                              onPressed: () async {},
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colorstatus),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  backgroundColor: colorstatus),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Bootstrap.check_circle_fill,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '$txtStatus  ${leaveData.typeName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: kTextWhiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius:
                                            SizeConfig.heightMultiplier * 2.2,
                                        backgroundColor:
                                            colorS.withOpacity(0.10),
                                        child: CachedNetworkImage(
                                          imageUrl: leaveData.logo!,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              LoadingPlatformV1(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          color: colorS,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${DateFormatUtil.formatddMMy(DateTime.parse(leaveData.createdAt.toString()))} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.5,
                                                color: kGreyColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color(0xFFF8F9FC),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFFF8F9FC),
                                          blurRadius: 1.0,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    Strings.txtLeaveDate.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                1.7,
                                                            color: kTextGrey),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatdm(DateTime.parse(leaveData.endDate.toString()))} ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontSize: SizeConfig
                                                                  .textMultiplier *
                                                              1.7,
                                                        ),
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
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                1.7,
                                                            color: kTextGrey),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${leaveData.totalDays.toString()} ${Strings.txtDay.tr}',
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: colorstatus,
                                            child: const Icon(
                                              Icons.check,
                                              color: kTextWhiteColor,
                                              size: 13,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '$txtStatus  ${DateFormatUtil.formatddMMy(DateTime.parse(leaveData.updatedAt.toString()))} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: colorstatus),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '  ${DateFormatUtil.formatms(DateTime.parse(leaveData.updatedAt.toString()))} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: kTextGrey),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          leaveData.document != null &&
                                  leaveData.document.isNotEmpty
                              ? Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: DashedBorder(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: leaveData.document,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child: LoadingPlatformV1()),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Icon(Icons.error,
                                              color: Colors.red),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ]),
                  ),
                );
              });
        });
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: SingleChildScrollView(
        child: Column(children: [
          AppShimmer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 10,
                  decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
