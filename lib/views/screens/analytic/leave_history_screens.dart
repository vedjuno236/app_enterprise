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
import 'package:enterprise/views/widgets/text_input/custom_text_filed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:widgets_easier/widgets_easier.dart';
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
                    borderRadius: BorderRadius.circular(12)
                    // shape: BoxShape.circle,
                    ),
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
    // if (dataAPI.getallLeaveHistoryModel?.data != null) {
    //   totalLeaveDays = dataAPI.getallLeaveHistoryModel!.data!
    //       .where((item) => item.status == "APPROVED")
    //       .fold(0, (sum, item) => sum + (item.totalDays ?? 0));
    // }

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
                color: Theme.of(context).canvasColor,
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
                color: Theme.of(context).canvasColor,
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
                          print(
                              'Tapped index: $index, status: ${item['status']}');
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

                              return GestureDetector(
                                onTap: () {
                                  widgetBottomSheetREJECTEDandAPPROVED(
                                      context, data);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
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
                                                radius: SizeConfig
                                                        .heightMultiplier *
                                                    2.2,
                                                backgroundColor:
                                                    color.withOpacity(0.10),
                                                child: CachedNetworkImage(
                                                  imageUrl: data.logo ?? '',
                                                  placeholder: (context, url) =>
                                                      LoadingPlatformV1(),
                                                  errorWidget: (context, url,
                                                          error) =>
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
                                                      color: Theme.of(context)
                                                          .primaryColorLight,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                // color: kGary,
                                                // ),
                                                color: Theme.of(context)
                                                    .cardColor),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        Strings
                                                            .txtTotalLeave.tr,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: const Color(
                                                                    0xFF979797)),
                                                      ),
                                                      Text(
                                                        // '${data.totalDays ?? 0} ${Strings.txtDay.tr}',
                                                        '${(data.totalDays != null) ? (data.totalDays! % 1 == 0 ? data.totalDays!.toInt().toString() : data.totalDays!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                                            .tr,
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
                                                    backgroundColor:
                                                        colorStatus,
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
                                    ),
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

Future<dynamic> widgetBottomSheetREJECTEDandAPPROVED(
    BuildContext context, dynamic leaveData) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).canvasColor,
      builder: (BuildContext context) {
        return FractionallySizedBox(
            heightFactor: 0.5,
            // initialChildSize: 0.6,
            // minChildSize: 0.3,
            // maxChildSize: 0.6,
            // builder: (context, scrollController) {
            // var dataStatus =
            //     getItemColorAndIcon(leaveData.keyWord.toString());
            // Color colorStatus = dataStatus['color'];
            // String txt = dataStatus['txt'];
            // var dataColor = getCheckStatus(leaveData.status.toString());
            // var dataText = getCheckStatusUser(leaveData.status.toString());
            // Color colorButton = dataColor['color'];
            // String txtButton = dataText['txt'];

            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                // controller: scrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                Strings.txtLeaveHistory.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text.rich(
                        TextSpan(
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
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
                                      fontSize: SizeConfig.textMultiplier * 1.9,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              prefixIcon: Image.asset(ImagePath.iconIn),
                              hintText:
                                  '${DateFormatUtil.formatms(DateTime.parse(leaveData.startDate.toString()))} ',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              prefixIcon: Image.asset(ImagePath.iconOut),
                              hintText:
                                  '${DateFormatUtil.formatms(DateTime.parse(leaveData.endDate.toString()))} ',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Strings.txtReason.tr,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 1.9,
                            ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
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
                                const SizedBox(height: 8),
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
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 10,
                      ),
                      if (leaveData.approvedBy != null &&
                          leaveData.approvedBy!.isNotEmpty) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: kTextWhiteColor,
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
                                          : Colors.orange; // Color for PENDING

                                  final updatedAt = leaveData.updatedAt != null
                                      ? DateFormatUtil.formatddMMy(
                                          DateTime.parse(
                                              leaveData.updatedAt.toString()))
                                      : 'N/A';

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                      color: kTextWhiteColor,
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
                                                      color: kTextWhiteColor,
                                                    ),
                                                  ),
                                                Text(
                                                  ' ${approver.status == "PENDING" ? Strings.txtApprov.tr : (approver.status == "APPROVED" || approver.status == "REJECTED" ? statusText : "Unknown")} $updatedAt',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: statusColor),
                                                ),
                                              ],
                                            ),

                                            // Approver Info
                                            Row(
                                              children: [
                                                Text(Strings.txtBy.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall),
                                                const SizedBox(width: 5),
                                                CircleAvatar(
                                                  radius: SizeConfig
                                                          .heightMultiplier *
                                                      2,
                                                  backgroundImage: NetworkImage(
                                                    approver.profile
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? approver.profile!
                                                        : "https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg",
                                                  ),
                                                  onBackgroundImageError: (_,
                                                          __) =>
                                                      const Icon(Icons.error),
                                                ),
                                                const SizedBox(width: 5),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                  ),
                                                  child: Text(
                                                    approver.username ??
                                                        'Unknown',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(color: kBack),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
                                                      ? const Color(0xFFCE1126)
                                                      : const Color(0xFF4CAF50),
                                                )),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    approver.comment!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
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
                      ]
                    ]),
              ),
            ));
      });
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
