import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_history_provider/leave_histoy_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:enterprise/views/widgets/text_input/custom_text_filed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../../../components/models/analytic_model/leave_type_model.dart';

class AmlsLeaveScreens extends ConsumerStatefulWidget {
  final Data data;
  const AmlsLeaveScreens({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AmlsLeaveScreensState();
}

class _AmlsLeaveScreensState extends ConsumerState<AmlsLeaveScreens> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isLoadingLeave = false;
  SharedPrefs sharedPrefs = SharedPrefs();
  int userID = int.parse(SharedPrefs().getStringNow(KeyShared.keyUserId));
  Future fetchAllLeaveApi() async {
    setState(() {
      isLoadingLeave = true;
    });

    EnterpriseAPIService()
        .callAllLeaveHistory(
            UserId: userID, LeaveTypeID: widget.data.id, Status: '')
        .then((value) {
      ref.watch(leaveHistoryProvider).setallLeaveHistoryModel(value: value);
      logger.d(value);
    }).catchError((onError) {
      errorDialog(
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
  }

  Widget build(BuildContext context) {
    final dataAPI = ref.watch(leaveHistoryProvider);

    int totalLeaveDays = 0;
    // if (dataAPI.getallLeaveHistoryModel != null &&
    //     dataAPI.getallLeaveHistoryModel!.data != null) {
    //   totalLeaveDays = dataAPI.getallLeaveHistoryModel!.data!
    //       .fold(0, (sum, item) => sum + (item.totalDays ?? item.totalDays!));
    // }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: getItemColor(widget.data.keyWord.toString())['txt'],
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Builder(builder: (context) {
          if (dataAPI.getallLeaveHistoryModel == null) {
            return _buildShimmerItem();
          }

          if (dataAPI.getallLeaveHistoryModel!.data!.isEmpty) {
            return Center(child: Image.asset(ImagePath.imgIconCreateAcc));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Theme.of(context).canvasColor,
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
                          radius: SizeConfig.imageSizeMultiplier * 5,
                          backgroundColor: getItemColor(
                                  widget.data.keyWord.toString())['color']
                              .withOpacity(0.1),
                          child: CachedNetworkImage(
                              imageUrl: widget.data.logo.toString(),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      LoadingPlatformV1(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              color: getItemColor(
                                  widget.data.keyWord.toString())['color']),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getItemColor(
                                  widget.data.keyWord.toString())['txt'],
                              // widget.data.typeName.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Available Leave Section
                        Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: kBColor,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: SizeConfig.heightMultiplier * 0.8,
                                      backgroundColor: kBColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      Strings.txtAvailables.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.7),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${(widget.data.total != null) ? (widget.data.total! % 1 == 0 ? widget.data.total!.toInt().toString() : widget.data.total!.toStringAsFixed(1)) : '-'} '
                                      .tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Used Leave Section
                        Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Theme.of(context).canvasColor,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: SizeConfig.heightMultiplier * 0.7,
                                      backgroundColor: kPinkColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      Strings.txtLeaveUsed.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.7),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${(widget.data.used != null) ? (widget.data.used! % 1 == 0 ? widget.data.used!.toInt().toString() : widget.data.used!.toStringAsFixed(1)) : '-'} '
                                      .tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms).move(
                    begin: const Offset(-16, 0),
                    curve: Curves.easeOutQuad,
                  ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${Strings.txtHistory.tr}  (${totalLeaveDays.toString()} ${Strings.txtdays.tr})  ',
                style: Theme.of(context).textTheme.titleMedium,
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms).move(
                    begin: const Offset(-50, 0),
                    curve: Curves.easeOutQuad,
                  ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: dataAPI.getallLeaveHistoryModel == null
                    ? Center(child: _buildShimmerItem())
                    : dataAPI.getallLeaveHistoryModel!.data!.isEmpty
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

                                  var dataColor =
                                      getItemColor(data.keyWord.toString());

                                  Color color = dataColor['color'];
                                  String txt = dataColor['txt'];
                                  var dataStatus =
                                      getCheckStatus(data.status.toString());
                                  Color colorStatus = dataStatus['color'];
                                  String txtStatus = dataStatus['txt'];
                                  String? formattedDate;

                                  if ((data.status == "APPROVED" ||
                                          data.status == "REJECTED") &&
                                      data.updatedAt != null) {
                                    formattedDate = DateFormat("d MMM yyyy")
                                        .format(
                                            DateTime.parse(data.updatedAt!));
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        widgetBottomSheetREJECTEDandAPPROVED(
                                            context, data);
                                      },
                                      child: Container(
                                        height:
                                            SizeConfig.heightMultiplier * 23,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: data.logo!,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    color: color,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    DateFormatUtil.formatA(
                                                        DateTime.parse(data
                                                            .startDate
                                                            .toString())),

                                                    // data.typeName.toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color:
                                                              Color(0xFF37474F),
                                                        ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    9,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    children: [
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
                                                                        color: const Color(
                                                                            0xFF979797)),
                                                              ),
                                                              Text(
                                                                  '${DateFormatUtil.formatDD(DateTime.parse(data.startDate.toString()))} - ${DateFormatUtil.formatdm(
                                                                    DateTime.parse(data
                                                                        .endDate
                                                                        .toString()),
                                                                  )}',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleLarge!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            SizeConfig.textMultiplier *
                                                                                1.9,
                                                                      )),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
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
                                                                        color: const Color(
                                                                            0xFF979797)),
                                                              ),
                                                              Text(
                                                                  '${(data.totalDays != null) ? (data.totalDays! % 1 == 0 ? data.totalDays!.toInt().toString() : data.totalDays!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                                                      .tr,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleLarge!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            SizeConfig.textMultiplier *
                                                                                1.9,
                                                                      )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: SizeConfig
                                                                  .heightMultiplier *
                                                              1,
                                                          backgroundColor:
                                                              colorStatus,
                                                          child: Icon(
                                                            Icons.check,
                                                            size: SizeConfig
                                                                    .imageSizeMultiplier *
                                                                3,
                                                            color:
                                                                kTextWhiteColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Text(
                                                          formattedDate != null
                                                              ? '$txtStatus  $formattedDate'
                                                              : txtStatus,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
                                                                            1.5,
                                                                    color:
                                                                        colorStatus,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),

                                                    // )
                                                    if (data.approvedBy !=
                                                            null &&
                                                        data.approvedBy!
                                                            .isNotEmpty) ...[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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

                                                          return Align(
                                                            widthFactor: 0.5,
                                                            child: CircleAvatar(
                                                              radius: SizeConfig
                                                                      .imageSizeMultiplier *
                                                                  5,
                                                              backgroundColor:
                                                                  kTextWhiteColor,
                                                              child: Stack(
                                                                children: [
                                                                  hasValidProfile
                                                                      ? CircleAvatar(
                                                                          radius:
                                                                              SizeConfig.imageSizeMultiplier * 4.3,
                                                                          backgroundImage:
                                                                              NetworkImage(profileUrl),
                                                                        )
                                                                      : const CircleAvatar(
                                                                          radius:
                                                                              20,
                                                                          backgroundImage:
                                                                              NetworkImage(
                                                                            'https://kpl.gov.la/Media/Upload/News/Thumb/2023/04/20/200423--600--111.jpg',
                                                                          ),
                                                                        ),
                                                                  if (txtStatus ==
                                                                      'Rejected')
                                                                    Positioned
                                                                        .fill(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .red
                                                                              .withOpacity(0.3),
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
                                                      )
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          .animate()
                                          .fadeIn(
                                              duration: 500.ms, delay: 500.ms)
                                          .move(
                                            begin: const Offset(-50, 0),
                                            curve: Curves.easeOutQuad,
                                          ),
                                    ),
                                  );
                                }),
                          ),
              )
            ],
          );
        }),
      ),
    );
  }

  Future<dynamic> widgetBottomSheetREJECTEDandAPPROVED(
      BuildContext context, dynamic leaveData) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).canvasColor,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.7,
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
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
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
                                            : Colors
                                                .orange; // Color for PENDING

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
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${approver.status == "PENDING " ? statusText : Strings.txtApprov.tr} $updatedAt',
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
                                                    backgroundImage:
                                                        NetworkImage(
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
                                                          .copyWith(
                                                              color: kBack),
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

Map<String, dynamic> getCheckStatus(String title) {
  switch (title) {
    case "APPROVED":
      return {
        'color': const Color(0xFF23A26D),
        'txt': Strings.txtApproved.tr,
      };
    case "REJECTED":
      return {
        'color': const Color(0xFFF45B69),
        'txt': Strings.txtRejected.tr,
      };

    case "PENDING":
      return {
        'color': const Color(0xFFF59E0B),
        'txt': Strings.txtWaiting.tr,
      };

    default:
      return {
        'color': Colors.blueAccent,
      };
  }
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
