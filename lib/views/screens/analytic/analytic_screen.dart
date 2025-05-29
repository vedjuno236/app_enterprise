import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/key_shared.dart';
import '../../../components/constants/strings.dart';
import '../../../components/helpers/shared_prefs.dart';
import '../../../components/poviders/analytic_provider/analytic_provider.dart';
import '../../../components/poviders/leave_provider/leave_provider.dart';
import '../../../components/poviders/users_provider/users_provider.dart';
import '../../../components/router/router.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/utils/date_format_utils.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/chart_widgte/chart_widget.dart';
import '../../widgets/date_month_year/shared/month_picker.dart';

class AnalyticScreen extends ConsumerStatefulWidget {
  const AnalyticScreen({super.key});

  @override
  AnalyticScreenState createState() => AnalyticScreenState();
}

class AnalyticScreenState extends ConsumerState<AnalyticScreen> {
  DateTime selectedYear = DateTime.now();
  DateTime selectedMonth = DateTime.now();
  int perPage = 7;

  SharedPrefs sharedPrefs = SharedPrefs();
  bool isloadingLeave = false;
  bool isloadinUser = false;
  bool isLoading = false;
  bool cancelled = false;
  int userID = int.parse(SharedPrefs().getStringNow(KeyShared.keyUserId));

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
        })
        .catchError((onError) {})
        .whenComplete(() {
          setState(() {
            isloadingLeave = false;
          });
        });
  }

  Future fetchAnalyticAttendanceApi() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    final userProvider = ref.watch(stateUserProvider);
    final currentPage = ref.watch(stateAnalyticProvider).currentPageIndex;
    String formattedDate = DateFormat('yyyy-MM').format(selectedMonth);
    EnterpriseAPIService()
        .callAnalyticAttendance(
      userID: userProvider.getUserModel!.data!.id ?? 0,
      month: formattedDate,
      perPage: perPage,
      currentPage: currentPage,
    )
        .then((value) {
      if (!cancelled) {
        ref.read(stateAnalyticProvider).setAnalyticModel(value: value);
      }

      // logger.d(value);
    }).catchError((onError) {
      debugPrint("onError fetchNews $onError");
      if (onError.runtimeType.toString() == 'DioError') {
        // errorDialogMsg(context: context, onError: onError);
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  bool isConnectedInternet = false;
  StreamSubscription? _streamSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      ref.read(stateAnalyticProvider).selectedMonth = DateTime.now();
      fetchLeaveTypeApi();
      fetchAnalyticAttendanceApi();
    });
  }

  @override
  void initState() {
    super.initState();

    // ref.read(stateAnalyticProvider.notifier).resetPage();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaveType = ref.watch(stateLeaveProvider);
    final analyticState = ref.watch(stateAnalyticProvider);

    Future showDateDialog(
      BuildContext context,
      WidgetRef ref,
    ) async {
      final dateProvider = ref.read(stateAnalyticProvider);
      DateTime initialDate = dateProvider.selectedMonth ?? DateTime.now();

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
                    borderRadius: BorderRadius.circular(12)
                    // shape: BoxShape.circle,
                    ),
                selectedCellTextStyle:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: kBack87,
                        ),
                enabledCellsTextStyle:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(),
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
                  backgroundColor:
                      darkTheme.darkTheme ? kGreyBGColor.withAlpha(50) : kGary,
                ),
                child: Text(
                  Strings.txtCancel.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: SizeConfig.textMultiplier * 2),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: darkTheme.darkTheme ? kBack : kYellowColor,
                ),
                onPressed: () {
                  ref.read(stateAnalyticProvider.notifier).selectedMonth =
                      selectedMonth;
                  fetchAnalyticAttendanceApi();
                  context.pop();
                },
                child: Text(
                  Strings.txtOkay.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: SizeConfig.textMultiplier * 2),
                ),
              ),
            ],
          );
        },
      );
    }

    final darkTheme = ref.watch(darkThemeProviderProvider);
    darkTheme.darkTheme
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const AppbarWidget(),
        backgroundColor: Colors.transparent,
        title: Text(
          Strings.txtAttendanceOverview.tr,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: SizeConfig.textMultiplier * 2.3),
          textAlign: TextAlign.left,
        )
            .animate()
            .slideY(duration: 900.ms, curve: Curves.easeOutCubic)
            .fadeIn(),
        centerTitle: false,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              context.push(
                PageName.attendanceHistoryRoute,
                extra: selectedMonth,
              );
              // logger.d(DateFormat('yyyy-M-dd HH:mm:ss').format(selectedMonth));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                Strings.txtSeeAll.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 2.3),
              )
                  .animate()
                  .slideY(duration: 900.ms, curve: Curves.easeOutCubic)
                  .fadeIn(),
            ),
          ),
        ],
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Builder(builder: (context) {
          if (analyticState.getOverviewAttendanceMonthModel == null) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.txtNotOnTime.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: kTextGrey),
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 500.ms)
                                    .move(
                                        begin: Offset(-16, 0),
                                        curve: Curves.easeOutQuad),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 1),
                                Text(
                                  '${analyticState.getOverviewAttendanceMonthModel!.data!.items!.first.totalLate ?? 0} ${Strings.txtTimes.tr}', // Assuming you want the first item's total late
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 500.ms)
                                    .move(
                                        begin: Offset(-16, 0),
                                        curve: Curves.easeOutQuad),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              showDateDialog(context, ref);
                              ref
                                  .read(stateAnalyticProvider.notifier)
                                  .resetPage();
                            },
                            style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: kYellowFirstColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: kYellowFirstColor),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ref
                                      .watch(stateAnalyticProvider)
                                      .selectedMonthText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2),
                                ),
                                const Icon(Icons.keyboard_arrow_down_sharp),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: const Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                        ],
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      Container(
                        height: SizeConfig.heightMultiplier * 43,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildHeader(context)
                                  .animate()
                                  .fadeIn(duration: 500.ms, delay: 500.ms)
                                  .move(
                                      begin: Offset(-16, 0),
                                      curve: Curves.easeOutQuad),
                              SizedBox(height: SizeConfig.heightMultiplier * 1),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        context.push(
                                          PageName.attendanceHistoryRoute,
                                          extra: selectedMonth,
                                        );
                                      },
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: analyticState
                                                .getOverviewAttendanceMonthModel
                                                ?.data
                                                ?.items
                                                ?.length ??
                                            0,
                                        itemBuilder: (context, userIndex) {
                                          final userItem = analyticState
                                              .getOverviewAttendanceMonthModel!
                                              .data!
                                              .items![userIndex];

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                userItem.attendance?.length ??
                                                    0,
                                            itemBuilder:
                                                (context, attendanceIndex) {
                                              final attendanceItem = userItem
                                                  .attendance![attendanceIndex];

                                              String formatDate(
                                                  String? dateString) {
                                                if (dateString == null ||
                                                    dateString.isEmpty) {
                                                  return '-';
                                                }

                                                try {
                                                  if (dateString.length <= 8) {
                                                    dateString =
                                                        '${DateTime.now().toIso8601String().substring(0, 10)}T$dateString';
                                                  }

                                                  DateTime parsedDate =
                                                      DateTime.parse(
                                                          dateString);
                                                  return DateFormat('HH:mm')
                                                      .format(parsedDate);
                                                } catch (e) {
                                                  return dateString.toString();
                                                }
                                              }

                                              String format(
                                                  String? dateString) {
                                                if (dateString == null ||
                                                    dateString.isEmpty) {
                                                  return '-';
                                                }

                                                try {
                                                  DateTime parsedDate =
                                                      DateTime.parse(
                                                          dateString);
                                                  DateTime now = DateTime.now();

                                                  if (parsedDate.year ==
                                                          now.year &&
                                                      parsedDate.month ==
                                                          now.month &&
                                                      parsedDate.day ==
                                                          now.day) {
                                                    return Strings.txtToday.tr;
                                                  }

                                                  return DateFormatUtil
                                                      .formatDM(parsedDate);
                                                } catch (e) {
                                                  return dateString;
                                                }
                                              }

                                              bool isValidDate() {
                                                try {
                                                  if (attendanceItem.date ==
                                                          null ||
                                                      attendanceItem
                                                          .date!.isEmpty) {
                                                    return false;
                                                  }

                                                  DateTime attendanceDate =
                                                      DateTime.parse(
                                                          attendanceItem.date!);
                                                  DateTime now = DateTime.now();

                                                  return attendanceDate
                                                      .isBefore(now.add(
                                                          const Duration(
                                                              days: 0)));
                                                } catch (e) {
                                                  return false;
                                                }
                                              }

                                              if (!isValidDate()) {
                                                return const SizedBox.shrink();
                                              }

                                              bool isLate =
                                                  attendanceItem.statusLate ==
                                                      false;

                                              logger.d(isLate);

                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            format(
                                                                attendanceItem
                                                                    .date),
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
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              formatDate(
                                                                  attendanceItem
                                                                      .clockIn),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          SizeConfig.textMultiplier *
                                                                              2,
                                                                      color: isLate
                                                                          ? Theme.of(context)
                                                                              .primaryColorLight
                                                                          : kRedLightColor),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              formatDate(
                                                                  attendanceItem
                                                                      .clockOut),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
                                                                            2,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                                  .animate()
                                                  .fadeIn(
                                                      duration: 500.ms,
                                                      delay: 500.ms)
                                                  .move(
                                                      begin:
                                                          const Offset(-16, 0),
                                                      curve:
                                                          Curves.easeOutQuad);
                                            },
                                          );
                                        },
                                      )))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: kTextGrey,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.arrow_back_ios_rounded),
                                  onPressed: () {
                                    if (analyticState.currentPageIndex > 1) {
                                      analyticState.currentPageIndex--;
                                      fetchAnalyticAttendanceApi();
                                    }
                                  },
                                ),
                                Text(
                                  'W ${analyticState.currentPageIndex}',
                                  style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.8,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    final totalPages = (analyticState
                                            .getOverviewAttendanceMonthModel
                                            ?.data
                                            ?.totalPages ??
                                        0);

                                    if (analyticState.currentPageIndex <
                                        totalPages - 0) {
                                      analyticState.currentPageIndex++;
                                      fetchAnalyticAttendanceApi();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.txtRemainingLeaves.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 2.4),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  TextButton(
                    onPressed: () {
                      context.push(
                        PageName.all_leave_screens,
                      );
                    },
                    child: Text(
                      Strings.txtSeeAll.tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: SizeConfig.textMultiplier * 2.4),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemCount: leaveType.getLeaveTypeModel?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final data = leaveType.getLeaveTypeModel?.data?[index];

                  var dataColor = getItemColor(leaveType
                      .getLeaveTypeModel!.data![index].keyWord
                      .toString());
                  Color color = dataColor['color'];
                  String txt = dataColor['txt'];
                  if (data == null) {
                    return Shimmer.fromColors(
                      baseColor: kGreyColor1,
                      highlightColor: kGary,
                      child: Container(
                        width: SizeConfig.widthMultiplier * 20,
                        height: SizeConfig.heightMultiplier * 1,
                        decoration: BoxDecoration(
                          color: kTextWhiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }
                  return Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Theme.of(context).canvasColor,
                    child: InkWell(
                      onTap: () {
                        context.push(
                          PageName.AmlsLeaveScreens,
                          extra: data,
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: SizeConfig.imageSizeMultiplier * 4,
                          // ignore: deprecated_member_use
                          backgroundColor: color.withOpacity(0.1),
                          child: CachedNetworkImage(
                            imageUrl: data.logo!,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const LoadingPlatformV1(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            color: color,
                          ),
                        ),
                        title: Text(
                          txt,
                          // data.typeName!.toLowerCase(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                        ),
                        subtitle: Text(
                          '${(data.unUsed != null) ? (data.unUsed! % 1 == 0 ? data.unUsed!.toInt().toString() : data.unUsed!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                              .tr,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    color: color,
                                  ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 500.ms)
                        .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                        .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  );
                },
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.txtLeaveHistory.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 2.4),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(PageName.leaveHistoryScreen);
                    },
                    child: Text(
                      Strings.txtSeeAll.tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: SizeConfig.textMultiplier * 2.4),
                    ),
                  ),
                ],
              ),
              Container(
                  height: SizeConfig.heightMultiplier * 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.txtYouTakeLeaves.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color(0xFF979797),
                                      fontSize:
                                          SizeConfig.textMultiplier * 2.4),
                            ),

                            // OutlinedButton(
                            //   onPressed: () async {
                            //     // showDateDialog(context, ref);
                            //   },
                            //   style: OutlinedButton.styleFrom(
                            //     side:
                            //         const BorderSide(color: kYellowFirstColor),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         ref
                            //             .watch(stateAnalyticProvider)
                            //             .selectedYearText,
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .titleLarge!
                            //             .copyWith(
                            //                 fontSize:
                            //                     SizeConfig.textMultiplier * 2),
                            //       ),
                            //       const Icon(Icons.keyboard_arrow_down_sharp)
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        const Expanded(child: PieChartWidget())
                      ],
                    ),
                  ))
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date column header
          Row(
            children: [
              SvgPicture.asset(
                ImagePath.svgCalender,
                width: SizeConfig.imageSizeMultiplier * 5,
                height: SizeConfig.imageSizeMultiplier * 6.5,
                fit: BoxFit.contain,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              Text(
                Strings.txtDayS.tr,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.2,
                    ),
              ),
            ],
          ),

          // Check-in column header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImagePath.svgIn,
                width: SizeConfig.imageSizeMultiplier * 5,
                height: SizeConfig.imageSizeMultiplier * 5,
                fit: BoxFit.contain,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              Text(
                Strings.txtIn.tr,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.2,
                    ),
              ),
            ],
          ),

          // Check-out column header
          Row(
            children: [
              SvgPicture.asset(
                ImagePath.svgOut,
                width: SizeConfig.imageSizeMultiplier * 5,
                height: SizeConfig.imageSizeMultiplier * 5,
                fit: BoxFit.contain,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              Text(
                Strings.txtOut.tr,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.2,
                    ),
              ),
            ],
          ),
        ],
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
}
