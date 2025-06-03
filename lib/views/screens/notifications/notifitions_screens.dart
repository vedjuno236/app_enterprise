import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_history_provider/leave_histoy_provider.dart';
import 'package:enterprise/components/poviders/notifition_provider/notifition_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/app_dialog/alerts_dialog.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/date_month_year/shared/month_picker.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:enterprise/views/widgets/text_input/text_input_custom_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:widgets_easier/widgets_easier.dart';

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
  final RefreshController _refreshControllerUser =
      RefreshController(initialRefresh: false);
  SharedPrefs sharedPrefs = SharedPrefs();
  bool isLoading = false;
  int userID = int.parse(SharedPrefs().getStringNow(KeyShared.keyUserId));
  bool isLoadingLeave = false;
  Future fetchNotificationApi() async {
    final dateProvider = ref.read(stateNotifitionProvider);
    DateTime? startDate = dateProvider.startDate;
    DateTime? endDate = dateProvider.endDate;
    String formattedStartDate;
    String formattedEndDate;
    if (startDate == null || endDate == null) {
      DateTime now = DateTime.now();
      DateTime twoWeeksAgo = now.subtract(const Duration(days: 10));
      final lastDayOfWeek =
          now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
      final nextWeekEnd = lastDayOfWeek.add(const Duration(days: 7));
      formattedStartDate = DateFormat('yyyy-MM-dd').format(twoWeeksAgo);
      formattedEndDate = DateFormat('yyyy-MM-dd').format(nextWeekEnd);
    } else {
      formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    }
    setState(() {
      isLoading = true;
    });
    try {
      final value = await EnterpriseAPIService().callNotification(
        token: sharedPrefs.getStringNow(KeyShared.keyToken),
        start_date: formattedStartDate,
        end_date: formattedEndDate,
      );
      ref
          .read(stateNotifitionProvider.notifier)
          .setNotificationModel(value: value);
    } catch (onError) {
      errorDialog(
        context: context,
        onError: onError,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime selectedMonthUser = DateTime.now();
  Future fetchNotificationApiUser(
      {required startDate, required endDate}) async {
    setState(() {
      isLoadingLeave = true;
    });
    EnterpriseAPIService()
        .callAllLeaveHistory(
      UserId: userID,
      LeaveTypeID: 0,
      Status: '',
      start_date: startDate,
      end_date: endDate,
    )
        .then((value) {
      ref.watch(leaveHistoryProvider).setallLeaveHistoryModel(value: value);
    }).catchError((onError) {
      errorDialog(
        // ignore: use_build_context_synchronously
        context: context,
        onError: onError,
      );
    }).whenComplete(() => setState(() {
              isLoadingLeave = false;
            }));
  }

  Future<void> _onLoadingUserNoti() async {
    final notiProverUser = ref.watch(leaveHistoryProvider);

    final dataAPI = notiProverUser;

    try {
      // final startDate = DateTime(selectedMonthUser.year, selectedMonthUser.month, 1);
      // final endDate = DateTime(selectedMonthUser.year, selectedMonthUser.month + 1, 0);

      // await fetchNotificationApiUser(
      //   startDate: DateFormat('yyyy-MM-dd').format(startDate),
      //   endDate: DateFormat('yyyy-MM-dd').format(endDate),
      // );
      if (dataAPI.getallLeaveHistoryModel!.data!.isEmpty) {
        _refreshControllerUser.loadNoData();
      } else {
        _refreshControllerUser.loadComplete();
      }
    } catch (e) {
      _refreshControllerUser.loadFailed();
    }
  }

  Future<void> _onLoadingNoti() async {
    final notiProvider = ref.watch(stateNotifitionProvider);
    final dataAPI = notiProvider;

    try {
      await fetchNotificationApi();

      if (dataAPI.getNotificationModel!.data!.isEmpty) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  Future<void> _onRefresh() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
      _refreshController.refreshCompleted();
    }
  }

  Future<void> _onRefreshUser() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshControllerUser.refreshCompleted();
      _refreshControllerUser.refreshCompleted();
    } catch (e) {
      _refreshControllerUser.refreshFailed();
      _refreshControllerUser.refreshCompleted();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(stateNotifitionProvider).selectedMonth = DateTime.now();
      fetchNotificationApi();

      ref.read(leaveHistoryProvider).selectedMonth = DateTime.now();
      final startDate = DateTime(selectedMonthUser.year, selectedMonthUser.month, 1);
      final endDate = DateTime(selectedMonthUser.year, selectedMonthUser.month + 1, 0);
      await fetchNotificationApiUser(
          startDate: DateFormat('yyyy-MM-dd').format(startDate),
          endDate: DateFormat('yyyy-MM-dd').format(endDate));
    });
  }

  @override
  void dispose() {
    _refreshControllerUser.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future showDateDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final dateProvider = ref.read(stateNotifitionProvider);
    DateTime initialDate = dateProvider.selectedMonth ?? DateTime.now();
    DateTime? selectedMonth = DateTime.now();
    DateTime now = DateTime.now();
    DateTime maxDate = DateTime(now.year, now.month + 1, 0);
    final darkTheme = ref.watch(darkThemeProviderProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: kYellowFirstColor,
          backgroundColor: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SizedBox(
            height: 300,
            width: 450,
            child: MonthPicker(
              splashRadius: 10,
              selectedCellDecoration: BoxDecoration(
                  color: kYellowFirstColor,
                  borderRadius: BorderRadius.circular(12)),
              selectedCellTextStyle:
                  Theme.of(context).textTheme.bodyMedium!.copyWith(),
              enabledCellsTextStyle:
                  Theme.of(context).textTheme.bodyMedium!.copyWith(),
              enabledCellsDecoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Color(0xFFEDEFF7)),
              ),
              disabledCellsTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xFFE4E4E7)),
              disabledCellsDecoration: BoxDecoration(
                color: Theme.of(context).canvasColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Color(0xFFEDEFF7)),
              ),
              currentDateTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: kBack87),
              currentDateDecoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xFFEDEFF7)),
                  borderRadius: BorderRadius.circular(12)),
              splashColor: kYellowFirstColor,
              slidersColor: kBack,
              centerLeadingDate: true,
              minDate: DateTime(2000),
              maxDate: maxDate,
              currentDate: initialDate,
              selectedDate: initialDate,
              onDateSelected: (month) {
                selectedMonth = month;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    darkTheme.darkTheme ? kGreyBGColor.withAlpha(50) : kGary,
              ),
              child: Text(Strings.txtCancel.tr),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: darkTheme.darkTheme ? kBack : kYellowColor,
              ),
              onPressed: () {
                if (selectedMonth != null) {
                  ref.read(stateNotifitionProvider.notifier).selectedMonth =
                      selectedMonth;

                  fetchNotificationApi();
                } else {}
                context.pop();
              },
              child: Text(Strings.txtOkay.tr),
            ),
          ],
        );
      },
    );
  }


  void showDateDialogUser(
    BuildContext context,
  ) {
    final dateProvider = ref.read(leaveHistoryProvider);
    DateTime initialDate = dateProvider.selectedMonth ?? DateTime.now();
    DateTime now = DateTime.now();
    DateTime maxDate = DateTime(now.year, now.month + 1, 0);
    final darkTheme = ref.watch(darkThemeProviderProvider);
  DateTime selectedMonthUser = DateTime.now();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: kYellowFirstColor,
          backgroundColor: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SizedBox(
              height: 300,
              width: 450,
              child: MonthPicker(
                splashRadius: 10,
                selectedCellDecoration: BoxDecoration(
                    color: kYellowFirstColor,
                    borderRadius: BorderRadius.circular(12)
                    // shape: BoxShape.circle,
                    ),
                selectedCellTextStyle:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: kBack87,
                        ),
                enabledCellsTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
                enabledCellsDecoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1, color: Color(0xFFEDEFF7)),
                ),
                disabledCellsTextStyle:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Color(0xFFE4E4E7),
                        ),
                disabledCellsDecoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFEDEFF7),
                  ),
                ),
                currentDateTextStyle:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: kBack87,
                        ),
                currentDateDecoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xFFEDEFF7)),
                    borderRadius: BorderRadius.circular(12)),
                splashColor: kYellowFirstColor,
                slidersColor: kBack,
                centerLeadingDate: true,
                minDate: DateTime(2000),
                maxDate: maxDate,
                currentDate: initialDate,
                selectedDate: initialDate,
                onDateSelected: (month) {
                  selectedMonthUser = month;
                },
              )),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    darkTheme.darkTheme ? kGreyBGColor.withAlpha(50) : kGary,
              ),
              child: Text(
                Strings.txtCancel.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 2.2),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: darkTheme.darkTheme ? kBack : kYellowColor,
              ),
              onPressed: () {
                final provider = ref.read(leaveHistoryProvider.notifier);
                provider.selectedMonth = selectedMonthUser;
                fetchNotificationApiUser(
                  startDate:
                      DateFormat('yyyy-MM-dd').format(provider.startDate),
                  endDate: DateFormat('yyyy-MM-dd').format(provider.endDate),
                );
                context.pop();
              },
              child: Text(
                Strings.txtOkay.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 2.2),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notiProvider = ref.watch(stateNotifitionProvider);
    final notiProverUser = ref.watch(leaveHistoryProvider);

    int totalLeaveDaysHR = 0;
    if (notiProvider.getNotificationModel != null &&
        notiProvider.getNotificationModel!.data != null) {
      totalLeaveDaysHR = notiProvider.getNotificationModel!.data!.length;
    }

    int totalLeaveDaysUser = 0;
    if (notiProverUser.getallLeaveHistoryModel != null &&
        notiProverUser.getallLeaveHistoryModel!.data != null) {
      totalLeaveDaysUser = notiProverUser.getallLeaveHistoryModel!.data!.length;
    }
    final darkTheme = ref.watch(darkThemeProviderProvider);

    String? role = sharedPrefs.getStringNow(KeyShared.keyRole);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: const AppbarWidget(),
          title: AnimatedTextAppBarWidget(
            text: Strings.txtAllNotifications.tr,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(),
          ),
          actions: [
            if (role == "HR" || role == "MANAGER")
              GestureDetector(
                onTap: () {
                  showDateDialog(context, ref);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        IonIcons.ellipsis_vertical,
                        color: darkTheme.darkTheme ? kTextWhiteColor : kBack,
                      ),
                    ],
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  showDateDialogUser(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        IonIcons.ellipsis_vertical,
                        color: darkTheme.darkTheme ? kTextWhiteColor : kBack,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (role == "HR" || role == "MANAGER") ...[
                if (role != "EMPLOYEE") ...[
                  Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFF99A1BE),
                          fontSize: SizeConfig.textMultiplier * 2),
                      text: Strings.txtRequests.tr,
                      children: [
                        TextSpan(
                          text: '($totalLeaveDaysHR ${Strings.txtRequests.tr})',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF23A26D),
                                  fontSize: SizeConfig.textMultiplier * 2),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .scale(duration: 600.ms, alignment: Alignment.centerLeft),
                ],

                notiProvider.getNotificationModel == null
                    ? Expanded(child: Center(child: _buildShimmerItem(context)))
                    : (notiProvider.getNotificationModel?.data?.isEmpty ?? true)
                        ? Center(
                            child: SizedBox.shrink(),
                          )
                        : Expanded(
                            child: SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoadingNoti,
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
                                  itemCount: notiProvider
                                          .getNotificationModel?.data?.length ??
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

                                    return GestureDetector(
                                      onTap: () {
                                        if (data.status == "PENDING") {
                                          widgetBottomSheetFormHR(
                                              context, data);
                                        } else {
                                          widgetBottomSheetREJECTEDandAPPROVED(
                                              context, data);
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color:
                                                Theme.of(context).canvasColor),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: SizeConfig
                                                                .imageSizeMultiplier *
                                                            7,
                                                        backgroundColor: Colors
                                                                .grey[
                                                            200], // optional fallback color
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            data.profile
                                                                .toString(),
                                                            width: 110,
                                                            height: 110,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return const Center(
                                                                child:
                                                                    LoadingPlatformV1(),
                                                              );
                                                            },
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return const Icon(
                                                                  Icons.error,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .red);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: -6,
                                                        bottom: 0,
                                                        child: CircleAvatar(
                                                          radius: SizeConfig
                                                                  .heightMultiplier *
                                                              1.4,
                                                          backgroundColor:
                                                              color,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  data.logo ??
                                                                      '',
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      const LoadingPlatformV1(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 14),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.username ?? '',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          // data.typeName ?? '',
                                                          txt,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  color: const Color(
                                                                      0xFF99A1BE),
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          2),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          'On ${DateFormatUtil.formatDD(DateTime.parse(data.startDate ?? ''))}-${DateFormatUtil.formatddMMy(DateTime.parse(data.endDate ?? ''))}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  color: const Color(
                                                                      0xFF99A1BE),
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          2),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  if (data.status == 'REJECTED')
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .widthMultiplier *
                                                          8.5,
                                                      width: SizeConfig
                                                              .widthMultiplier *
                                                          25,
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
                                                                    .circular(
                                                                        50),
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
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            ),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              Strings
                                                                  .txtRejected
                                                                  .tr,
                                                              style: Theme.of(
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
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium
                                                                  ?.copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
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
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium
                                                                  ?.copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
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
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            ),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              Strings
                                                                  .txtApproved
                                                                  .tr,
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
                                              ),
                                            )
                                          ],
                                        ),
                                      ).animate().scaleXY(
                                          begin: 0,
                                          end: 1,
                                          delay: 300.ms,
                                          duration: 300.ms,
                                          curve: Curves.easeInOutCubic),
                                    );
                                  }),
                            ),
                          ),
                // const SizedBox(height: 20),
                // ],
                // if (role == "EMPLOYEE") ...[
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color(0xFF99A1BE),
                        fontSize: SizeConfig.textMultiplier * 2),
                    text: Strings.txtRequests.tr,
                    children: [
                      TextSpan(
                        text:
                            ' ($totalLeaveDaysUser  ${Strings.txtRequests.tr})',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF23A26D),
                                fontSize: SizeConfig.textMultiplier * 2),
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
                notiProverUser.getallLeaveHistoryModel == null
                    ? Expanded(child: Center(child: _buildShimmerItem(context)))
                    : notiProverUser.getallLeaveHistoryModel!.data!.isEmpty ??
                            true
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/no_noti.svg',
                                    width: 150,
                                    height: 150,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    ' ຍັງບໍ່ມີຂໍ້ມູນ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    2.2),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              controller: _refreshControllerUser,
                              onRefresh: _onRefreshUser,
                              onLoading: _onLoadingUserNoti,
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
                                itemCount: notiProverUser
                                    .getallLeaveHistoryModel!.data!.length,
                                itemBuilder: (context, index) {
                                  final data = notiProverUser
                                      .getallLeaveHistoryModel!.data![index];
                                  var txtSattus = getItemColorAndIcon(
                                      data.keyWord.toString());
                                  String txt = txtSattus['txt'];
                                  var dataStatus = getCheckStatusUser(
                                      data.status.toString());
                                  Color colorStatus = dataStatus['color'];
                                  String txtStatus = dataStatus['txt'];

                                  Color color = txtSattus['color'];
                                  Icon iconStatus = dataStatus['icon'];
                                  if (data == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      widgetBottomSheetUser(context, data);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Theme.of(context).canvasColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Stack(
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: SizeConfig
                                                                        .imageSizeMultiplier *
                                                                    9,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        200], // optional fallback color
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    data.profile
                                                                        .toString(),
                                                                    width: 120,
                                                                    height: 120,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    loadingBuilder:
                                                                        (context,
                                                                            child,
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null)
                                                                        return child;
                                                                      return const Center(
                                                                        child:
                                                                            LoadingPlatformV1(),
                                                                      );
                                                                    },
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return const Icon(
                                                                          Icons
                                                                              .error,
                                                                          size:
                                                                              40,
                                                                          color:
                                                                              Colors.red);
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: -6,
                                                                bottom: 0,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: SizeConfig
                                                                          .heightMultiplier *
                                                                      1.4,
                                                                  backgroundColor:
                                                                      color,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          data.logo ??
                                                                              '',
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          const LoadingPlatformV1(),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              width: 14),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  data.username ??
                                                                      '',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(),
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  // data.typeName ?? '',
                                                                  txt,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                          color: const Color(
                                                                              0xFF99A1BE),
                                                                          fontSize:
                                                                              SizeConfig.textMultiplier * 2),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  'On ${DateFormatUtil.formatDD(DateTime.parse(data.startDate ?? ''))}-${DateFormatUtil.formatddMMy(DateTime.parse(data.endDate ?? ''))}',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                          color: const Color(
                                                                              0xFF99A1BE),
                                                                          fontSize:
                                                                              SizeConfig.textMultiplier * 2),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .heightMultiplier *
                                                          4.5,
                                                      child: OutlinedButton(
                                                        onPressed: () async {
                                                          widgetBottomSheetUser(
                                                              context, data);
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                              color:
                                                                  colorStatus),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          backgroundColor:
                                                              colorStatus,
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            iconStatus,
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              txtStatus
                                                                  .toString(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    color:
                                                                        kTextWhiteColor,
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
                                                                            1.5,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: kGary,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${txtStatus} ${DateFormatUtil.formatddmmyyhhssmm(DateTime.parse(data.updatedAt ?? ''))}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  color: const Color(
                                                                      0xFF99A1BE),
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          1.6),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Bootstrap
                                                                  .check_circle_fill,
                                                              color:
                                                                  colorStatus,
                                                              size: 17,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              txtStatus,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      color:
                                                                          colorStatus,
                                                                      fontSize:
                                                                          SizeConfig.textMultiplier *
                                                                              2),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    if (data.approvedBy !=
                                                            null &&
                                                        data.approvedBy!
                                                            .isNotEmpty)
                                                      Row(
                                                        children: data
                                                            .approvedBy!
                                                            .map<Widget>(
                                                                (approver) {
                                                          final String
                                                              profileUrl =
                                                              approver.profile
                                                                      ?.trim() ??
                                                                  '';
                                                          final bool
                                                              hasValidProfile =
                                                              profileUrl
                                                                      .isNotEmpty &&
                                                                  profileUrl !=
                                                                      "https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg";

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 5),
                                                            child: CircleAvatar(
                                                              radius: SizeConfig
                                                                      .imageSizeMultiplier *
                                                                  6,
                                                              backgroundColor:
                                                                  kTextWhiteColor,
                                                              child: Stack(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius:
                                                                        SizeConfig.imageSizeMultiplier *
                                                                            5.5,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                      hasValidProfile
                                                                          ? profileUrl
                                                                          : 'https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg',
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    right: -6,
                                                                    bottom: -9,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                      child: approver.status ==
                                                                              "REJECTED"
                                                                          ? const Icon(
                                                                              Bootstrap.x_circle_fill,
                                                                              size: 17,
                                                                              color: Color(0xFFCE1126),
                                                                            )
                                                                          : const Icon(
                                                                              AntDesign.check_circle_fill,
                                                                              size: 17,
                                                                              color: Color(0xFF23A26D),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                  if (approver
                                                                          .status ==
                                                                      "REJECTED")
                                                                    Positioned
                                                                        .fill(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .red
                                                                              .withOpacity(0.5),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animate().scaleXY(
                                        begin: 0,
                                        end: 1,
                                        delay: 500.ms,
                                        duration: 500.ms,
                                        curve: Curves.easeInOutCubic),
                                  );
                                },
                              ),
                            ),
                          ),
              ],
              // ],
            )));
  }

  Future<dynamic> widgetBottomSheetUser(
      BuildContext context, dynamic leaveData) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).canvasColor,
        builder: (BuildContext context) {
          var status = getCheckStatusUser(leaveData.status.toString());
          var dataStatus = getItemColorAndIcon(leaveData.status.toString());
          var colorStatus = getItemColorAndIcon(leaveData.keyWord.toString());
          Color colorS = colorStatus['color'];
          Color color = dataStatus['color'];
          String txt = colorStatus['txt'];
          Color colorSta = status['color'];
          String txtStatus = status['txt'];
          return FractionallySizedBox(
              heightFactor: 0.6,
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: kTextWhiteColor,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors
                                      .grey[200], // optional fallback color
                                  child: ClipOval(
                                    child: Image.network(
                                      leaveData.profile.toString(),
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: LoadingPlatformV1(),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error,
                                            size: 40, color: Colors.red);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                leaveData.username.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(),
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
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: SizeConfig.heightMultiplier * 5,
                            child: OutlinedButton(
                              onPressed: () async {},
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colorSta),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  backgroundColor: colorSta),
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
                                    '$txtStatus  ${txt}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    2.2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
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
                                                color: kGreyColor,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        2.2),
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
                                      color: Theme.of(context).cardColor,
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
                                                        .titleMedium!
                                                        .copyWith(
                                                            color: kTextGrey,
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                2.2),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatdm(DateTime.parse(leaveData.endDate.toString()))} ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                2.2),
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
                                                        .titleMedium!
                                                        .copyWith(
                                                            color: kTextGrey,
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                2.2),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      '${leaveData.totalDays.toString()} ${Strings.txtDay}'
                                                          .tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  2.2)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Row(
                                  //       children: [
                                  //         CircleAvatar(
                                  //           radius: 8,
                                  //           backgroundColor: colorSta,
                                  //           child: const Icon(
                                  //             Icons.check,
                                  //             color: kTextWhiteColor,
                                  //             size: 13,
                                  //           ),
                                  //         ),
                                  //         const SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //         // Text(
                                  //         //   '$txtStatus  ${DateFormatUtil.formatddMMy(DateTime.parse(leaveData.createdAt.toString()))} ',
                                  //         //   style: Theme.of(context)
                                  //         //       .textTheme
                                  //         //       .titleMedium!
                                  //         //       .copyWith(
                                  //         //           color: colorSta,
                                  //         //           fontSize: SizeConfig
                                  //         //                   .textMultiplier *
                                  //         //               2),
                                  //         // ),
                                  //       ],
                                  //     ),
                                  //     // Text(
                                  //     //   '  ${DateFormatUtil.formatms(DateTime.parse(leaveData.updatedAt.toString()))} ',
                                  //     //   style: Theme.of(context)
                                  //     //       .textTheme
                                  //     //       .titleMedium!
                                  //     //       .copyWith(
                                  //     //           color: kTextGrey,
                                  //     //           fontSize:
                                  //     //               SizeConfig.textMultiplier *
                                  //     //                   2),
                                  //     // )
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // if (leaveData.comment != null &&
                          //     leaveData.comment.isNotEmpty) ...[
                          //   Text(
                          //     'ເຫດຜົນສໍາລັບການປະຕິເສດ',
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .titleMedium!
                          //         .copyWith(
                          //             fontSize: SizeConfig.textMultiplier * 2),
                          //   ),
                          //   const SizedBox(
                          //     height: 10,
                          //   ),
                          //   Container(
                          //     width: double.infinity,
                          //     decoration: BoxDecoration(
                          //         color: Color(0xFFFCE6E4),
                          //         // color: Theme.of(context).canvasColor,
                          //         borderRadius: BorderRadius.circular(10),
                          //         border: Border.all(color: Color(0xFFCE1126))),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text(
                          //         leaveData.comment.toString(),
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .bodyMedium!
                          //             .copyWith(
                          //                 color: kBack87,
                          //                 fontSize:
                          //                     SizeConfig.textMultiplier * 2.2),
                          //       ),
                          //     ),
                          //   )
                          // ]
                          if (leaveData.approvedBy != null &&
                              leaveData.approvedBy!.isNotEmpty) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...leaveData.approvedBy!.map((approver) {
                                      // Determine status text and color
                                      final statusText =
                                          approver.status == "APPROVED"
                                              ? Strings.txtApproved.tr
                                              : approver.status == "REJECTED"
                                                  ? Strings.txtRejected.tr
                                                  : Strings.txtWaiting.tr;

                                      final statusColor = approver.status ==
                                              "APPROVED"
                                          ? Colors.green
                                          : approver.status == "REJECTED"
                                              ? Colors.red
                                              : Colors
                                                  .orange; // Color for PENDING

                                      final updatedAt = leaveData.updatedAt !=
                                              null
                                          ? DateFormatUtil.formatddMMy(
                                              DateTime.parse(leaveData.updatedAt
                                                  .toString()))
                                          : '';

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Status Indicator
                                                  Row(
                                                    children: [
                                                      if (approver.status ==
                                                              "APPROVED" ||
                                                          approver.status ==
                                                              "REJECTED")
                                                        CircleAvatar(
                                                          radius: SizeConfig
                                                                  .heightMultiplier *
                                                              1.2,
                                                          backgroundColor:
                                                              statusColor,
                                                          child: Icon(
                                                            approver.status ==
                                                                    "APPROVED"
                                                                ? Icons.check
                                                                : Icons.close,
                                                            size: SizeConfig
                                                                    .imageSizeMultiplier *
                                                                4,
                                                            color:
                                                                kTextWhiteColor,
                                                          ),
                                                        ),
                                                      if (approver.status ==
                                                          "PENDING")
                                                        CircleAvatar(
                                                          radius: SizeConfig
                                                                  .heightMultiplier *
                                                              1.2,
                                                          backgroundColor:
                                                              statusColor,
                                                          child: Icon(
                                                            approver.status ==
                                                                    "PENDING"
                                                                ? Icons.check
                                                                : Icons.close,
                                                            size: SizeConfig
                                                                    .imageSizeMultiplier *
                                                                4,
                                                            color:
                                                                kTextWhiteColor,
                                                          ),
                                                        ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        '${approver.status == "PENDING " ? statusText : Strings.txtApprov.tr} $updatedAt',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color:
                                                                    statusColor,
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    2),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        Strings.txtBy.tr,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    2),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      CircleAvatar(
                                                        radius: SizeConfig
                                                                .heightMultiplier *
                                                            2,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          approver.profile
                                                                      ?.isNotEmpty ==
                                                                  true
                                                              ? approver
                                                                  .profile!
                                                              : "https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg",
                                                        ),
                                                        onBackgroundImageError:
                                                            (_, __) =>
                                                                const Icon(Icons
                                                                    .error),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                        ),
                                                        child: Text(
                                                          approver.username ??
                                                              'Unknown',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          2),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(color: kGary),
                                            if ((approver.comment ?? '')
                                                .isNotEmpty) ...[
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: approver.status ==
                                                            "REJECTED"
                                                        ? const Color(
                                                            0xFFFCE6E4)
                                                        : const Color(
                                                            0xFFE4FCE4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: approver.status ==
                                                              "REJECTED"
                                                          ? const Color(
                                                              0xFFCE1126)
                                                          : const Color(
                                                              0xFF4CAF50),
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        approver.comment!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    2,
                                                                color: kBack87),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ]),
                  )));
        });
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
            Bootstrap.x_circle_fill,
            color: Colors.white,
            size: 15,
          ),
        };

      case "PENDING":
        return {
          'color': const Color(0xFFFFCE08),
          'txt': Strings.txtPending.tr,
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

  Map<String, dynamic> getCheckStatusHR(String title) {
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
          'txt': Strings.txtReject.tr,
          'icon': const Icon(
            Bootstrap.x_circle_fill,
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
        builder: (BuildContext context) {
          var dataStatus = getItemColorAndIcon(leaveData.keyWord.toString());
          Color colorStatus = dataStatus['color'];
          String txt = dataStatus['txt'];
          var dataColor = getCheckStatus(leaveData.status.toString());
          var dataText = getCheckStatusHR(leaveData.status.toString());
          Color colorButton = dataColor['color'];
          String txtButton = dataText['txt'];
          return FractionallySizedBox(
              heightFactor: 0.9,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
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
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                                .titleLarge
                                ?.copyWith(color: Color(0XFF99A1BE)),
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
                                  '${Strings.txtYouAreS.tr} ${txtButton.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.2,
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
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: SizeConfig.heightMultiplier * 1.6,
                                      backgroundColor:
                                          colorStatus.withOpacity(0.1),
                                      child: CachedNetworkImage(
                                        imageUrl: leaveData.logo!,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
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
                                                      2),
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
                                        height: SizeConfig.heightMultiplier * 9,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: Theme.of(context).cardColor,
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
                                                              2),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${(leaveData.total != null) ? (leaveData.total! % 1 == 0 ? leaveData.total!.toInt().toString() : leaveData.total!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                                  .tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          2),
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
                                        height: SizeConfig.heightMultiplier * 9,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: Theme.of(context).cardColor,
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
                                                              2),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${(leaveData.used != null) ? (leaveData.used! % 1 == 0 ? leaveData.used!.toInt().toString() : leaveData.used!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                                  .tr,
                                              // leaveData.used.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          2),
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
                                  fontSize: SizeConfig.textMultiplier * 2,
                                ),
                            text: Strings.txtRequestdetails.tr,
                            children: [
                              TextSpan(
                                // text: leaveData.typeName,
                                text: txt,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontSize: SizeConfig.textMultiplier * 2,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF99A1BE)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        CustomTextFieldDesign(
                          prefixIcon: Image.asset(ImagePath.iconCalendar),
                          hintText:
                              '${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatdm(DateTime.parse(leaveData.endDate.toString()))} ',
                        ),
                        const SizedBox(height: 16),
                        if (leaveData.startDate != null &&
                            leaveData.endDate != null &&
                            DateTime(
                                  DateTime.parse(leaveData.startDate!).year,
                                  DateTime.parse(leaveData.startDate!).month,
                                  DateTime.parse(leaveData.startDate!).day,
                                ).compareTo(DateTime(
                                  DateTime.parse(leaveData.endDate!).year,
                                  DateTime.parse(leaveData.endDate!).month,
                                  DateTime.parse(leaveData.endDate!).day,
                                )) ==
                                0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Strings.txtStarttime.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.9,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    CustomTextFieldDesign(
                                      prefixIcon: Image.asset(ImagePath.iconIn),
                                      hintText:
                                          '${DateFormatUtil.formatH(DateTime.parse(leaveData.startDate.toString()))} ',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Strings.txtEndtime.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.9,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    CustomTextFieldDesign(
                                      prefixIcon:
                                          Image.asset(ImagePath.iconOut),
                                      hintText:
                                          '${DateFormatUtil.formatH(DateTime.parse(leaveData.endDate.toString()))} ',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        // Reason
                        Text(
                          Strings.txtReason.tr,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                        ),
                        const SizedBox(height: 8),

                        CustomTextFieldDesign(
                          maxLines: 4,
                          hintText: leaveData.reason ?? '',
                        ),
                        const SizedBox(height: 8),
                        leaveData.document != null &&
                                leaveData.document.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.txtImage.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
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
                                ],
                              )
                            : SizedBox.shrink(),
                        const SizedBox(
                          height: 10,
                        ),
                        if (leaveData.approvedBy != null &&
                            leaveData.approvedBy!.isNotEmpty) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...leaveData.approvedBy!.map((approver) {
                                    final statusText =
                                        approver.status == "APPROVED"
                                            ? Strings.txtApproved.tr
                                            : approver.status == "REJECTED"
                                                ? Strings.txtRejected.tr
                                                : Strings.txtWaiting.tr;

                                    final statusColor =
                                        approver.status == "APPROVED"
                                            ? Colors.green
                                            : approver.status == "REJECTED"
                                                ? Colors.red
                                                : Colors.orange;

                                    final updatedAt = leaveData.updatedAt !=
                                            null
                                        ? DateFormatUtil.formatddMMy(
                                            DateTime.parse(
                                                leaveData.updatedAt.toString()))
                                        : 'N/A';

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Status Indicator
                                                Row(
                                                  children: [
                                                    if (approver.status ==
                                                            "APPROVED" ||
                                                        approver.status ==
                                                            "REJECTED")
                                                      CircleAvatar(
                                                        radius: SizeConfig
                                                                .heightMultiplier *
                                                            1.2,
                                                        backgroundColor:
                                                            statusColor,
                                                        child: Icon(
                                                          approver.status ==
                                                                  "APPROVED"
                                                              ? Icons.check
                                                              : Icons.close,
                                                          size: SizeConfig
                                                                  .imageSizeMultiplier *
                                                              4,
                                                          color:
                                                              kTextWhiteColor,
                                                        ),
                                                      ),
                                                    if (approver.status ==
                                                        "PENDING")
                                                      CircleAvatar(
                                                        radius: SizeConfig
                                                                .heightMultiplier *
                                                            1.2,
                                                        backgroundColor:
                                                            statusColor,
                                                        child: Icon(
                                                          approver.status ==
                                                                  "PENDING"
                                                              ? Icons.check
                                                              : Icons.close,
                                                          size: SizeConfig
                                                                  .imageSizeMultiplier *
                                                              4,
                                                          color:
                                                              kTextWhiteColor,
                                                        ),
                                                      ),
                                                    Text(
                                                      ' ${approver.status == "PENDING" ? Strings.txtApprov.tr : (approver.status == "APPROVED" || approver.status == "REJECTED" ? statusText : "Unknown")} $updatedAt',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color:
                                                                  statusColor,
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.9),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),

                                                Row(
                                                  children: [
                                                    Text(Strings.txtBy.tr,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    2)),
                                                    const SizedBox(width: 5),
                                                    CircleAvatar(
                                                      radius: SizeConfig
                                                              .heightMultiplier *
                                                          2,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        approver.profile
                                                                    ?.isNotEmpty ==
                                                                true
                                                            ? approver.profile!
                                                            : "https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg",
                                                      ),
                                                      onBackgroundImageError:
                                                          (_, __) => const Icon(
                                                              Icons.error),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                      ),
                                                      child: Text(
                                                        approver.username ?? '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    2),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(color: kGary),
                                          if ((approver.comment ?? '')
                                              .isNotEmpty) ...[
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: approver.status ==
                                                          "REJECTED"
                                                      ? const Color(0xFFFCE6E4)
                                                      : const Color(0xFFE4FCE4),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: approver.status ==
                                                            "REJECTED"
                                                        ? const Color(
                                                            0xFFCE1126)
                                                        : const Color(
                                                            0xFF4CAF50),
                                                  )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(approver.comment!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    2,
                                                                color:
                                                                    kBack87)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ]),
                ),
              ));
        });
  }

  Future<dynamic> widgetBottomSheetFormHR(
      BuildContext context, dynamic leaveData) {
    final darkTheme = ref.watch(darkThemeProviderProvider);
    TextEditingController description = TextEditingController();

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          var dataStatus = getItemColorAndIcon(leaveData.keyWord.toString());
          Color colorStatus = dataStatus['color'];
          String txt = dataStatus['txt'];

          return FractionallySizedBox(
              heightFactor: 0.8,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
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
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.textMultiplier * 2),
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
                                    color: Color(0XFF99A1BE),
                                    fontSize: SizeConfig.textMultiplier * 2),
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
                                  final response = await EnterpriseAPIService()
                                      .updateLeaveNoti(
                                          id: leaveData.id,
                                          status: "APPROVED",
                                          comment: "",
                                          token: sharedPrefs
                                              .getStringNow(KeyShared.keyToken))
                                      .whenComplete(() => showDialog(
                                          context: context,
                                          // barrierDismissible: false,
                                          builder: (context) {
                                            return AlertSuccessDialog(
                                              title: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF23A26D)
                                                      .withOpacity(.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Bootstrap.check_circle_fill,
                                                  color:
                                                      const Color(0xFF23A26D),
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
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                2),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    '${leaveData.username}  ${getItemColorAndIcon(leaveData.keyWord.toString())['txt']} ${Strings.txtDayOffOn.tr} ${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatA(DateTime.parse(leaveData.endDate.toString()))} ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                            color: const Color(
                                                                0xFF23A26D),
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                2),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              onTapOK: () async {
                                                context.pop();

                                                // print('🎖️🤾‍♂️${response}');
                                              },
                                            );
                                          }));

                                  Fluttertoast.showToast(
                                    msg:
                                        'ອະນຸມັດ ການຂໍລາພັກ   ${leaveData.username} ສໍາເລັດ',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: kBColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );

                                  await fetchNotificationApi();
                                  context.pop();

                                  print('🎖️🤾‍♂️${response}');
                                  // showDialog(
                                  //     context: context,
                                  //     // barrierDismissible: false,
                                  //     builder: (context) {
                                  //       return AlertSuccessDialog(
                                  //         title: Container(
                                  //           padding: const EdgeInsets.all(10),
                                  //           decoration: BoxDecoration(
                                  //             color: const Color(0xFF23A26D)
                                  //                 .withOpacity(.12),
                                  //             shape: BoxShape.circle,
                                  //           ),
                                  //           child: Icon(
                                  //             Bootstrap.check_circle_fill,
                                  //             color: const Color(0xFF23A26D),
                                  //             size: SizeConfig
                                  //                     .imageSizeMultiplier *
                                  //                 10,
                                  //           ),
                                  //         ),
                                  //         content: Column(
                                  //           mainAxisSize: MainAxisSize.min,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             Text(
                                  //               Strings.txtApprov.tr,
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .titleMedium
                                  //                   ?.copyWith(
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                       fontSize: SizeConfig
                                  //                               .textMultiplier *
                                  //                           2),
                                  //             ),
                                  //             const SizedBox(height: 20),
                                  //             Text(
                                  //               '${leaveData.username}  ${getItemColorAndIcon(leaveData.keyWord.toString())['txt']} ${Strings.txtDayOffOn.tr} ${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatA(DateTime.parse(leaveData.endDate.toString()))} ',
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .bodyLarge
                                  //                   ?.copyWith(
                                  //                       color:
                                  //                           Color(0xFF23A26D),
                                  //                       fontSize: SizeConfig
                                  //                               .textMultiplier *
                                  //                           2),
                                  //               textAlign: TextAlign.center,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         onTapOK: () async {
                                  //           // final response =
                                  //           //     await EnterpriseAPIService()
                                  //           //         .updateLeaveNoti(
                                  //           //             id: leaveData.id,
                                  //           //             status: "APPROVED",
                                  //           //             comment: "",
                                  //           //             token: sharedPrefs
                                  //           //                 .getStringNow(
                                  //           //                     KeyShared
                                  //           //                         .keyToken))
                                  //           //         .whenComplete(
                                  //           //             () => context.pop());
                                  //           // if (response['data'] ==
                                  //           //     "You have already approved this leave") {
                                  //           //   Fluttertoast.showToast(
                                  //           //     msg:
                                  //           //         'ອະນຸມັດ    ${leaveData.username}  ໄປແລ້ວ',
                                  //           //     toastLength: Toast.LENGTH_SHORT,
                                  //           //     gravity: ToastGravity.CENTER,
                                  //           //     timeInSecForIosWeb: 1,
                                  //           //     backgroundColor: kYellowColor,
                                  //           //     textColor: Colors.white,
                                  //           //     fontSize: 16.0,
                                  //           //   );
                                  //           // } else {
                                  //           //   Fluttertoast.showToast(
                                  //           //     msg:
                                  //           //         'ອະນຸມັດ ການຂໍລາພັກ   ${leaveData.username} ສໍາເລັດ',
                                  //           //     toastLength: Toast.LENGTH_SHORT,
                                  //           //     gravity: ToastGravity.CENTER,
                                  //           //     timeInSecForIosWeb: 1,
                                  //           //     backgroundColor: kBColor,
                                  //           //     textColor: Colors.white,
                                  //           //     fontSize: 16.0,
                                  //           //   );
                                  //           // }
                                  //           // await fetchNotificationApi();
                                  //           // context.pop();

                                  //           // print('🎖️🤾‍♂️${response}');
                                  //         },
                                  //       );
                                  //     });
                                },
                                style: OutlinedButton.styleFrom(
                                  // side: const BorderSide(
                                  //     color: kYellowFirstColor),
                                  side: BorderSide(
                                    color: darkTheme.darkTheme
                                        ? kBack
                                        : kYellowColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  backgroundColor: darkTheme.darkTheme
                                      ? kBack
                                      : kYellowColor,
                                ),
                                child: Text(Strings.txtApprov.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 2)),
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
                                        insetPadding: const EdgeInsets.all(40),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.widthMultiplier * 5,
                                            vertical:
                                                SizeConfig.widthMultiplier * 2,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF6563)
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
                                                          2.3,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  Strings.txtReason.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            2.2,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TextField(
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  controller: description,
                                                  maxLines: 3,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        const Color(0xFFFCE6E4),
                                                    hintText: Strings
                                                        .txtPLeaseEnter.tr,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: kRedColor,
                                                              width: 0.6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xFFFCE6E4)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                height: 50,
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        kYellowFirstColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final response =
                                                        await EnterpriseAPIService()
                                                            .updateLeaveNoti(
                                                                id: leaveData
                                                                    .id,
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
                                                              2.2,
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
                                  side: BorderSide(
                                    color:
                                        darkTheme.darkTheme ? kBack87 : kGary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  backgroundColor: darkTheme.darkTheme
                                      ? kGreyBGColor.withAlpha(50)
                                      : kGary,
                                ),
                                child: Text(
                                  Strings.txtReject.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2),
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
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: SizeConfig.heightMultiplier * 1.6,
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
                                          errorWidget: (context, url, error) =>
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
                                                      2),
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
                                        height: SizeConfig.heightMultiplier * 9,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: Theme.of(context).cardColor,
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
                                                              2),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${(leaveData.total != null) ? (leaveData.total! % 1 == 0 ? leaveData.total!.toInt().toString() : leaveData.total!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                                  .tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          2),
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
                                        height: SizeConfig.heightMultiplier * 9,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: Theme.of(context).cardColor,
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
                                                              2),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${(leaveData.used != null) ? (leaveData.used! % 1 == 0 ? leaveData.used!.toInt().toString() : leaveData.used!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                                  .tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          2),
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
                                text: txt,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontSize: SizeConfig.textMultiplier * 2,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF99A1BE)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextFieldDesign(
                          prefixIcon: Image.asset(ImagePath.iconCalendar),
                          hintText:
                              '${DateFormatUtil.formatDD(DateTime.parse(leaveData.startDate.toString()))} - ${DateFormatUtil.formatdm(DateTime.parse(leaveData.endDate.toString()))} ',
                        ),

                        const SizedBox(height: 16),
                        if (leaveData.startDate != null &&
                            leaveData.endDate != null &&
                            DateTime(
                                  DateTime.parse(leaveData.startDate!).year,
                                  DateTime.parse(leaveData.startDate!).month,
                                  DateTime.parse(leaveData.startDate!).day,
                                ).compareTo(DateTime(
                                  DateTime.parse(leaveData.endDate!).year,
                                  DateTime.parse(leaveData.endDate!).month,
                                  DateTime.parse(leaveData.endDate!).day,
                                )) ==
                                0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Strings.txtStarttime.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.9,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    CustomTextFieldDesign(
                                      prefixIcon: Image.asset(ImagePath.iconIn),
                                      hintText:
                                          '${DateFormatUtil.formatH(DateTime.parse(leaveData.startDate.toString()))} ',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Strings.txtEndtime.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.9,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    CustomTextFieldDesign(
                                      prefixIcon:
                                          Image.asset(ImagePath.iconOut),
                                      hintText:
                                          '${DateFormatUtil.formatH(DateTime.parse(leaveData.endDate.toString()))} ',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        // Reason
                        Text(
                          Strings.txtReason.tr,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextFieldDesign(
                          maxLines: 4,
                          hintText: leaveData.reason ?? '',
                        ),

                        const SizedBox(height: 8),

                        leaveData.document != null &&
                                leaveData.document.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.txtImage.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
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
                                ],
                              )
                            : SizedBox.shrink()
                      ]),
                ),
              ));
        });
  }
}

Map<String, dynamic> getItemColorAndIcon(String keywrd) {
  switch (keywrd) {
    case "ANNUAL":
      return {'color': Color(0xFF3085FE), 'txt': Strings.txtAnnual.tr};
    case "LAKIT":
      return {'color': Color(0xFFF45B69), 'txt': Strings.txtLakit.tr};
    case "SICK":
      return {'color': Color(0xFF23A26D), 'txt': Strings.txtSick.tr};
    case "MATERNITY":
      return {'color': Color(0xFFF59E0B), 'txt': Strings.txtMaternity.tr};

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

Widget _buildShimmerItem(BuildContext context) {
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
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
