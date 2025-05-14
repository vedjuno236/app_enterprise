import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_history_provider/leave_histoy_provider.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_onLeave_provider/leave_onleave_provider.dart';
import 'package:enterprise/components/poviders/notifition_provider/notifition_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/date_month_year/shared/month_picker.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/logger/logger.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';

class OnLeaveScreen extends ConsumerStatefulWidget {
  const OnLeaveScreen({super.key});

  @override
  ConsumerState createState() => _OnLeaveScreenWidgetState();
}

class _OnLeaveScreenWidgetState extends ConsumerState<OnLeaveScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<void> _onRefresh() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  bool isLoading = false;
  SharedPrefs sharedPrefs = SharedPrefs();

  late DateTime now;
  late String today;
  late String todayStart;
  late String todayEnd;
  late String tomorrowStart;
  late String tomorrowEnd;
  late String thisWeekStart;
  late String thisWeekEnd;
  late String nextWeekStartStr;
  late String nextWeekEndStr;
  late String afterNextWeekStartStr;
  late String afterNextWeekEndStr;
  late String nextMonthStartStr;
  late String nextMonthEndStr;
  late List<Map<String, String>> categories;
  String EndDate = '';
  String StartDate = '';
  Future fetchNotificationApi({required startDate, required endDate}) async {
    setState(() {
      isLoading = true;
      StartDate = startDate;
      EndDate = endDate;
    });

    EnterpriseAPIService()
        .callNotification(
      token: sharedPrefs.getStringNow(KeyShared.keyToken),
      start_date: startDate,
      end_date: endDate,
    )
        .then((value) {
      ref.watch(onLeaveProvider).setNotificationModel(value: value);
      logger.d(value);
    }).catchError((onError) {
      errorDialog(
        context: context,
        onError: onError,
      );
    }).whenComplete(() => setState(() {
              isLoading = false;
            }));
  }

  @override
  void initState() {
    super.initState();
    initializeDates();
    final initialIndex = ref.read(onLeaveProvider).selectedIndexleave;
    final startDate = categories[initialIndex]['startDate']!;
    final endDate = categories[initialIndex]['endDate']!;
    fetchNotificationApi(startDate: startDate, endDate: endDate);
  }

  @override
  void dispose() {
    // ref.read(onLeaveProvider.notifier).resetSelectedMonth();
    super.dispose();
  }

  void initializeDates() {
    now = DateTime.now();
    today = DateFormat('yyyy-MM-dd').format(now);

    // Today
    todayStart = today;
    todayEnd = today;

    // Tomorrow
    final tomorrowDate = now.add(const Duration(days: 1));
    final tomorrow = DateFormat('yyyy-MM-dd').format(tomorrowDate);
    tomorrowStart = tomorrow;
    tomorrowEnd = tomorrow;

    // This week
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfWeek =
        now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    thisWeekStart = DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
    thisWeekEnd = DateFormat('yyyy-MM-dd').format(lastDayOfWeek);

    // Next week
    final nextWeekStart = firstDayOfWeek.add(const Duration(days: 7));
    final nextWeekEnd = lastDayOfWeek.add(const Duration(days: 7));
    nextWeekStartStr = DateFormat('yyyy-MM-dd').format(nextWeekStart);
    nextWeekEndStr = DateFormat('yyyy-MM-dd').format(nextWeekEnd);

    // After Next Week
    final afterNextWeekStart = nextWeekStart.add(const Duration(days: 7));
    final afterNextWeekEnd = nextWeekEnd.add(const Duration(days: 7));
    afterNextWeekStartStr = DateFormat('yyyy-MM-dd').format(afterNextWeekStart);
    afterNextWeekEndStr = DateFormat('yyyy-MM-dd').format(afterNextWeekEnd);

    // Next Month
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    final nextMonthEnd = DateTime(now.year, now.month + 2, 0); //
    nextMonthStartStr = DateFormat('yyyy-MM-dd').format(nextMonthStart);
    nextMonthEndStr = DateFormat('yyyy-MM-dd').format(nextMonthEnd);

    categories = [
      {
        'label': Strings.txtToday.tr,
        'startDate': todayStart,
        'endDate': todayEnd
      },
      {
        'label': Strings.txtTomorrow.tr,
        'startDate': tomorrowStart,
        'endDate': tomorrowEnd
      },
      {
        'label': Strings.txtThisWeek.tr,
        'startDate': thisWeekStart,
        'endDate': thisWeekEnd
      },
      {
        'label': Strings.txtNextWeek.tr,
        'startDate': nextWeekStartStr,
        'endDate': nextWeekEndStr
      },
      {
        'label': Strings.txtAfterNextWeek.tr,
        'startDate': afterNextWeekStartStr,
        'endDate': afterNextWeekEndStr
      },
      {
        'label': Strings.txtNextMonth.tr,
        'startDate': nextMonthStartStr,
        'endDate': nextMonthEndStr
      },
    ];
  }

  Future showDateDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final dateProvider = ref.read(onLeaveProvider);
    DateTime initialDate = dateProvider.selectedMonth ?? DateTime.now();
    DateTime? selectedMonth = DateTime.now();
    DateTime now = DateTime.now();
    DateTime maxDate = DateTime(now.year, now.month + 1, 0);

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
              selectedCellTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: kBack87),
              enabledCellsTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: kBack87),
              enabledCellsDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Color(0xFFEDEFF7)),
              ),
              disabledCellsTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xFFE4E4E7)),
              disabledCellsDecoration: BoxDecoration(
                color: Colors.white,
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
                if (selectedMonth != null) {
                  final provider = ref.read(onLeaveProvider.notifier);
                  provider.selectedMonth = selectedMonth;

                  fetchNotificationApi(
                    startDate:
                        DateFormat('yyyy-MM-dd').format(provider.startDate),
                    endDate: DateFormat('yyyy-MM-dd').format(provider.endDate),
                  );
                  provider.clearSelectedIndex();
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

  Widget build(BuildContext context) {
    final leaveHistoryNotifier = ref.watch(onLeaveProvider);
    final selectedIndex = leaveHistoryNotifier.selectedIndexleave;
    final dataAPI = ref.watch(onLeaveProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: const AppbarWidget(),
          title: AnimatedTextAppBarWidget(
            text: Strings.txtAllLeave.tr,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            Text(leaveHistoryNotifier.selectedMonth == null
                ? ''
                : leaveHistoryNotifier.selectedMonthText),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize Column height
                children: [
                  GestureDetector(
                      onTap: () {
                        showDateDialog(context, ref);
                      },
                      child: CircleAvatar(
                          radius: 20,
                          backgroundColor: kTextWhiteColor,
                          child: Image.asset(ImagePath.iconAnalytic))),
                ],
              ).animate().scaleXY(
                  begin: 0,
                  end: 1,
                  delay: 300.ms,
                  duration: 300.ms,
                  curve: Curves.easeInOutCubic),
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(categories.length, (index) {
                        final item = categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(onLeaveProvider.notifier)
                                  .updateSelectedIndexOnleave(index);
                              fetchNotificationApi(
                                  startDate: item['startDate'],
                                  endDate: item['endDate']);
                            },
                            child: Container(
                              // width: SizeConfig.widthMultiplier * 25,
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? kYellowColor
                                    : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  item['label']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.7,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  dataAPI.getNotificationModel == null
                      ? Expanded(child: Center(child: _buildShimmerItem()))
                      : dataAPI.getNotificationModel!.data!.isEmpty
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
                                    builder: (BuildContext context,
                                        LoadStatus? mode) {
                                      Widget body;
                                      if (mode == LoadStatus.idle) {
                                        body = const Text(Strings.txtPull);
                                      } else if (mode == LoadStatus.loading) {
                                        body = const LoadingPlatformV1(
                                          color: kYellowColor,
                                        );
                                      } else if (mode == LoadStatus.failed) {
                                        body =
                                            const Text(Strings.txtLoadFailed);
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
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
                                      padding: EdgeInsets.zero,
                                      itemCount: dataAPI.getNotificationModel
                                              ?.data?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final data = dataAPI
                                            .getNotificationModel?.data?[index];
                                        if (data == null) {
                                          return const SizedBox.shrink();
                                        }

                                        var dataColor = getItemColorAndTxt(
                                            data.keyWord.toString());
                                        Color color = dataColor['color'];
                                        String txt = dataColor['txt'];

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  width: 1.0),
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: SizeConfig
                                                                    .heightMultiplier *
                                                                2,
                                                            backgroundColor:
                                                                color
                                                                    .withOpacity(
                                                                        0.1),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  data.logo ??
                                                                      '',
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      LoadingPlatformV1(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                              color: color,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 20),
                                                          Text(
                                                            // data.typeName
                                                            txt.toString(),
                                                            style:
                                                                Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleLarge!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          SizeConfig.textMultiplier *
                                                                              2,
                                                                    ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 30,
                                                                backgroundColor:
                                                                    kTextWhiteColor,
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      kGary,
                                                                  radius: 27,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: data
                                                                        .profile
                                                                        .toString(),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            const LoadingPlatformV1(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            CircleAvatar(
                                                                      backgroundImage:
                                                                          imageProvider,
                                                                      radius:
                                                                          27,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    data.username
                                                                        .toString(),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleLarge!
                                                                        .copyWith(
                                                                          fontSize:
                                                                              SizeConfig.textMultiplier * 1.9,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    data.departmentName
                                                                        .toString()
                                                                        .toString(),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                            color:
                                                                                const Color(0xFF99A1BE)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          const Divider(
                                                            height: 0.5,
                                                            color: kGreyColor1,
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
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
                                                                    Strings
                                                                        .txtLeaveDate
                                                                        .tr,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                          color:
                                                                              kTextGrey,
                                                                        ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    '${DateFormatUtil.formatDD(DateTime.parse(data.startDate ?? ''))}-${DateFormatUtil.formatddMMy(DateTime.parse(data.endDate ?? ''))} ',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                          fontSize:
                                                                              SizeConfig.textMultiplier * 2,
                                                                          color:
                                                                              kBlueColor,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    Strings
                                                                        .txtTotalLeave
                                                                        .tr,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                          color:
                                                                              kTextGrey,
                                                                        ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    '${(data.totalDays != null) ? (data.totalDays! % 1 == 0 ? data.totalDays!.toInt().toString() : data.totalDays!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                                                        .tr,
                                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                        fontSize:
                                                                            SizeConfig.textMultiplier *
                                                                                2,
                                                                        color: double.parse(data.totalDays.toString().split(' ')[0]) >
                                                                                3
                                                                            ? kRedColor
                                                                            : kBlueColor,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })))
                ])));
  }

  Map<String, dynamic> getItemColorAndTxt(String keywrd) {
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

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: SingleChildScrollView(
        child: Column(children: [
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
                    borderRadius: BorderRadius.circular(10), // <-- And here too
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
