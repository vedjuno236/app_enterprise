import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/users_provider/users_provider.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/app_dialog/alerts_dialog.dart';
import 'package:enterprise/views/widgets/custom_date_range_picker/custom_date_range_picker.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_login.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/poviders/leave_provider/leave_provider.dart';
import '../../../components/poviders/leave_provider/leaves_provider.dart';
import '../../../components/router/router.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/bottom_sheet_push/bottom_sheet_push.dart';
import '../../widgets/text_input/custom_text_filed.dart';

enum AppState {
  free,
  picked,
}

class LeaveScreens extends ConsumerStatefulWidget {
  const LeaveScreens({super.key});

  @override
  ConsumerState createState() => _LeaveScreensState();
}

class _LeaveScreensState extends ConsumerState<LeaveScreens> {
  bool isLoadingLeave = false;
  XFile? _imageFile;
  Future fetchLeaveTypeApi() async {
    final userProvider = ref.watch(stateUserProvider);
    setState(() {
      isLoadingLeave = true;
    });
    EnterpriseAPIService()
        .callLeaveType(
      userID: userProvider.getUserModel!.data!.id ?? 0,
    )
        .then((value) {
      ref.watch(stateLeaveProvider).setLeaveTypeModels(value: value);
      logger.d(value);
    }).catchError((onError) {
      errorDialog(
        context: context,
        onError: onError,
      );
      // logger.e(DioExceptions.fromDioError(onError));
    }).whenComplete(() => setState(() {
              isLoadingLeave = false;
            }));
  }

  bool isLoading = false;

