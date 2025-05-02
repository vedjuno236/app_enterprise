import 'dart:io';

import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/report_HR_provider/report_HR_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class HomeHrScreen extends ConsumerStatefulWidget {
  const HomeHrScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeHrScreenState();
}

class _HomeHrScreenState extends ConsumerState<HomeHrScreen> {
  Future fetchDepartmentAPI() async {
    EnterpriseAPIService().callDepartment().then((value) {
      ref.watch(stateReportHRProvider).setDepartmentModel(value: value);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDepartmentAPI();
  }

  DateTime selectedDay = DateTime.now();

  Future<void> showDateDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final String currentLocale = Get.locale?.toString() ?? 'lo';
    final dateProvider = ref.read(stateReportHRProvider);
    if (Platform.isAndroid) {
      // Android Date Picker
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 45,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kTextWhiteColor,
                    border: Border.all(color: kYellowFirstColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: kYellowFirstColor,
                              onPrimary: kBack,
                              onSurface: kBack,
                            ),
                          ),
                          child: CalendarDatePicker(
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            onDateChanged: (DateTime value) {},
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                context.pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kGary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 0.0,
                              ),
                              child: const Text(Strings.txtCancel)),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kYellowFirstColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 0.0,
                              ),
                              child: Text(Strings.txtOkay)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else if (Platform.isIOS) {
      // iOS Cupertino Date Picker
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 20,
                child: CupertinoDatePicker(
                  initialDateTime: dateProvider.selectedDay ?? DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime day) {
                    setState(() {
                      selectedDay = day;
                    });
                    logger.d(selectedDay);

                    // ref.read(stateAnalyticProvider.notifier).selectedMonth =
                    //     month;
                    // fetchAnalyticAttendanceApi();
                  },
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  ref.read(stateReportHRProvider.notifier).selectedDay =
                      selectedDay;
                  // fetchAnalyticAttendanceApi();
                  context.pop();
                },
                child: Text(
                  Strings.txtConfirm,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2,
                      color: kBlueColor),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                Strings.txtCancel,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: SizeConfig.textMultiplier * 2, color: kRedColor),
              ),
            ),
          );
        },
      );
    }
  }

  Future exportCSV() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mockData = [
      {
        "id": 1,
        "title": "On Leave",
        "last": 10,
        "number": 5,
      },
      {
        "id": 2,
        "title": "Present Workforce",
        "last": 10,
        "number": 125,
      },
      {
        "id": 3,
        "title": "Absent Workforce",
        "last": 10,
        "number": 15,
      },
      {
        "id": 4,
        "title": "Late arrivals",
        "last": 10,
        "number": 150,
      },
      {
        "id": 5,
        "title": "Total Workforce",
        "last": 10,
        "number": 150,
      },
    ];

    final mockUser = [
      {
        "id": 1,
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPlBjUyx8aUH_2vpjkZnJKT0qAk2pIvCaKF0reSEkxAiWXtdw4gzqdYr3DNQo8ek4SdkM&usqp=CAU",
        "name": "Dew",
        "position": "Graphic designer ",
        "last": "Late",
      },
      {
        "id": 2,
        "image": "https://tinypng.com/images/social/website.jpg",
        "name": "Phayan",
        "position": "IT Suport ",
        "last": "Present",
      },
      {
        "id": 2,
        "image": "https://tinypng.com/images/social/website.jpg",
        "name": "Phayan",
        "position": "IT Suport ",
        "last": "Absent",
      },
    ];

    final reportHRProvider = ref.watch(stateReportHRProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtReport.tr,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            reportHRProvider.getDepartmentModel == null
                ? GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2,
                    ),
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormatUtil.formatA(DateTime.now()),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: kTextGrey),
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 2,
                          ),
                          Text(
                            DateFormatUtil.formats(DateTime.now()),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: kTextGrey),
                          ),
                        ],
                      ).animate().fadeIn(duration: 900.ms, delay: 300.ms).move(
                          begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Text(
                        Strings.txtEmployeeAttendance,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: kBack87,
                            ),
                      ).animate().fadeIn(duration: 900.ms, delay: 300.ms).move(
                          begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          childAspectRatio: 2 / 2,
                        ),
                        itemCount: mockData.length ?? 0,
                        itemBuilder: (context, index) {
                          final data = mockData[index];

                          var dataColor = getItemColorAndIcon(
                              mockData[index]['title'].toString());
                          Color color = dataColor['color'];
                          String icons = dataColor['icon'];
                          return Container(
                            decoration: BoxDecoration(
                              color: kTextWhiteColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius:
                                            SizeConfig.heightMultiplier * 2.5,
                                        backgroundColor:
                                            color!.withOpacity(0.1),
                                        child: Image.asset(icons),
                                      ),
                                      const SizedBox(width: 8),
                                      Text.rich(
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(color: color),
                                          text: "${data['last']}% ",
                                          children: [
                                            TextSpan(
                                              text: " vs last \n  ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.9,
                                                      color: kTextGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  Text(
                                    data['title'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: color,
                                        ),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.heightMultiplier * 1),
                                  Text(
                                    data['number'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 3.5,
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 900.ms, delay: 300.ms)
                          .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                          .move(
                              begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                      Text(
                        Strings.txtEmployeeAttendance,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                            ),
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      Row(
                        children: [
                          SizedBox(
                            height: 60,
                            child: OutlinedButton(
                              onPressed: () async {},
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: kGary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  backgroundColor: kTextWhiteColor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Filter',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 2),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(ImagePath.iconFilter),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              borderRadius: BorderRadius.circular(50),
                              elevation: 0,
                              icon: const Icon(Icons.arrow_drop_down_sharp),
                              decoration: InputDecoration(
                                fillColor: kTextWhiteColor,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: kYellowFirstColor,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: kGary,
                                    width: 1,
                                  ),
                                ),
                              ),
                              hint: const Text(Strings.txtDepartment),
                              dropdownColor: kTextWhiteColor,
                              value: reportHRProvider.selectedDepartment,
                              onChanged: (String? newValue) {
                                ref
                                    .read(stateReportHRProvider)
                                    .selectedDepartment = newValue;
                              },
                              items: reportHRProvider.getDepartmentModel!.data!
                                  .asMap()
                                  .entries
                                  .map<DropdownMenuItem<String>>((entry) {
                                final item = entry.value;
                                return DropdownMenuItem<String>(
                                  value: item.departmentName,
                                  child: Text(
                                    item.departmentName
                                        .toString()
                                        .toLowerCase(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: OutlinedButton(
                                onPressed: () async {
                                  showDateDialog(context, ref);
                                },
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: kGary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: kTextWhiteColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(ImagePath.iconCalenderHR),
                                    Text(
                                      selectedDay != null
                                          ? DateFormatUtil.formatddMMy(
                                              DateTime.parse(
                                                  selectedDay.toString()))
                                          : '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.widthMultiplier * 2),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: OutlinedButton(
                                onPressed: () async {},
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: kGary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: kTextWhiteColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Strings.txtExportCsv,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2),
                                    ),
                                    Image.asset(
                                      ImagePath.iconExport,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      Container(
                        decoration: BoxDecoration(
                          color: kTextWhiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: mockUser.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = mockUser[index];
                            var dataColor = getItemColor(
                                mockUser[index]['last'].toString());
                            Color color = dataColor['color'];
                            return Container(
                              decoration: BoxDecoration(
                                color: kTextWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  item['image'].toString()),
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['name'].toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            2,
                                                      ),
                                                ),
                                                Text(
                                                  item['position'].toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            2,
                                                        color: kGreyColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        OutlinedButton(
                                          onPressed: () async {},
                                          style: OutlinedButton.styleFrom(
                                            elevation: 0,
                                            side: BorderSide(
                                                color: color, width: 0.4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor:
                                                color.withOpacity(0.10),
                                          ),
                                          child: Text(
                                            item['last'].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        2,
                                                    color: color),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> getItemColorAndIcon(String title) {
    switch (title) {
      case "On Leave":
        return {'color': Color(0xFF3786F1), 'icon': ImagePath.iconOnlave};
      case "Present Workforce":
        return {'color': Color(0xFF23A26D), 'icon': ImagePath.iconPresent};
      case "Absent Workforce":
        return {'color': Color(0xFFEE61CF), 'icon': ImagePath.iconAbsent};
      case "Late arrivals":
        return {'color': Color(0xFFFF5151), 'icon': ImagePath.iconLate};
      case "Total Workforce":
        return {'color': kBack87, 'icon': ImagePath.iconTotal};
      default:
        return {'color': Colors.blueAccent, 'icon': ImagePath.iconTotal};
    }
  }

  Map<String, dynamic> getItemColor(String title) {
    switch (title) {
      case "Present":
        return {
          'color': Color(0xFF069855),
        };
      case "Absent":
        return {
          'color': Color(0xFFEE61CF),
        };
      case "Late":
        return {
          'color': Color(0xFFD39C1D),
        };

      default:
        return {
          'color': Color(0xFFEE61CF),
        };
    }
  }
}
