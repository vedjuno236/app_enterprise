import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/mock/mock.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_provider.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/custom_date_range_picker/custom_date_range_picker.dart';
import 'package:enterprise/views/widgets/text_input/custom_text_filed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/logger/logger.dart';
import '../../../components/poviders/requestOT_provider/form_controller_providert/request_provider.dart';
import '../../../components/poviders/requestOT_provider/request_OT_provider.dart';
import '../../../components/router/router.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/styles/size_config.dart';

class RequestOtScreens extends ConsumerStatefulWidget {
  const RequestOtScreens({super.key});

  @override
  ConsumerState createState() => _RequestOtScreensState();
}

class _RequestOtScreensState extends ConsumerState<RequestOtScreens> {
  Future fetchLeaveTypeApi() async {
    EnterpriseAPIService().callLeaveType().then((value) {
      ref.watch(stateLeaveProvider).setLeaveTypeModels(value: value);
      logger.d(value);
    });
  }

  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
    bool _checkTime = false;
  @override
  void initState() {
    super.initState();
    fetchLeaveTypeApi();
  }

  @override
  Widget build(BuildContext context) {
   

    final OTTypeProvider = ref.watch(stateLeaveProvider);

    final otProvider = ref.watch(stateRequestOTProvider);
    final requestOTNotifier = ref.read(RequestOTNotifierProvider.notifier);
    final color = otProvider.selectedOtType != null
        ? getItemColor(otProvider.selectedOtType!)['color'] as Color
        : Colors.blueAccent;
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FC),
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: requestOTNotifier.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.txtSelectOT.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 15))
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms)
                    .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                //
                OTTypeProvider.getLeaveTypeModel == null
                    ? Shimmer.fromColors(
                        baseColor: kGreyColor1,
                        highlightColor: kGary,
                        child: Container(
                          height: SizeConfig.heightMultiplier * 6,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kTextWhiteColor,
                            border: Border.all(color: kYellowColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      )
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: kTextWhiteColor,
                          border: Border.all(color: kYellowColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                ref
                                        .read(stateRequestOTProvider.notifier)
                                        .isDropdownOpen =
                                    !otProvider.isDropdownOpen;
                              },
                              child: Container(
                                height: SizeConfig.heightMultiplier * 6,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    otProvider.selectedOtType != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: OTTypeProvider
                                                      .getLeaveTypeModel!.data!
                                                      .firstWhere((e) =>
                                                          e.keyWord ==
                                                          otProvider
                                                              .selectedOtType)
                                                      .logo!,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      const CupertinoActivityIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  color: color,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  OTTypeProvider
                                                      .getLeaveTypeModel!.data!
                                                      .firstWhere((e) =>
                                                          e.keyWord ==
                                                          otProvider
                                                              .selectedOtType)
                                                      .typeName!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(fontSize: 18),
                                                ),
                                                const SizedBox(width: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      OTTypeProvider
                                                          .getLeaveTypeModel!
                                                          .data!
                                                          .firstWhere((e) =>
                                                              e.keyWord ==
                                                              otProvider
                                                                  .selectedOtType)
                                                          .used
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.9,
                                                              color: kRedColor),
                                                    ),
                                                    Text('/'),
                                                    Text(
                                                      OTTypeProvider
                                                          .getLeaveTypeModel!
                                                          .data!
                                                          .firstWhere((e) =>
                                                              e.keyWord ==
                                                              otProvider
                                                                  .selectedOtType)
                                                          .total
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.9,
                                                              color: const Color(
                                                                  0xFF23A26D)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        : Text(Strings.txtSelectLeave.tr),
                                    Icon(otProvider.isDropdownOpen
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            if (otProvider.isDropdownOpen)
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 800),
                                transitionBuilder: (widget, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, -0.5),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    )),
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: SizeTransition(
                                        sizeFactor: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOut,
                                        ),
                                        child: widget,
                                      ),
                                    ),
                                  );
                                },
                                child: ConstrainedBox(
                                  key: ValueKey(otProvider.isDropdownOpen),
                                  constraints: const BoxConstraints(
                                    maxHeight: 300,
                                  ),
                                  child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: OTTypeProvider
                                        .getLeaveTypeModel!.data!.length,
                                    itemBuilder: (context, index) {
                                      final data = OTTypeProvider
                                          .getLeaveTypeModel!.data![index];
                                      var dataColor =
                                          getItemColor(data.keyWord.toString());
                                      Color color = dataColor['color'];

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ref.read(stateRequestOTProvider
                                                  .notifier)
                                                ..selectedOtType = data.keyWord
                                                ..isDropdownOpen = false;
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: data.logo!,
                                                          width: 24,
                                                          height: 24,
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  const CupertinoActivityIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                          color: color,
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          data.typeName!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
                                                                            1.9,
                                                                  ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          (data.used != null)
                                                              ? (data.used! %
                                                                          1 ==
                                                                      0
                                                                  ? data.used!
                                                                      .toInt()
                                                                      .toString()
                                                                  : data.used!
                                                                      .toStringAsFixed(
                                                                          1))
                                                              : '-',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
                                                                            1.9,
                                                                    color:
                                                                        kRedColor,
                                                                  ),
                                                        ),
                                                        Text(
                                                          '/',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        SizeConfig.textMultiplier *
                                                                            1.9,
                                                                  ),
                                                        ),
                                                        Text(
                                                          (data.total != null)
                                                              ? (data.total! %
                                                                          1 ==
                                                                      0
                                                                  ? data.total!
                                                                      .toInt()
                                                                      .toString()
                                                                  : data.total!
                                                                      .toStringAsFixed(
                                                                          1))
                                                              : '-',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          1.9,
                                                                  color: const Color(
                                                                      0xFF23A26D)),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: otProvider
                                                                    .selectedOtType ==
                                                                data.keyWord
                                                            ? kYellowColor
                                                            : kGary,
                                                      ),
                                                      child: Icon(
                                                        Icons.check,
                                                        color: otProvider
                                                                    .selectedOtType ==
                                                                data.keyWord
                                                            ? Colors.black
                                                            : Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Divider(color: kGary),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                SizedBox(height: SizeConfig.heightMultiplier * 3),
                Text(Strings.txtSelectDateOT.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 15))
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms)
                    .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                InkWell(
                  onTap: () {
                    showCustomDateRangePicker(
                      context,
                      dismissible: true,
                      minimumDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      maximumDate: DateTime.now().add(const Duration(days: 30)),
                      endDate: endDate,
                      startDate: startDate,
                      backgroundColor: Colors.white,
                      primaryColor: const Color(0xFF283050),
                      onApplyClick: (start, end) {
                        setState(() {
                          endDate = end;
                          startDate = start;
                        });
                        logger.d('start =${startDate}');
                        logger.d('end = ${endDate}');
                        final duration = endDate!.difference(startDate!).inDays;
                        logger.d('Total${duration}');
                        ;
                      },
                      onCancelClick: () {
                        setState(() {
                          endDate = null;
                          startDate = null;
                        });
                      },
                    );
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      hintText: startDate != null && endDate != null
                          ? '${DateFormat("dd, MMMM", 'lo').format(startDate!)} '
                          : Strings.txtSelectDateNew.tr,
                      prefixIcon: Image.asset(ImagePath.iconCalendar),
                      suffixIcon: const Icon(
                        Icons.arrow_right,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return Strings.txtPleaseEnterInformation.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms)
                    .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                Text(Strings.txtSelectTimeOT.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 15)),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                  Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (Platform.isAndroid) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Center(
                                                      child: Text(
                                                        'ເລືອກເວລາເລີ່ມຕົ້ນ',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        icon: const Icon(
                                                            Icons.close))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      30,
                                                  child: Localizations.override(
                                                    context: context,
                                                    locale: const Locale('en'),
                                                    child: CupertinoTheme(
                                                      data: CupertinoTheme.of(
                                                          context),
                                                      child:
                                                          CupertinoDatePicker(
                                                        initialDateTime:
                                                            startTime,
                                                        use24hFormat: true,
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .time,
                                                        onDateTimeChanged:
                                                            (DateTime newTime) {
                                                          startTime = newTime;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .widthMultiplier *
                                                          50,
                                                      child: OutlinedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _checkTime = true;

                                                            if (startDate !=
                                                                    null &&
                                                                startTime !=
                                                                    null) {
                                                              startDate = DateTime(
                                                                  startDate!
                                                                      .year,
                                                                  startDate!
                                                                      .month,
                                                                  startDate!
                                                                      .day,
                                                                  startTime!
                                                                      .hour,
                                                                  startTime!
                                                                      .minute,
                                                                  startTime!
                                                                      .second);
                                                            } else {
                                                              DateTime
                                                                  currentTime =
                                                                  DateTime
                                                                      .now();
                                                              startDate =
                                                                  DateTime(
                                                                startDate!.year,
                                                                startDate!
                                                                    .month,
                                                                startDate!.day,
                                                                currentTime
                                                                    .hour,
                                                                currentTime
                                                                    .minute,
                                                                currentTime
                                                                    .second,
                                                              );
                                                            }

                                                            final formattedDate =
                                                                DateFormat(
                                                                        'yyyy-MM-dd HH:mm:ss')
                                                                    .format(
                                                                        startDate!);
                                                            final formattedTime =
                                                                DateFormat(
                                                                        'HH:mm')
                                                                    .format(
                                                                        startDate!);
                                                            requestOTNotifier
                                                                    .startTimeController
                                                                    .text =
                                                                formattedTime;
                                                            logger.d(
                                                                formattedDate);
                                                          });

                                                          Navigator.pop(
                                                              context);
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
                                                                    kYellowColor),
                                                        child: Text(
                                                          Strings.txtConfirm.tr,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          2,
                                                                  color:
                                                                      kTextWhiteColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else if (Platform.isIOS) {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoActionSheet(
                                            actions: [
                                              SizedBox(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    20,
                                                child: Localizations.override(
                                                  context: context,
                                                  locale: const Locale('en'),
                                                  child: CupertinoDatePicker(
                                                    initialDateTime: startTime,
                                                    use24hFormat: true,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    onDateTimeChanged:
                                                        (DateTime newTime) {
                                                      startTime = newTime;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              CupertinoActionSheetAction(
                                                onPressed: () {
                                                  setState(() {
                                                    _checkTime = true;

                                                    if (startDate != null &&
                                                        startTime != null) {
                                                      startDate = DateTime(
                                                          startDate!.year,
                                                          startDate!.month,
                                                          startDate!.day,
                                                          startTime!.hour,
                                                          startTime!.minute,
                                                          startTime!.second);
                                                    } else {
                                                      DateTime currentTime =
                                                          DateTime.now();
                                                      startDate = DateTime(
                                                        startDate!.year,
                                                        startDate!.month,
                                                        startDate!.day,
                                                        currentTime.hour,
                                                        currentTime.minute,
                                                        currentTime.second,
                                                      );
                                                    }

                                                    final formattedDate =
                                                        DateFormat(
                                                                'yyyy-MM-dd HH:mm:ss')
                                                            .format(startDate!);
                                                    final formattedTime =
                                                        DateFormat('HH:mm')
                                                            .format(startDate!);
                                                    requestOTNotifier
                                                        .startTimeController
                                                        .text = formattedTime;
                                                    logger.d(formattedDate);
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  Strings.txtConfirm,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontSize: SizeConfig
                                                                  .textMultiplier *
                                                              2,
                                                          color: kBlueColor),
                                                ),
                                              ),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              isDestructiveAction: true,
                                              onPressed: () {
                                                setState(() {
                                                  startTime = null;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                Strings.txtCancel,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            2,
                                                        color: kRedColor),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      hintText: startTime != null
                                          ? '${DateFormat(
                                              "HH:mm",
                                            ).format(startTime!)} '
                                          : Strings.txtStrTime.tr,
                                      suffixIcon: Image.asset(ImagePath.iconIn),
                                      validator: (value) => null,
                                      hintStyle: startTime != null
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: Color(0xFF37474F))
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: kGreyColor2),
                                      controller:
                                          requestOTNotifier.startTimeController,
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 500.ms)
                                      .move(
                                          begin: Offset(-16, 0),
                                          curve: Curves.easeOutQuad),
                                ),
                              ),
                              SizedBox(width: SizeConfig.widthMultiplier * 4),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (Platform.isAndroid) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Center(
                                                      child: Text(
                                                        'ເລືອກເວລາສີ້ນສຸດ',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        icon: const Icon(
                                                            Icons.close))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      30,
                                                  child: Localizations.override(
                                                    context: context,
                                                    locale: const Locale('en'),
                                                    child: CupertinoTheme(
                                                      data: CupertinoTheme.of(
                                                          context),
                                                      child:
                                                          CupertinoDatePicker(
                                                        minimumDate: startTime,
                                                        initialDateTime:
                                                            startTime ??
                                                                endTime,
                                                        use24hFormat: true,
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .time,
                                                        onDateTimeChanged:
                                                            (DateTime newTime) {
                                                          endTime = newTime;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .widthMultiplier *
                                                          50,
                                                      child: OutlinedButton(
                                                        onPressed: () {
                                                          if (!_checkTime) {
                                                            Fluttertoast.showToast(
                                                                msg: Strings
                                                                    .txtSelectLeaveStart
                                                                    .tr,
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    kYellowColor,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 20.0);
                                                            context.pop();
                                                            return;
                                                          }

                                                          if (endDate != null &&
                                                              endTime != null) {
                                                            endDate = DateTime(
                                                                endDate!.year,
                                                                endDate!.month,
                                                                endDate!.day,
                                                                endTime!.hour,
                                                                endTime!.minute,
                                                                endTime!
                                                                    .second);
                                                          } else {
                                                            DateTime
                                                                currentTime =
                                                                DateTime.now();
                                                            endDate = DateTime(
                                                              endDate!.year,
                                                              endDate!.month,
                                                              endDate!.day,
                                                              currentTime.hour,
                                                              currentTime
                                                                  .minute,
                                                              currentTime
                                                                  .second,
                                                            );
                                                          }
                                                          final formattedDate =
                                                              DateFormat(
                                                                      'yyyy-MM-dd HH:mm:ss')
                                                                  .format(
                                                                      startDate!);
                                                          final formattedTime =
                                                              DateFormat(
                                                                      'HH:mm')
                                                                  .format(
                                                                      startDate!);
                                                          requestOTNotifier
                                                              .endTimeController
                                                              .text = formattedTime;
                                                          logger
                                                              .d(formattedDate);
                                                          Navigator.pop(
                                                              context);
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
                                                                    kYellowColor),
                                                        child: Text(
                                                          Strings.txtConfirm.tr,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .textMultiplier *
                                                                          2,
                                                                  color:
                                                                      kTextWhiteColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoActionSheet(
                                            actions: [
                                              SizedBox(
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    20,
                                                child: Localizations.override(
                                                  context: context,
                                                  locale: const Locale('en'),
                                                  child: CupertinoDatePicker(
                                                    minimumDate: startTime,
                                                    initialDateTime: endTime ??
                                                        DateTime.now(),
                                                    use24hFormat: true,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    onDateTimeChanged:
                                                        (DateTime newTime) {
                                                      endTime = newTime;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              CupertinoActionSheetAction(
                                                onPressed: () {
                                                  if (!_checkTime) {
                                                    Fluttertoast.showToast(
                                                        msg: Strings
                                                            .txtSelectLeaveStart
                                                            .tr,
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            kYellowColor,
                                                        textColor: Colors.white,
                                                        fontSize: 20.0);
                                                    context.pop();
                                                    return;
                                                  }

                                                  if (endDate != null &&
                                                      endTime != null) {
                                                    endDate = DateTime(
                                                        endDate!.year,
                                                        endDate!.month,
                                                        endDate!.day,
                                                        endTime!.hour,
                                                        endTime!.minute,
                                                        endTime!.second);
                                                  } else {
                                                    DateTime currentTime =
                                                        DateTime.now();
                                                    endDate = DateTime(
                                                      endDate!.year,
                                                      endDate!.month,
                                                      endDate!.day,
                                                      currentTime.hour,
                                                      currentTime.minute,
                                                      currentTime.second,
                                                    );
                                                  }
                                                  final formattedDate = DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss')
                                                      .format(endDate!);
                                                  final formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(endDate!);
                                                  requestOTNotifier
                                                      .endTimeController
                                                      .text = formattedTime;
                                                  logger.d(formattedDate);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  Strings.txtConfirm,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontSize: SizeConfig
                                                                  .textMultiplier *
                                                              2,
                                                          color: kBlueColor),
                                                ),
                                              ),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              isDestructiveAction: true,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                Strings.txtCancel,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            2,
                                                        color: kRedColor),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      hintText: endTime != null
                                          ? '${DateFormat(
                                              "HH:mm:ss",
                                            ).format(endTime!)} '
                                          : Strings.txtEndTime.tr,
                                      suffixIcon: Image.asset(ImagePath.iconIn),
                                      validator: (value) => null,
                                      hintStyle: endTime != null
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: Color(0xFF37474F))
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: kGreyColor2),
                                      controller:
                                          requestOTNotifier.endTimeController,
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 500.ms)
                                      .move(
                                          begin: Offset(-16, 0),
                                          curve: Curves.easeOutQuad),
                                ),
                              ),
                            ],
                          ),
                      
                      
                      
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                Text(Strings.txtReasonOT.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 15)),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                CustomTextField(
                  controller: requestOTNotifier.noteController,
                  maxLines: 7,
                  hintText: Strings.txtPLeaseEnter.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms)
                    .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () async {},
          child: Container(
            width: SizeConfig.widthMultiplier * 100,
            height: SizeConfig.heightMultiplier * 6,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: leaveState.isValid ? kYellowFirstColor : kGary,
              color: kYellowFirstColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                Strings.txtSubmitForm.tr,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(),
              ),
            ),
          ),
        ),
      ).animate().scaleXY(
          begin: 0,
          end: 1,
          delay: 800.ms,
          duration: 800.ms,
          curve: Curves.easeInOutCubic),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: kBack),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: const AppbarWidget(),
      title: AnimatedTextAppBarWidget(
        text: Strings.txtRequestOt.tr,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            context.push(PageName.requestOtHistoryScreen);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                CircleAvatar(
                    backgroundColor: kTextWhiteColor,
                    radius: 16,
                    child: Image.asset(ImagePath.requestOT)),
                Expanded(
                  child: Text(
                    Strings.txtHistory,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: SizeConfig.textMultiplier *
                            1.5), // Reduce font size if necessary
                  ),
                ),
              ],
            ),
          )
              .animate()
              .slideY(duration: 900.ms, curve: Curves.easeOutCubic)
              .fadeIn(),
        ),
      ],
    );
  }

  Map<String, dynamic> getItemColor(String title) {
    switch (title) {
      case "ANNUAL":
        return {
          'color': Color(0xFF3085FE),
        };
      case "LAKIT":
        return {
          'color': Color(0xFFF45B69),
        };
      case "SICK":
        return {
          'color': Color(0xFFF59E0B),
        };
      case "MATERNITY":
        return {
          'color': Color(0xFF23A26D),
        };

      default:
        return {
          'color': Colors.blueAccent,
        };
    }
  }
}
