import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/bottom_sheet_push/bottom_sheet_push.dart';
import 'package:enterprise/views/widgets/date_month_year/shared/month_picker.dart';
import 'package:enterprise/views/widgets/date_month_year/shared/year_picker.dart';
import 'package:enterprise/views/widgets/text_input/custom_text_filed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/logger/logger.dart';
import '../../../components/mock/mock.dart';
import '../../../components/poviders/analytic_provider/analytic_provider.dart';
import '../../../components/poviders/leave_provider/leave_history_provider/leave_histoy_provider.dart';
import '../../../components/poviders/values_provider/color_provider.dart';
import '../../../components/styles/size_config.dart';

class RequestOtHistory extends ConsumerStatefulWidget {
  const RequestOtHistory({super.key});

  @override
  ConsumerState createState() => _RequestOtHistoryState();
}

class _RequestOtHistoryState extends ConsumerState<RequestOtHistory> {
  @override
  Widget build(BuildContext context) {
    final leaveHistoryNotifier = ref.watch(leaveHistoryProvider);
    final selectedIndex = leaveHistoryNotifier.selectedIndex;

    void showDatePickerDialog(
        BuildContext context, bool isMonthPicker, WidgetRef ref) {
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
              child: isMonthPicker
                  ? MonthPicker(
                      selectedCellDecoration: BoxDecoration(
                          color: kYellowFirstColor,
                          borderRadius: BorderRadius.circular(50)),
                      leadingDateTextStyle:
                          const TextStyle(color: kBack, fontSize: 18),
                      splashColor: kYellowFirstColor,
                      slidersColor: kBack,
                      centerLeadingDate: true,
                      minDate: DateTime(2000),
                      maxDate: DateTime(2100),
                      initialDate: DateTime.now(),
                      onDateSelected: (month) {
                        ref.read(stateAnalyticProvider.notifier).selectedMonth =
                            month;
                        logger.d(DateFormat.MMMM().format(month));
                      },
                    )
                  : Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: const TextTheme(
                          bodyMedium: TextStyle(color: kBack, fontSize: 18),
                        ),
                        colorScheme: const ColorScheme.light(
                          primary: kYellowFirstColor,
                          onPrimary: kTextWhiteColor,
                          onSurface: kBack,
                        ),
                      ),
                      child: YearsPicker(
                        minDate: DateTime(2000),
                        maxDate: DateTime(2100),
                        onDateSelected: (year) {
                          ref
                              .read(stateAnalyticProvider.notifier)
                              .selectedYear = year;
                          logger.d(DateFormat.y().format(year));
                          // Handle selected date
                        },
                      ),
                    ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: kGary,
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: kYellowFirstColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    List<Color> randomColors = getUniqueRandomColors(customColors, 4);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kTextWhiteColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ທ່ານມີ OT',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 1.5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '10 days',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2.5),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: SizeConfig.heightMultiplier * 6,
                      decoration: BoxDecoration(
                        color: kYellowFirstColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDatePickerDialog(context, true, ref);
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
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
                                const Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kTextWhiteColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: mockDataOT.map((category) {
                    final id = category['id'].toString();
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(leaveHistoryProvider)
                              .updateSelectedIndex(int.parse(id));
                        },
                        child: Container(
                          width: SizeConfig.widthMultiplier * 25,
                          decoration: BoxDecoration(
                            color: selectedIndex == int.parse(id)
                                ? kYellowColor
                                : null,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              category['category'].toString(),
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
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final selectedIndex = leaveHistoryNotifier.selectedIndex;
                  final selectedCategory = mockDataOT.firstWhere(
                    (category) => category['id'] == selectedIndex,
                    orElse: () => <String, Object>{},
                  );
                  final laveList = selectedCategory['Leave'] as List?;
                  if (laveList == null || laveList.isEmpty) {
                    return const Center(child: Text("No news ."));
                  }
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: laveList.length,
                      itemBuilder: (context, index) {
                        final data = laveList[index];
                        print("🪙💰 :$data");
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 9, horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              bottomSheetPushForme(context);
                            },
                            child: Container(
                              height: SizeConfig.heightMultiplier * 23,
                              decoration: BoxDecoration(
                                color: kTextWhiteColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius:
                                              SizeConfig.heightMultiplier * 2.2,
                                          backgroundColor: randomColors[index]
                                              .withOpacity(0.1),
                                          child: SvgPicture.network(
                                            data['icon'],
                                            height:
                                                SizeConfig.imageSizeMultiplier *
                                                    7,
                                            placeholderBuilder: (context) =>
                                                const CircularProgressIndicator(),
                                            color: randomColors[index],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(data['title'].toString())
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: SizeConfig.heightMultiplier * 9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kGreyColor1,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Leave Date'),
                                                    Text(
                                                        data['date'].toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.9,
                                                            )),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Total Leave',
                                                    ),
                                                    Text(
                                                        data['totalData']
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
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
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Row(
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
                                                    randomColors[index],
                                                child: Icon(
                                                  Icons.check,
                                                  size: SizeConfig
                                                          .imageSizeMultiplier *
                                                      4,
                                                  color: kTextWhiteColor,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Text(data['status'].toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          fontSize: SizeConfig
                                                                  .textMultiplier *
                                                              1.5,
                                                          color: randomColors[
                                                              index])),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 0.0,
                                                ),
                                                // Optional: Adds space between images
                                                child: CircleAvatar(
                                                  radius: SizeConfig
                                                          .heightMultiplier *
                                                      3,
                                                  // Outer circle size
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: SizeConfig
                                                            .heightMultiplier *
                                                        2,
                                                    // Inner circle size
                                                    backgroundImage:
                                                        NetworkImage(
                                                            data['user']
                                                                ['profileImg']),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void bottomSheetPushForme(BuildContext context) {
    return bottomSheetPushContainerFormeOT(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          Strings.txtReasonOT,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  ' ປະເພດ OT',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hintText: Strings.txtRequestTitle.tr,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? null : null,
                ),
                const SizedBox(width: 10),
                Text(
                  ' ວັນທີ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  prefixIcon: Image.asset(ImagePath.iconCalendar),
                  hintText: Strings.txtDescription.tr,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? null : null,
                ),
                const SizedBox(height: 10),
                Text(
                  ' ເວລາ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        suffixIcon: Image.asset(ImagePath.iconIn),
                        hintText: Strings.txtDescription.tr,
                        validator: (value) =>
                            (value == null || value.isEmpty) ? null : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        suffixIcon: Image.asset(ImagePath.iconOut),
                        hintText: Strings.txtDescription.tr,
                        validator: (value) =>
                            (value == null || value.isEmpty) ? null : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Text(
                  'ເຫດຜົນຂໍຢູ່ OT',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  maxLines: 6,
                  hintText: Strings.txtPLeaseEnter.tr,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? null : null,
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(color: kTextWhiteColor),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: SizeConfig.heightMultiplier * 1.2,
                              backgroundColor: kBColor,
                              child: Icon(
                                Icons.check,
                                size: SizeConfig.imageSizeMultiplier * 4,
                                color: kTextWhiteColor,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Approved at 19 Sept 2024',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: kBColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'By',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: kBack),
                            ),
                            CircleAvatar(
                              radius: SizeConfig.heightMultiplier * 2,
                              backgroundImage: const NetworkImage(
                                  "https://images.ctfassets.net/hrltx12pl8hq/3Z1N8LpxtXNQhBD5EnIg8X/975e2497dc598bb64fde390592ae1133/spring-images-min.jpg"),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Kouved',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: kBack),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: const AppbarWidget(),
      title: Text(
        Strings.txtAllRequestHistory,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
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
    );
  }
}
