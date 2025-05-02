import 'package:enterprise/components/poviders/analytic_provider/analytic_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/date_month_year/shared/month_picker.dart';
import 'package:enterprise/views/widgets/date_month_year/shared/year_picker.dart';
import 'package:flutter/material.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class NetSalaryWidget extends ConsumerStatefulWidget {
  const NetSalaryWidget({super.key});

  @override
  ConsumerState<NetSalaryWidget> createState() => _NetSalaryWidgetState();
}

class _NetSalaryWidgetState extends ConsumerState<NetSalaryWidget> {
  bool isVisible = false;

  void showDatePickerDialog(
      BuildContext context, bool isMonthPicker, WidgetRef ref) {
    final String currentLocale = Get.locale?.toString() ?? 'lo';
    final dateProvider = ref.read(stateAnalyticProvider);
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
                    selectedCellDecoration: const BoxDecoration(
                      color: kYellowFirstColor,
                      shape: BoxShape.circle,
                    ),
                    selectedCellTextStyle: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: kTextWhiteColor),
                    enabledCellsTextStyle: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: kBack87),
                    disabledCellsTextStyle: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: kGary),
                    currentDateTextStyle: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: kYellowColor),
                    currentDateDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: kYellowColor),
                    ),
                    splashColor: kYellowFirstColor,
                    slidersColor: kBack,
                    centerLeadingDate: true,
                    minDate: DateTime(2000),
                    maxDate: DateTime(2100),
                    initialDate: dateProvider.selectedMonth ?? DateTime.now(),
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
                        // ref
                        //     .read(stateAnalyticProvider.notifier)
                        //     .selectedYear = year;
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
                child: Text(Strings.txtCancel)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kYellowFirstColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(Strings.txtOkay),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: kTextWhiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: kYellowColor,
            width: 1,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Text(Strings.txtNetSalary,
                        style: Theme.of(context).textTheme.titleSmall),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 1,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? Icon(
                                Icons.visibility,
                                size: 15,
                                color: kGreyColor2,
                              )
                            : Icon(
                                Icons.visibility_off,
                                size: 15,
                                color: kGreyColor2,
                              )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDatePickerDialog(context, true, ref);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: kYellowColor),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            ref.watch(stateAnalyticProvider).selectedMonthText,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Text(isVisible ? "*****" : "14.000.000",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2.7,
                  color: Colors.green[800])),
        ],
      ),
    );
  }
}