  bool _checkTime = false;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    // final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLeaveTypeApi();
    });
    // leaveNotifier.startTimeController.clear();
    // leaveNotifier.endTimeController.clear();
    // leaveNotifier.accordingController.clear();
  }

  @override
  void dispose() {
    _imageFile;
    super.dispose();
  }

  Future<void> submitForm(WidgetRef ref) async {
    final userProvider = ref.watch(stateUserProvider);
    final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
    final leaveProvider = ref.watch(stateLeaveProvider);

    // Check if a leave type is selected
    if (leaveProvider.selectedLeaveType == null) {
      // Fluttertoast.showToast(
      //   msg: Strings.txtSelectLeave.tr,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: kRedColor,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );

      return;
    }

    final selectedLeaveType = leaveProvider.getLeaveTypeModel!.data!
        .firstWhereOrNull((e) => e.keyWord == leaveProvider.selectedLeaveType);

    if (selectedLeaveType == null) {
      // Fluttertoast.showToast(
      //   msg: Strings.txtSelectLeave.tr,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: kRedColor,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );

      return;
    }

    final String imagePath = _imageFile != null ? _imageFile!.path : "";
    final DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');

    try {
      final response = await EnterpriseAPIService().createLeave(
        userID: userProvider.getUserModel!.data!.id ?? 0,
        leaveTypeId: selectedLeaveType.id,
        startDate: format.format(startDate!),
        endDate: format.format(endDate!),
        note: leaveNotifier.accordingController.text ?? '',
        document: imagePath,
      );
      if (response['data'] == "Insufficient leave balance") {
        setState(() {
          isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (context) {
              return AlertSuccessDialog(
                title: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6563).withOpacity(.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Bootstrap.exclamation_circle_fill,
                    color: Color(0xFFFF6563),
                    size: SizeConfig.imageSizeMultiplier * 13,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ບໍ່ສາມາດລາພັກໄດ້'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ວັນລາພັກຂອງທ່ານບໍ່ພຽງພໍ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onTapOK: () {
                  context.pop();
                },
              );
            });
      }
      // ignore: use_build_context_synchronously
      alertSuccessDialog(context);
    } on DioException catch (e) {
      final dioException = DioExceptions.fromDioError(e);
      logger.e("Error during leave: ${dioException.toString()}");
      // ignore: use_build_context_synchronously
      errorDialog(context: context, onError: e);
    } catch (e) {
      logger.e("Error leave: $e");
      // ignore: use_build_context_synchronously
      errorDialog(context: context, onError: e);
    }
  }

  Future<void> alertSuccessDialog(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertSuccessDialog(
            title: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF23A26D).withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Bootstrap.check_circle_fill,
                color: Color(0xFF23A26D),
                size: SizeConfig.imageSizeMultiplier * 13,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.txtSuccessFully.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  Strings.txtYourformhavesubmittedand.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Color(0xFF474747)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onTapOK: () {
              context.pop();
              context.pop();
              context.push(PageName.leaveHistoryScreen);
            },
          );
        });
  }

  bool _validate = false;

  AppState state = AppState.free;
  @override
  Widget build(BuildContext context) {
    final leaveTypeProvider = ref.watch(stateLeaveProvider);
    final leaveProvider = ref.watch(stateLeaveProvider);
    final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
    final color = leaveProvider.selectedLeaveType != null
        ? getItemColor(leaveProvider.selectedLeaveType!)['color'] as Color
        : Colors.blueAccent;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtLeave.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.push(PageName.leaveHistoryScreen);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    backgroundColor: kTextWhiteColor,
                    radius: 16,
                    child: Icon(
                      IonIcons.time,
                      color: kBack,
                    ),
                  ),
                  // Add some spacing
                  Expanded(
                    child: Text(
                      Strings.txtHistory.tr,
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
      ),
      body: CustomProgressHUD(
        key: UniqueKey(),
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: leaveNotifier.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(Strings.txtTypeLeave.tr,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontSize: SizeConfig.textMultiplier * 1.9,
                              ))
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  SizedBox(height: SizeConfig.heightMultiplier * 1),
                  leaveProvider.getLeaveTypeModel == null
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
                            color: Theme.of(context).canvasColor,
                            border: Border.all(color: kYellowColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  ref
                                          .read(stateLeaveProvider.notifier)
                                          .isDropdownOpen =
                                      !leaveProvider.isDropdownOpen;
                                },
                                child: Container(
                                  height: SizeConfig.heightMultiplier * 6,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      leaveProvider.selectedLeaveType != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 19),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: SizeConfig
                                                            .heightMultiplier *
                                                        2,
                                                    backgroundColor:
                                                        color.withOpacity(0.1),
                                                    child: CachedNetworkImage(
                                                      imageUrl: leaveTypeProvider
                                                          .getLeaveTypeModel!
                                                          .data!
                                                          .firstWhere((e) =>
                                                              e.keyWord ==
                                                              leaveProvider
                                                                  .selectedLeaveType)
                                                          .logo!,
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
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    leaveTypeProvider
                                                        .getLeaveTypeModel!
                                                        .data!
                                                        .firstWhere((e) =>
                                                            e.keyWord ==
                                                            leaveProvider
                                                                .selectedLeaveType)
                                                        .typeName!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        leaveTypeProvider
                                                            .getLeaveTypeModel!
                                                            .data!
                                                            .firstWhere((e) =>
                                                                e.keyWord ==
                                                                leaveProvider
                                                                    .selectedLeaveType)
                                                            .used
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    1.9,
                                                                color:
                                                                    kRedColor),
                                                      ),
                                                      Text('/'),
                                                      Text(
                                                        leaveTypeProvider
                                                            .getLeaveTypeModel!
                                                            .data!
                                                            .firstWhere((e) =>
                                                                e.keyWord ==
                                                                leaveProvider
                                                                    .selectedLeaveType)
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
                                      Icon(leaveProvider.isDropdownOpen
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                              if (leaveProvider.isDropdownOpen)
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
                                    key: ValueKey(leaveProvider.isDropdownOpen),
                                    constraints: const BoxConstraints(
                                      maxHeight: 300,
                                    ),
                                    child: ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: leaveTypeProvider
                                          .getLeaveTypeModel!.data!.length,
                                      itemBuilder: (context, index) {
                                        final data = leaveTypeProvider
                                            .getLeaveTypeModel!.data![index];
                                        var dataColor = getItemColor(
                                            data.keyWord.toString());
                                        Color color = dataColor['color'];
                                        return InkWell(
                                          onTap: () {
                                            ref.read(
                                                stateLeaveProvider.notifier)
                                              ..selectedLeaveType = data.keyWord
                                              ..isDropdownOpen = false;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 12),
                                            child: Container(
                                              height: 55,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: leaveProvider
                                                              .selectedLeaveType ==
                                                          data.keyWord
                                                      ? kYellowColor
                                                      : kGary,
                                                ),
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
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
                                                        CircleAvatar(
                                                          radius: SizeConfig
                                                                  .heightMultiplier *
                                                              3,
                                                          backgroundColor: color
                                                              .withOpacity(0.1),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                data.logo!,
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    const LoadingPlatformV2(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                            color: color,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 0),
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
                                                        color: leaveProvider
                                                                    .selectedLeaveType ==
                                                                data.keyWord
                                                            ? kYellowColor
                                                            : kGary,
                                                      ),
                                                      child: Icon(
                                                        Icons.check,
                                                        color: leaveProvider
                                                                    .selectedLeaveType ==
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
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                  if (leaveProvider.selectedLeaveType != null) ...[
                    SizedBox(height: SizeConfig.heightMultiplier * 2),
                    Text(
                      Strings.txtDayS.tr,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: SizeConfig.textMultiplier * 1.9,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 500.ms)
                        .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                    SizedBox(height: SizeConfig.heightMultiplier * 1),
                    GestureDetector(
                      onTap: () {
                        showCustomDateRangePicker(
                          context,
                          dismissible: true,
                          minimumDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          maximumDate:
                              DateTime.now().add(const Duration(days: 30)),
                          endDate: endDate,
                          startDate: startDate,
                          backgroundColor: Theme.of(context).cardColor,
                          primaryColor: const Color(0xFF283050),
                          onApplyClick: (start, end) {
                            setState(() {
                              endDate = end;
                              startDate = start;
                            });
                            logger.d('start =${startDate}');
                            logger.d('end = ${endDate}');
                            final duration =
                                endDate!.difference(startDate!).inDays;
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
                          prefixIcon: Image.asset(ImagePath.iconCalendar),
                          suffixIcon: const Icon(
                            Icons.arrow_right,
                          ),
                          hintText: startDate != null && endDate != null
                              ? '${DateFormat("dd, MMMM", 'lo').format(startDate!)} - ${DateFormat("dd, MMMM", 'lo').format(endDate!)}'
                              : Strings.txtSelectDateNew.tr,
                          hintStyle: startDate != null && endDate != null
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith()
                              : Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(),
                          errorText: _validate ? "ກະລຸນາເລືອກວັນທີກ່ອນ" : null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 500.ms).move(
                        begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
                    SizedBox(height: SizeConfig.heightMultiplier * 2),
                    if (startDate != null &&
                        endDate != null &&
                        DateTime(
                              startDate!.year,
                              startDate!.month,
                              startDate!.day,
                            ).compareTo(DateTime(
                                endDate!.year, endDate!.month, endDate!.day)) >=
                            0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                              text: Strings.txtTimeNew.tr,
                              children: [
                                TextSpan(
                                  text: '  (${Strings.txtTimNoIsYes.tr})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.9,
                                        color: kGreyColor2,
                                      ),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: const Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          // Time
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
                                                            leaveNotifier
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
                                                    leaveNotifier
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
                                              .copyWith()
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(),
                                      controller:
                                          leaveNotifier.startTimeController,
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
                                                          leaveNotifier
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
                                                  leaveNotifier
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
                                              .copyWith()
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(),
                                      controller:
                                          leaveNotifier.endTimeController,
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
                        ],
                      ),
                    SizedBox(height: SizeConfig.heightMultiplier * 2),
                    Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: SizeConfig.textMultiplier * 1.9),
                        text: Strings.txtReasonNew.tr,
                        children: [
                          TextSpan(
                            text: '  (${Strings.txtTimNoIsYes.tr})',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                    color: kGreyColor2),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 500.ms)
                        .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                    SizedBox(height: SizeConfig.heightMultiplier * 1),
                    CustomTextField(
                      maxLines: 5,
                      hintText: Strings.txtPLeaseEnter.tr,
                      controller: leaveNotifier.accordingController,
                      hintStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 500.ms)
                        .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                    SizedBox(height: SizeConfig.heightMultiplier * 2),
                    if (leaveProvider.shouldShowCustomTextField('SICK') ||
                        (leaveProvider.shouldShowCustomTextField('LAKIT')))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.9),
                              text: Strings.txtReferences.tr,
                              children: [
                                TextSpan(
                                  text: ' (${Strings.txtTimNoIsYes.tr})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                          color: kGreyColor2),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          InkWell(
                            onTap: () async {
                              bottomSheetPushContainer(
                                context: context,
                                constantsSize: 1,
                                child: buttonChooseImage(context),
                              );
                            },
                            child: Container(
                              height: _imageFile == null
                                  ? SizeConfig.heightMultiplier * 30
                                  : null,
                              width: double.infinity,
                              decoration: ShapeDecoration(
                                color: Theme.of(context).canvasColor,
                                shape: DashedBorder(
                                  color: kGreyColor2,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _imageFile == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Strings.txtUploadImage.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.9,
                                                ),
                                          ),
                                          SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      2),
                                          SizedBox(
                                            child: Image.asset(
                                              ImagePath.iconIconImage,
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      6,
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      6,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          image: FileImage(
                                            File(_imageFile!.path),
                                          ),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                        ],
                      ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
            onTap: () async {
              if (leaveProvider.selectedLeaveType == null) {
                Fluttertoast.showToast(
                  msg: Strings.txtSelectLeave.tr,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: kRedColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                return;
              }
              if (startDate == null || endDate == null) {
                setState(() {
                  _validate = true;
                });
                return;
              }

              setState(() {
                isLoading = true;
                _validate = false;
              });
              await submitForm(ref);
              setState(() {
                isLoading = false;
              });
              leaveNotifier.startTimeController.clear();
              leaveNotifier.endTimeController.clear();
              leaveNotifier.accordingController.clear();
              leaveProvider.clearImage();
              // leaveProvider.selectedLeaveType = null;
            },
            child: Container(
              width: SizeConfig.widthMultiplier * 100,
              height: SizeConfig.heightMultiplier * 6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: startDate != null && endDate != null
                    ? kYellowFirstColor
                    : kGreyBGColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.txtLoading.tr,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    color: kBack,
                                  ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        Strings.txtSubmitForm.tr,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2.5,
                            ),
                      ),
                    ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 500.ms)
                .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)),
      ),
    );
  }

  Widget buttonChooseImage(context) {
    return Container(
      height: SizeConfig.heightMultiplier * 9,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            Strings.txtPleaseChooseImage.tr,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  _takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.camera_alt_outlined, color: kYellowColor),
                label: Text(
                  Strings.txtCamera.tr,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  _takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.image_outlined, color: kYellowColor),
                label: Text(
                  Strings.txtGallery.tr,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _takePhoto(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
        state = AppState.picked;
      });
    }
  }

  Map<String, dynamic> getItemColor(String keyword) {
    switch (keyword) {
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



// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:enterprise/components/logger/logger.dart';
// import 'package:enterprise/components/poviders/users_provider/users_provider.dart';
// import 'package:enterprise/components/utils/dialogs.dart';
// import 'package:enterprise/components/utils/dio_exceptions.dart';
// import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
// import 'package:enterprise/views/widgets/app_dialog/alerts_dialog.dart';
// import 'package:enterprise/views/widgets/custom_date_range_picker/custom_date_range_picker.dart';
// import 'package:enterprise/views/widgets/loading_platform/loading_login.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:widgets_easier/widgets_easier.dart';

// import '../../../components/constants/colors.dart';
// import '../../../components/constants/image_path.dart';
// import '../../../components/constants/strings.dart';
// import '../../../components/poviders/leave_provider/leave_provider.dart';
// import '../../../components/poviders/leave_provider/leaves_provider.dart';
// import '../../../components/router/router.dart';
// import '../../../components/services/api_service/enterprise_service.dart';
// import '../../../components/styles/size_config.dart';
// import '../../widgets/appbar/appbar_widget.dart';
// import '../../widgets/bottom_sheet_push/bottom_sheet_push.dart';
// import '../../widgets/text_input/custom_text_filed.dart';

// class LeaveScreens extends ConsumerStatefulWidget {
//   const LeaveScreens({super.key});

//   @override
//   ConsumerState createState() => _LeaveScreensState();
// }

// class _LeaveScreensState extends ConsumerState<LeaveScreens> {
//   bool isLoadingLeave = false;
//   Future fetchLeaveTypeApi() async {
//     final userProvider = ref.watch(stateUserProvider);
//     setState(() {
//       isLoadingLeave = true;
//     });
//     EnterpriseAPIService()
//         .callLeaveType(
//       userID: userProvider.getUserModel!.data!.id ?? 0,
//     )
//         .then((value) {
//       ref.watch(stateLeaveProvider).setLeaveTypeModels(value: value);

//     }).catchError((onError) {
//       errorDialog(
//         context: context,
//         onError: onError,
//       );
//       // logger.e(DioExceptions.fromDioError(onError));
//     }).whenComplete(() => setState(() {
//               isLoadingLeave = false;
//             }));
//   }

//   bool isLoading = false;

//   bool _checkTime = false;

//   DateTime? startDate;
//   DateTime? endDate;
//   DateTime? startTime;
//   DateTime? endTime;

//   @override
//   void initState() {
//     final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchLeaveTypeApi();
//     });
//     leaveNotifier.startTimeController.clear();
//     leaveNotifier.endTimeController.clear();
//     leaveNotifier.accordingController.clear();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> submitForm(WidgetRef ref) async {
//     final userProvider = ref.watch(stateUserProvider);
//     final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
//     final leaveProvider = ref.watch(stateLeaveProvider);

//     // Check if a leave type is selected
//     if (leaveProvider.selectedLeaveType == null) {
//       Fluttertoast.showToast(
//         msg: Strings.txtSelectLeave.tr,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: kRedColor,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );

//       return;
//     }

//     final selectedLeaveType = leaveProvider.getLeaveTypeModel!.data!
//         .firstWhereOrNull((e) => e.keyWord == leaveProvider.selectedLeaveType);

//     if (selectedLeaveType == null) {
//       Fluttertoast.showToast(
//         msg: Strings.txtSelectLeave.tr,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: kRedColor,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );

//       return;
//     }

//     final String imagePath = leaveProvider.selectedImage != null
//         ? leaveProvider.selectedImage!.path
//         : "";
//     final DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');

//     try {
//       final response = await EnterpriseAPIService().createLeave(
//         userID: userProvider.getUserModel!.data!.id ?? 0,
//         leaveTypeId: selectedLeaveType.id,
//         startDate: format.format(startDate!),
//         endDate: format.format(endDate!),
//         note: leaveNotifier.accordingController.text ?? '',
//         document: imagePath,
//       );

  
//       // if (response.data['status'] == false) {
//       //   Fluttertoast.showToast(
//       //     msg: Strings.txtSelectLeave.tr,
//       //     toastLength: Toast.LENGTH_SHORT,
//       //     gravity: ToastGravity.CENTER,
//       //     timeInSecForIosWeb: 1,
//       //     backgroundColor: kRedColor,
//       //     textColor: Colors.white,
//       //     fontSize: 16.0,
//       //   );
//       //   return;
//       // }
//       if (response['data'] == "Insufficient leave balance") {
//         setState(() {
//           isLoading = false;
//         });
//         return showDialog(
//             context: context,
//             builder: (context) {
//               return AlertSuccessDialog(
//                 title: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFFF6563).withOpacity(.12),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Bootstrap.exclamation_circle_fill,
//                     color: Color(0xFFFF6563),
//                     size: SizeConfig.imageSizeMultiplier * 13,
//                   ),
//                 ),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'ບໍ່ສາມາດລາພັກໄດ້'.tr,
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'ວັນລາພັກຂອງເຈົ້າໝົດແລ້ວ',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge
//                           ?.copyWith(color: Color(0xFF474747)),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//                 onTapOK: () {
//                   context.pop();
//                 },
//               );
//             });
//       }
//       // ignore: use_build_context_synchronously
//       alertSuccessDialog(context);
//     } on DioException catch (e) {
//       final dioException = DioExceptions.fromDioError(e);
//       logger.e("Error during leave: ${dioException.toString()}");
//       // ignore: use_build_context_synchronously
//       errorDialog(context: context, onError: e);
//     } catch (e) {
//       logger.e("Error leave: $e");
//       // ignore: use_build_context_synchronously
//       errorDialog(context: context, onError: e);
//     }
//   }

//   Future<void> alertSuccessDialog(
//     BuildContext context,
//   ) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertSuccessDialog(
//             title: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Color(0xFF23A26D).withOpacity(.12),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Bootstrap.check_circle_fill,
//                 color: Color(0xFF23A26D),
//                 size: SizeConfig.imageSizeMultiplier * 13,
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   Strings.txtSuccessFully.tr,
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   Strings.txtYourformhavesubmittedand.tr,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyLarge
//                       ?.copyWith(color: Color(0xFF474747)),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//             onTapOK: () {
//               context.pop();
//               context.pop();
//               context.push(PageName.leaveHistoryScreen);
//             },
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final leaveTypeProvider = ref.watch(stateLeaveProvider);
//     final leaveProvider = ref.watch(stateLeaveProvider);
//     final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
//     final color = leaveProvider.selectedLeaveType != null
//         ? getItemColor(leaveProvider.selectedLeaveType!)['color'] as Color
//         : Colors.blueAccent;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F7FA),
//       appBar: widgetAppBar(),
//       body: CustomProgressHUD(
//         key: UniqueKey(),
//         inAsyncCall: isLoading,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Form(
//               key: leaveNotifier.formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(Strings.txtTypeLeave.tr,
//                           style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                                 fontSize: SizeConfig.textMultiplier * 1.9,
//                               ))
//                       .animate()
//                       .fadeIn(duration: 500.ms, delay: 500.ms)
//                       .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
//                   SizedBox(height: SizeConfig.heightMultiplier * 1),
//                   leaveProvider.getLeaveTypeModel == null
//                       ? Shimmer.fromColors(
//                           baseColor: kGreyColor1,
//                           highlightColor: kGary,
//                           child: Container(
//                             height: SizeConfig.heightMultiplier * 6,
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: kTextWhiteColor,
//                               border: Border.all(color: kYellowColor),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                         )
                    
//                       : AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.easeInOut,
//                           decoration: BoxDecoration(
//                             color: kTextWhiteColor,
//                             border: Border.all(color: kYellowColor),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   ref
//                                           .read(stateLeaveProvider.notifier)
//                                           .isDropdownOpen =
//                                       !leaveProvider.isDropdownOpen;
//                                 },
//                                 child: Container(
//                                   height: SizeConfig.heightMultiplier * 6,
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 5, horizontal: 10),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       leaveProvider.selectedLeaveType != null
//                                           ? Row(
//                                               children: [
//                                                 CircleAvatar(
//                                                   radius: SizeConfig
//                                                           .heightMultiplier *
//                                                       5,
//                                                   backgroundColor:
//                                                       color.withOpacity(0.1),
//                                                   child: CachedNetworkImage(
//                                                     imageUrl: leaveTypeProvider
//                                                         .getLeaveTypeModel!
//                                                         .data!
//                                                         .firstWhere((e) =>
//                                                             e.keyWord ==
//                                                             leaveProvider
//                                                                 .selectedLeaveType)
//                                                         .logo!,
//                                                     progressIndicatorBuilder: (context,
//                                                             url,
//                                                             downloadProgress) =>
//                                                         const CupertinoActivityIndicator(),
//                                                     errorWidget: (context, url,
//                                                             error) =>
//                                                         const Icon(Icons.error),
//                                                     color: color,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   leaveTypeProvider
//                                                       .getLeaveTypeModel!.data!
//                                                       .firstWhere((e) =>
//                                                           e.keyWord ==
//                                                           leaveProvider
//                                                               .selectedLeaveType)
//                                                       .typeName!,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .titleMedium,
//                                                 ),
//                                                 const SizedBox(width: 10),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       leaveTypeProvider
//                                                           .getLeaveTypeModel!
//                                                           .data!
//                                                           .firstWhere((e) =>
//                                                               e.keyWord ==
//                                                               leaveProvider
//                                                                   .selectedLeaveType)
//                                                           .used
//                                                           .toString(),
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleSmall!
//                                                           .copyWith(
//                                                               fontSize: SizeConfig
//                                                                       .textMultiplier *
//                                                                   1.9,
//                                                               color: kRedColor),
//                                                     ),
//                                                     Text('/'),
//                                                     Text(
//                                                       leaveTypeProvider
//                                                           .getLeaveTypeModel!
//                                                           .data!
//                                                           .firstWhere((e) =>
//                                                               e.keyWord ==
//                                                               leaveProvider
//                                                                   .selectedLeaveType)
//                                                           .total
//                                                           .toString(),
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleSmall!
//                                                           .copyWith(
//                                                               fontSize: SizeConfig
//                                                                       .textMultiplier *
//                                                                   1.9,
//                                                               color: const Color(
//                                                                   0xFF23A26D)),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             )
//                                           : const Text(Strings.txtSelectLeave),
//                                       Icon(leaveProvider.isDropdownOpen
//                                           ? Icons.arrow_drop_up
//                                           : Icons.arrow_drop_down),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               if (leaveProvider.isDropdownOpen)
//                                 AnimatedSwitcher(
//                                   duration: const Duration(milliseconds: 800),
//                                   transitionBuilder: (widget, animation) {
//                                     return SlideTransition(
//                                       position: Tween<Offset>(
//                                         begin: const Offset(0, -0.5),
//                                         end: Offset.zero,
//                                       ).animate(CurvedAnimation(
//                                         parent: animation,
//                                         curve: Curves.easeOut,
//                                       )),
//                                       child: FadeTransition(
//                                         opacity: animation,
//                                         child: SizeTransition(
//                                           sizeFactor: CurvedAnimation(
//                                             parent: animation,
//                                             curve: Curves.easeOut,
//                                           ),
//                                           child: widget,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: ConstrainedBox(
//                                     key: ValueKey(leaveProvider.isDropdownOpen),
//                                     constraints: const BoxConstraints(
//                                       maxHeight: 300,
//                                     ),
//                                     child: ListView.builder(
//                                       physics: const ClampingScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemCount: leaveTypeProvider
//                                           .getLeaveTypeModel!.data!.length,
//                                       itemBuilder: (context, index) {
//                                         final data = leaveTypeProvider
//                                             .getLeaveTypeModel!.data![index];
//                                         var dataColor = getItemColor(
//                                             data.keyWord.toString());
//                                         Color color = dataColor['color'];
//                                         return InkWell(
//                                           onTap: () {
//                                             ref.read(
//                                                 stateLeaveProvider.notifier)
//                                               ..selectedLeaveType = data.keyWord
//                                               ..isDropdownOpen = false;
//                                           },
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 8, horizontal: 12),
//                                             child: Container(
//                                               height: 55,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   color: leaveProvider
//                                                               .selectedLeaveType ==
//                                                           data.keyWord
//                                                       ? kYellowColor
//                                                       : kGary,
//                                                 ),
//                                                 color: kTextWhiteColor,
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                               ),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         CircleAvatar(
//                                                           radius: SizeConfig
//                                                                   .heightMultiplier *
//                                                               3,
//                                                           backgroundColor: color
//                                                               .withOpacity(0.1),
//                                                           child:
//                                                               CachedNetworkImage(
//                                                             imageUrl:
//                                                                 data.logo!,
//                                                             progressIndicatorBuilder:
//                                                                 (context, url,
//                                                                         downloadProgress) =>
//                                                                     const CupertinoActivityIndicator(),
//                                                             errorWidget: (context,
//                                                                     url,
//                                                                     error) =>
//                                                                 const Icon(Icons
//                                                                     .error),
//                                                             color: color,
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                             width: 10),
//                                                         Row(
//                                                           children: [
//                                                             Text(
//                                                               data.typeName!,
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .titleSmall!
//                                                                   .copyWith(
//                                                                     fontSize:
//                                                                         SizeConfig.textMultiplier *
//                                                                             1.9,
//                                                                   ),
//                                                             ),
//                                                             const SizedBox(
//                                                                 width: 10),
//                                                             Text(
//                                                               (data.used !=
//                                                                       null)
//                                                                   ? (data.used! %
//                                                                               1 ==
//                                                                           0
//                                                                       ? data
//                                                                           .used!
//                                                                           .toInt()
//                                                                           .toString()
//                                                                       : data
//                                                                           .used!
//                                                                           .toStringAsFixed(
//                                                                               1))
//                                                                   : '-',
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .titleSmall!
//                                                                   .copyWith(
//                                                                     fontSize:
//                                                                         SizeConfig.textMultiplier *
//                                                                             1.9,
//                                                                     color:
//                                                                         kRedColor,
//                                                                   ),
//                                                             ),
//                                                             Text(
//                                                               '/',
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .titleSmall!
//                                                                   .copyWith(
//                                                                     fontSize:
//                                                                         SizeConfig.textMultiplier *
//                                                                             1.9,
//                                                                   ),
//                                                             ),
//                                                             Text(
//                                                               (data.total !=
//                                                                       null)
//                                                                   ? (data.total! %
//                                                                               1 ==
//                                                                           0
//                                                                       ? data
//                                                                           .total!
//                                                                           .toInt()
//                                                                           .toString()
//                                                                       : data
//                                                                           .total!
//                                                                           .toStringAsFixed(
//                                                                               1))
//                                                                   : '-',
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .titleSmall!
//                                                                   .copyWith(
//                                                                       fontSize:
//                                                                           SizeConfig.textMultiplier *
//                                                                               1.9,
//                                                                       color: const Color(
//                                                                           0xFF23A26D)),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Container(
//                                                       width: 24,
//                                                       height: 24,
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: leaveProvider
//                                                                     .selectedLeaveType ==
//                                                                 data.keyWord
//                                                             ? kYellowColor
//                                                             : kGary,
//                                                       ),
//                                                       child: Icon(
//                                                         Icons.check,
//                                                         color: leaveProvider
//                                                                     .selectedLeaveType ==
//                                                                 data.keyWord
//                                                             ? Colors.black
//                                                             : Colors.white,
//                                                         size: 16,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                   if (leaveProvider.selectedLeaveType != null) ...[
//                     SizedBox(height: SizeConfig.heightMultiplier * 2),
//                     Text(
//                       Strings.txtStrDate.tr,
//                       style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                             fontSize: SizeConfig.textMultiplier * 1.9,
//                           ),
//                     )
//                         .animate()
//                         .fadeIn(duration: 500.ms, delay: 500.ms)
//                         .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
//                     SizedBox(height: SizeConfig.heightMultiplier * 1),
//                     GestureDetector(
//                       onTap: () {
//                         showCustomDateRangePicker(
//                           context,
//                           dismissible: true,
//                           minimumDate:
//                               DateTime.now().subtract(const Duration(days: 30)),
//                           maximumDate:
//                               DateTime.now().add(const Duration(days: 30)),
//                           endDate: endDate,
//                           startDate: startDate,
//                           backgroundColor: Colors.white,
//                           primaryColor: const Color(0xFF283050),
//                           onApplyClick: (start, end) {
//                             setState(() {
//                               endDate = end;
//                               startDate = start;
//                             });
//                             logger.d('start =${startDate}');
//                             logger.d('end = ${endDate}');
//                             final duration =
//                                 endDate!.difference(startDate!).inDays;
//                             logger.d('Total${duration}');
//                             ;
//                           },
//                           onCancelClick: () {
//                             setState(() {
//                               endDate = null;
//                               startDate = null;
//                             });
//                           },
//                         );
//                       },
//                       child: AbsorbPointer(
//                         child: CustomTextField(
//                           prefixIcon: Image.asset(ImagePath.iconCalendar),
//                           suffixIcon: const Icon(
//                             Icons.arrow_right,
//                           ),
//                           hintText: startDate != null && endDate != null
//                               ? '${DateFormat("dd, MMMM", 'lo').format(startDate!)} - ${DateFormat("dd, MMMM", 'lo').format(endDate!)}'
//                               : Strings.txtSelectDateNew.tr,
//                           hintStyle: startDate != null && endDate != null
//                               ? Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium!
//                                   .copyWith(color: Color(0xFF37474F))
//                               : Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge!
//                                   .copyWith(color: kGreyColor2),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return null;
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ).animate().fadeIn(duration: 500.ms, delay: 500.ms).move(
//                         begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
//                     SizedBox(height: SizeConfig.heightMultiplier * 2),
//                     if (startDate != null &&
//                         endDate != null &&
//                         DateTime(
//                               startDate!.year,
//                               startDate!.month,
//                               startDate!.day,
//                             ).compareTo(DateTime(
//                                 endDate!.year, endDate!.month, endDate!.day)) >=
//                             0)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(
//                             TextSpan(
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall!
//                                   .copyWith(
//                                     fontSize: SizeConfig.textMultiplier * 1.9,
//                                   ),
//                               text: Strings.txtTimeNew.tr,
//                               children: [
//                                 TextSpan(
//                                   text: '  (${Strings.txtTimNoIsYes.tr})',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge!
//                                       .copyWith(
//                                         fontSize:
//                                             SizeConfig.textMultiplier * 1.9,
//                                         color: kGreyColor2,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           )
//                               .animate()
//                               .fadeIn(duration: 500.ms, delay: 500.ms)
//                               .move(
//                                   begin: const Offset(-16, 0),
//                                   curve: Curves.easeOutQuad),
//                           SizedBox(height: SizeConfig.heightMultiplier * 1),
//                           // Time
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     if (Platform.isAndroid) {
//                                       showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return AlertDialog(
//                                             content: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     const Center(
//                                                       child: Text(
//                                                         'ເລືອກເວລາເລີ່ມຕົ້ນ',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                       ),
//                                                     ),
//                                                     IconButton(
//                                                         onPressed: () {
//                                                           context.pop();
//                                                         },
//                                                         icon: const Icon(
//                                                             Icons.close))
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: SizeConfig
//                                                           .heightMultiplier *
//                                                       30,
//                                                   child: Localizations.override(
//                                                     context: context,
//                                                     locale: const Locale('en'),
//                                                     child: CupertinoTheme(
//                                                       data: CupertinoTheme.of(
//                                                           context),
//                                                       child:
//                                                           CupertinoDatePicker(
//                                                         initialDateTime:
//                                                             startTime,
//                                                         use24hFormat: true,
//                                                         mode:
//                                                             CupertinoDatePickerMode
//                                                                 .time,
//                                                         onDateTimeChanged:
//                                                             (DateTime newTime) {
//                                                           startTime = newTime;
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     SizedBox(
//                                                       width: SizeConfig
//                                                               .widthMultiplier *
//                                                           50,
//                                                       child: OutlinedButton(
//                                                         onPressed: () {
//                                                           setState(() {
//                                                             _checkTime = true;

//                                                             if (startDate !=
//                                                                     null &&
//                                                                 startTime !=
//                                                                     null) {
//                                                               startDate = DateTime(
//                                                                   startDate!
//                                                                       .year,
//                                                                   startDate!
//                                                                       .month,
//                                                                   startDate!
//                                                                       .day,
//                                                                   startTime!
//                                                                       .hour,
//                                                                   startTime!
//                                                                       .minute,
//                                                                   startTime!
//                                                                       .second);
//                                                             } else {
//                                                               DateTime
//                                                                   currentTime =
//                                                                   DateTime
//                                                                       .now();
//                                                               startDate =
//                                                                   DateTime(
//                                                                 startDate!.year,
//                                                                 startDate!
//                                                                     .month,
//                                                                 startDate!.day,
//                                                                 currentTime
//                                                                     .hour,
//                                                                 currentTime
//                                                                     .minute,
//                                                                 currentTime
//                                                                     .second,
//                                                               );
//                                                             }

//                                                             final formattedDate =
//                                                                 DateFormat(
//                                                                         'yyyy-MM-dd HH:mm:ss')
//                                                                     .format(
//                                                                         startDate!);
//                                                             final formattedTime =
//                                                                 DateFormat(
//                                                                         'HH:mm')
//                                                                     .format(
//                                                                         startDate!);
//                                                             leaveNotifier
//                                                                     .startTimeController
//                                                                     .text =
//                                                                 formattedTime;
//                                                             logger.d(
//                                                                 formattedDate);
//                                                           });

//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         style: OutlinedButton
//                                                             .styleFrom(
//                                                                 side: const BorderSide(
//                                                                     color:
//                                                                         kYellowColor),
//                                                                 shape:
//                                                                     RoundedRectangleBorder(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               50),
//                                                                 ),
//                                                                 backgroundColor:
//                                                                     kYellowColor),
//                                                         child: Text(
//                                                           Strings.txtConfirm.tr,
//                                                           style: Theme.of(
//                                                                   context)
//                                                               .textTheme
//                                                               .titleSmall!
//                                                               .copyWith(
//                                                                   fontSize:
//                                                                       SizeConfig
//                                                                               .textMultiplier *
//                                                                           2,
//                                                                   color:
//                                                                       kTextWhiteColor),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     } else if (Platform.isIOS) {
//                                       showCupertinoModalPopup(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return CupertinoActionSheet(
//                                             actions: [
//                                               SizedBox(
//                                                 height: SizeConfig
//                                                         .heightMultiplier *
//                                                     20,
//                                                 child: Localizations.override(
//                                                   context: context,
//                                                   locale: const Locale('en'),
//                                                   child: CupertinoDatePicker(
//                                                     initialDateTime: startTime,
//                                                     use24hFormat: true,
//                                                     mode:
//                                                         CupertinoDatePickerMode
//                                                             .time,
//                                                     onDateTimeChanged:
//                                                         (DateTime newTime) {
//                                                       startTime = newTime;
//                                                     },
//                                                   ),
//                                                 ),
//                                               ),
//                                               CupertinoActionSheetAction(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _checkTime = true;

//                                                     if (startDate != null &&
//                                                         startTime != null) {
//                                                       startDate = DateTime(
//                                                           startDate!.year,
//                                                           startDate!.month,
//                                                           startDate!.day,
//                                                           startTime!.hour,
//                                                           startTime!.minute,
//                                                           startTime!.second);
//                                                     } else {
//                                                       DateTime currentTime =
//                                                           DateTime.now();
//                                                       startDate = DateTime(
//                                                         startDate!.year,
//                                                         startDate!.month,
//                                                         startDate!.day,
//                                                         currentTime.hour,
//                                                         currentTime.minute,
//                                                         currentTime.second,
//                                                       );
//                                                     }

//                                                     final formattedDate =
//                                                         DateFormat(
//                                                                 'yyyy-MM-dd HH:mm:ss')
//                                                             .format(startDate!);
//                                                     final formattedTime =
//                                                         DateFormat('HH:mm')
//                                                             .format(startDate!);
//                                                     leaveNotifier
//                                                         .startTimeController
//                                                         .text = formattedTime;
//                                                     logger.d(formattedDate);
//                                                   });

//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Text(
//                                                   Strings.txtConfirm,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .titleMedium!
//                                                       .copyWith(
//                                                           fontSize: SizeConfig
//                                                                   .textMultiplier *
//                                                               2,
//                                                           color: kBlueColor),
//                                                 ),
//                                               ),
//                                             ],
//                                             cancelButton:
//                                                 CupertinoActionSheetAction(
//                                               isDestructiveAction: true,
//                                               onPressed: () {
//                                                 setState(() {
//                                                   startTime = null;
//                                                 });
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Text(
//                                                 Strings.txtCancel,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .titleMedium!
//                                                     .copyWith(
//                                                         fontSize: SizeConfig
//                                                                 .textMultiplier *
//                                                             2,
//                                                         color: kRedColor),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     }
//                                   },
//                                   child: AbsorbPointer(
//                                     child: CustomTextField(
//                                       hintText: startTime != null
//                                           ? '${DateFormat(
//                                               "HH:mm",
//                                             ).format(startTime!)} '
//                                           : Strings.txtSelectDateNew.tr,
//                                       suffixIcon: Image.asset(ImagePath.iconIn),
//                                       validator: (value) => null,
//                                       hintStyle: startTime != null
//                                           ? Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge!
//                                               .copyWith(
//                                                   color: Color(0xFF37474F))
//                                           : Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge!
//                                               .copyWith(color: kGreyColor2),
//                                       controller:
//                                           leaveNotifier.startTimeController,
//                                     ),
//                                   )
//                                       .animate()
//                                       .fadeIn(duration: 500.ms, delay: 500.ms)
//                                       .move(
//                                           begin: Offset(-16, 0),
//                                           curve: Curves.easeOutQuad),
//                                 ),
//                               ),
//                               SizedBox(width: SizeConfig.widthMultiplier * 4),
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     if (Platform.isAndroid) {
//                                       showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return AlertDialog(
//                                             content: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     const Center(
//                                                       child: Text(
//                                                         'ເລືອກເວລາສີ້ນສຸດ',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                       ),
//                                                     ),
//                                                     IconButton(
//                                                         onPressed: () {
//                                                           context.pop();
//                                                         },
//                                                         icon: const Icon(
//                                                             Icons.close))
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: SizeConfig
//                                                           .heightMultiplier *
//                                                       30,
//                                                   child: Localizations.override(
//                                                     context: context,
//                                                     locale: const Locale('en'),
//                                                     child: CupertinoTheme(
//                                                       data: CupertinoTheme.of(
//                                                           context),
//                                                       child:
//                                                           CupertinoDatePicker(
//                                                         minimumDate: startTime,
//                                                         initialDateTime:
//                                                             startTime ??
//                                                                 endTime,
//                                                         use24hFormat: true,
//                                                         mode:
//                                                             CupertinoDatePickerMode
//                                                                 .time,
//                                                         onDateTimeChanged:
//                                                             (DateTime newTime) {
//                                                           endTime = newTime;
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     SizedBox(
//                                                       width: SizeConfig
//                                                               .widthMultiplier *
//                                                           50,
//                                                       child: OutlinedButton(
//                                                         onPressed: () {
//                                                           if (!_checkTime) {
//                                                             Fluttertoast.showToast(
//                                                                 msg: Strings
//                                                                     .txtSelectLeaveStart
//                                                                     .tr,
//                                                                 toastLength: Toast
//                                                                     .LENGTH_SHORT,
//                                                                 gravity:
//                                                                     ToastGravity
//                                                                         .CENTER,
//                                                                 timeInSecForIosWeb:
//                                                                     1,
//                                                                 backgroundColor:
//                                                                     kYellowColor,
//                                                                 textColor:
//                                                                     Colors
//                                                                         .white,
//                                                                 fontSize: 20.0);
//                                                             context.pop();
//                                                             return;
//                                                           }

//                                                           if (endDate != null &&
//                                                               endTime != null) {
//                                                             endDate = DateTime(
//                                                                 endDate!.year,
//                                                                 endDate!.month,
//                                                                 endDate!.day,
//                                                                 endTime!.hour,
//                                                                 endTime!.minute,
//                                                                 endTime!
//                                                                     .second);
//                                                           } else {
//                                                             DateTime
//                                                                 currentTime =
//                                                                 DateTime.now();
//                                                             endDate = DateTime(
//                                                               endDate!.year,
//                                                               endDate!.month,
//                                                               endDate!.day,
//                                                               currentTime.hour,
//                                                               currentTime
//                                                                   .minute,
//                                                               currentTime
//                                                                   .second,
//                                                             );
//                                                           }
//                                                           final formattedDate =
//                                                               DateFormat(
//                                                                       'yyyy-MM-dd HH:mm:ss')
//                                                                   .format(
//                                                                       startDate!);
//                                                           final formattedTime =
//                                                               DateFormat(
//                                                                       'HH:mm')
//                                                                   .format(
//                                                                       startDate!);
//                                                           leaveNotifier
//                                                               .endTimeController
//                                                               .text = formattedTime;
//                                                           logger
//                                                               .d(formattedDate);
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         style: OutlinedButton
//                                                             .styleFrom(
//                                                                 side: const BorderSide(
//                                                                     color:
//                                                                         kYellowColor),
//                                                                 shape:
//                                                                     RoundedRectangleBorder(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               50),
//                                                                 ),
//                                                                 backgroundColor:
//                                                                     kYellowColor),
//                                                         child: Text(
//                                                           Strings.txtConfirm.tr,
//                                                           style: Theme.of(
//                                                                   context)
//                                                               .textTheme
//                                                               .titleSmall!
//                                                               .copyWith(
//                                                                   fontSize:
//                                                                       SizeConfig
//                                                                               .textMultiplier *
//                                                                           2,
//                                                                   color:
//                                                                       kTextWhiteColor),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     } else {
//                                       showCupertinoModalPopup(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return CupertinoActionSheet(
//                                             actions: [
//                                               SizedBox(
//                                                 height: SizeConfig
//                                                         .heightMultiplier *
//                                                     20,
//                                                 child: Localizations.override(
//                                                   context: context,
//                                                   locale: const Locale('en'),
//                                                   child: CupertinoDatePicker(
//                                                     minimumDate: startTime,
//                                                     initialDateTime: endTime ??
//                                                         DateTime.now(),
//                                                     use24hFormat: true,
//                                                     mode:
//                                                         CupertinoDatePickerMode
//                                                             .time,
//                                                     onDateTimeChanged:
//                                                         (DateTime newTime) {
//                                                       endTime = newTime;
//                                                     },
//                                                   ),
//                                                 ),
//                                               ),
//                                               CupertinoActionSheetAction(
//                                                 onPressed: () {
//                                                   if (!_checkTime) {
//                                                     Fluttertoast.showToast(
//                                                         msg: Strings
//                                                             .txtSelectLeaveStart
//                                                             .tr,
//                                                         toastLength:
//                                                             Toast.LENGTH_SHORT,
//                                                         gravity:
//                                                             ToastGravity.CENTER,
//                                                         timeInSecForIosWeb: 1,
//                                                         backgroundColor:
//                                                             kYellowColor,
//                                                         textColor: Colors.white,
//                                                         fontSize: 20.0);
//                                                     context.pop();
//                                                     return;
//                                                   }

//                                                   if (endDate != null &&
//                                                       endTime != null) {
//                                                     endDate = DateTime(
//                                                         endDate!.year,
//                                                         endDate!.month,
//                                                         endDate!.day,
//                                                         endTime!.hour,
//                                                         endTime!.minute,
//                                                         endTime!.second);
//                                                   } else {
//                                                     DateTime currentTime =
//                                                         DateTime.now();
//                                                     endDate = DateTime(
//                                                       endDate!.year,
//                                                       endDate!.month,
//                                                       endDate!.day,
//                                                       currentTime.hour,
//                                                       currentTime.minute,
//                                                       currentTime.second,
//                                                     );
//                                                   }
//                                                   final formattedDate = DateFormat(
//                                                           'yyyy-MM-dd HH:mm:ss')
//                                                       .format(endDate!);
//                                                   final formattedTime =
//                                                       DateFormat('HH:mm')
//                                                           .format(endDate!);
//                                                   leaveNotifier
//                                                       .endTimeController
//                                                       .text = formattedTime;
//                                                   logger.d(formattedDate);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Text(
//                                                   Strings.txtConfirm,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .titleMedium!
//                                                       .copyWith(
//                                                           fontSize: SizeConfig
//                                                                   .textMultiplier *
//                                                               2,
//                                                           color: kBlueColor),
//                                                 ),
//                                               ),
//                                             ],
//                                             cancelButton:
//                                                 CupertinoActionSheetAction(
//                                               isDestructiveAction: true,
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Text(
//                                                 Strings.txtCancel,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .titleMedium!
//                                                     .copyWith(
//                                                         fontSize: SizeConfig
//                                                                 .textMultiplier *
//                                                             2,
//                                                         color: kRedColor),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     }
//                                   },
//                                   child: AbsorbPointer(
//                                     child: CustomTextField(
//                                       hintText: endTime != null
//                                           ? '${DateFormat(
//                                               "HH:mm:ss",
//                                             ).format(endTime!)} '
//                                           : Strings.txtSelectDateNew.tr,
//                                       suffixIcon: Image.asset(ImagePath.iconIn),
//                                       validator: (value) => null,
//                                       hintStyle: endTime != null
//                                           ? Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge!
//                                               .copyWith(
//                                                   color: Color(0xFF37474F))
//                                           : Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge!
//                                               .copyWith(color: kGreyColor2),
//                                       controller:
//                                           leaveNotifier.endTimeController,
//                                     ),
//                                   )
//                                       .animate()
//                                       .fadeIn(duration: 500.ms, delay: 500.ms)
//                                       .move(
//                                           begin: Offset(-16, 0),
//                                           curve: Curves.easeOutQuad),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     SizedBox(height: SizeConfig.heightMultiplier * 2),
//                     Text.rich(
//                       TextSpan(
//                         style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                             fontSize: SizeConfig.textMultiplier * 1.9),
//                         text: Strings.txtReasonNew.tr,
//                         children: [
//                           TextSpan(
//                             text: '  (${Strings.txtTimNoIsYes.tr})',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge!
//                                 .copyWith(
//                                     fontSize: SizeConfig.textMultiplier * 1.9,
//                                     color: kGreyColor2),
//                           ),
//                         ],
//                       ),
//                     )
//                         .animate()
//                         .fadeIn(duration: 500.ms, delay: 500.ms)
//                         .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
//                     SizedBox(height: SizeConfig.heightMultiplier * 1),
//                     CustomTextField(
//                       maxLines: 5,
//                       hintText: Strings.txtPLeaseEnter.tr,
//                       controller: leaveNotifier.accordingController,
//                     )
//                         .animate()
//                         .fadeIn(duration: 500.ms, delay: 500.ms)
//                         .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
//                     SizedBox(height: SizeConfig.heightMultiplier * 2),
//                     if (leaveProvider.shouldShowCustomTextField('SICK') ||
//                         (leaveProvider.shouldShowCustomTextField('LAKIT')))
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(
//                             TextSpan(
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall!
//                                   .copyWith(
//                                       fontSize:
//                                           SizeConfig.textMultiplier * 1.9),
//                               text: Strings.txtReferences.tr,
//                               children: [
//                                 TextSpan(
//                                   text: '(${Strings.txtTimNoIsYes.tr})',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge!
//                                       .copyWith(
//                                           fontSize:
//                                               SizeConfig.textMultiplier * 1.9,
//                                           color: kGreyColor2),
//                                 ),
//                               ],
//                             ),
//                           )
//                               .animate()
//                               .fadeIn(duration: 500.ms, delay: 500.ms)
//                               .move(
//                                   begin: Offset(-16, 0),
//                                   curve: Curves.easeOutQuad),
//                           SizedBox(height: SizeConfig.heightMultiplier * 1),
//                           InkWell(
//                             onTap: () async {
//                               buildShowImageModalBottomSheet(context, ref);
//                             },
//                             child: Container(
//                               height: leaveProvider.selectedImage == null
//                                   ? SizeConfig.heightMultiplier * 30
//                                   : null,
//                               width: double.infinity,
//                               decoration: ShapeDecoration(
//                                 color: kTextWhiteColor,
//                                 shape: DashedBorder(
//                                   color: kGreyColor2,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: leaveProvider.selectedImage == null
//                                   ? Center(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             Strings.txtUploadImage.tr,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleSmall!
//                                                 .copyWith(
//                                                   fontSize: SizeConfig
//                                                           .textMultiplier *
//                                                       1.9,
//                                                 ),
//                                           ),
//                                           SizedBox(
//                                               width:
//                                                   SizeConfig.widthMultiplier *
//                                                       2),
//                                           SizedBox(
//                                             child: Image.asset(
//                                               ImagePath.iconIconImage,
//                                               width:
//                                                   SizeConfig.widthMultiplier *
//                                                       6,
//                                               height:
//                                                   SizeConfig.heightMultiplier *
//                                                       6,
//                                               fit: BoxFit.contain,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   : Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(10),
//                                         child: Image(
//                                           image: FileImage(
//                                             File(leaveProvider
//                                                 .selectedImage!.path),
//                                           ),
//                                           fit: BoxFit.cover,
//                                           width: double.infinity,
//                                         ),
//                                       ),
//                                     ),
//                             ),
//                           )
//                               .animate()
//                               .fadeIn(duration: 500.ms, delay: 500.ms)
//                               .move(
//                                   begin: Offset(-16, 0),
//                                   curve: Curves.easeOutQuad),
//                         ],
//                       ),
//                   ]
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20),
//         child: GestureDetector(
//             onTap: () async {
//               setState(() {
//                 isLoading = true;
//               });
//               await submitForm(ref);
//               setState(() {
//                 isLoading = false;
//               });
//               leaveNotifier.startTimeController.clear();
//               leaveNotifier.endTimeController.clear();
//               leaveNotifier.accordingController.clear();
//               leaveProvider.clearImage();
//             },
//             child: Container(
//               width: SizeConfig.widthMultiplier * 100,
//               height: SizeConfig.heightMultiplier * 6,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: startDate != null && endDate != null
//                     ? kYellowFirstColor
//                     : kGreyBGColor,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: isLoading
//                   ? Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           Strings.txtLoading.tr,
//                           style:
//                               Theme.of(context).textTheme.titleLarge!.copyWith(
//                                     fontSize: SizeConfig.textMultiplier * 2,
//                                     color: kBack,
//                                   ),
//                         ),
//                       ],
//                     )
//                   : Center(
//                       child: Text(
//                         Strings.txtSubmitForm.tr,
//                         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                               fontSize: SizeConfig.textMultiplier * 2.5,
//                             ),
//                       ),
//                     ),
//             )
//                 .animate()
//                 .fadeIn(duration: 500.ms, delay: 500.ms)
//                 .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)),
//       ),
//     );
//   }

//   Future<void> buildShowImageModalBottomSheet(
//       BuildContext context, WidgetRef ref) {
//     return showModalBottomSheet(
//       backgroundColor: kTextWhiteColor,
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return ImagePickerBottomSheet(
//           onCameraTap: () async {
//             await ref.read(stateLeaveProvider).pickImageFromCamera();
//             context.pop(context);
//             print('Camera tapped');
//           },
//           onGalleryTap: () async {
//             await ref.read(stateLeaveProvider).pickImageFromGallery();
//             context.pop(context);
//             print('Gallery tapped');
//           },
//         );
//       },
//     );
//   }

//   AppBar widgetAppBar() {
//     return AppBar(
//       elevation: 0,
//       flexibleSpace: const AppbarWidget(),
//       title: AnimatedTextAppBarWidget(
//         text: Strings.txtLeaveNew.tr,
//         style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   context.push(PageName.leaveHistoryScreen);
//                 },
//                 child: const CircleAvatar(
//                   backgroundColor: kTextWhiteColor,
//                   radius: 16,
//                   child: Icon(
//                     Ionicons.time_outline,
//                     color: kBack,
//                   ),
//                 ),
//               ),
//               // Add some spacing
//               Expanded(
//                 child: Text(
//                   Strings.txtHistory.tr,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                       fontSize: SizeConfig.textMultiplier *
//                           1.5), // Reduce font size if necessary
//                 ),
//               ),
//             ],
//           ),
//         )
//             .animate()
//             .slideY(duration: 900.ms, curve: Curves.easeOutCubic)
//             .fadeIn(),
//       ],
//     );
//   }

//   Map<String, dynamic> getItemColor(String keyword) {
//     switch (keyword) {
//       case "ANNUAL":
//         return {
//           'color': Color(0xFF3085FE),
//         };
//       case "LAKIT":
//         return {
//           'color': Color(0xFFF45B69),
//         };
//       case "SICK":
//         return {
//           'color': Color(0xFFF59E0B),
//         };
//       case "MATERNITY":
//         return {
//           'color': Color(0xFF23A26D),
//         };

//       default:
//         return {
//           'color': Colors.blueAccent,
//         };
//     }
//   }
// }