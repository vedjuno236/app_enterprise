import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  /// The minimum date that can be selected on the calendar
  final DateTime? minimumDate;

  /// The maximum date that can be selected on the calendar
  final DateTime? maximumDate;

  /// The initial start date to be shown on the calendar
  final DateTime? initialStartDate;

  /// The initial end date to be shown on the calendar
  final DateTime? initialEndDate;

  /// The primary color to be used in the calendar's color scheme
  final Color primaryColor;

  /// A function to be called when the selected date range changes
  final Function(DateTime, DateTime)? startEndDateChange;

  const CustomCalendar({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    this.startEndDateChange,
    this.minimumDate,
    this.maximumDate,
    required this.primaryColor,
  }) : super(key: key);

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  List<DateTime> dateList = <DateTime>[];

  DateTime currentMonthDate = DateTime.now();

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentLocale = Get.locale?.toString() ?? 'lo';

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: const Color(0xFFFCED3DE),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      onTap: () {
                        setState(() {
                          currentMonthDate = DateTime(
                              currentMonthDate.year, currentMonthDate.month, 0);
                          setListOfDate(currentMonthDate);
                        });
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_left,
                        // color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        DateFormat('MMMM', currentLocale)
                            .format(currentMonthDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          // color: Color(0xFF222B45),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        DateFormat(' yyyy').format(currentMonthDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          // color: Color(0xFF8F9BB3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Color(0xFFFCED3DE),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      onTap: () {
                        setState(() {
                          currentMonthDate = DateTime(currentMonthDate.year,
                              currentMonthDate.month + 2, 0);
                          setListOfDate(currentMonthDate);
                        });
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        // color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: startDate != null
                            ? DateFormatUtil.formatC(startDate!)
                            : Strings.txtFromDate.tr,
                        // labelText: Strings.txtFromDate.tr,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                fontSize: SizeConfig.textMultiplier * 1.5),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: kGary, width: 0.5),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: kGary, width: 0.5),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: kGary, width: 0.5),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        prefixIcon: Image.asset(
                          ImagePath.iconCalendar,
                          color: Color(0xFF23A26D),
                        ),
                        fillColor: Theme.of(context).canvasColor,
                        filled: true,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                       
                        labelText: endDate != null
                            ? DateFormatUtil.formatC(endDate!)
                            : startDate != null
                                ? DateFormatUtil.formatC(startDate!)
                                : Strings.txtToDate.tr,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                fontSize: SizeConfig.textMultiplier * 1.5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kGary, width: 1),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: kGary, width: 0.5),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kGary, width: 1),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        prefixIcon: Image.asset(
                          ImagePath.iconCalendar,
                          color: Color(0xFFCE1126),
                        ),
                        fillColor: Theme.of(context).canvasColor,
                        filled: true,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
          child: Row(
            children: getDaysNameUI(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            children: getDaysNoUI(),
          ),
        ),
      ],
    );
  }

  List<Widget> getDaysNameUI() {
    final String currentLocale = Get.locale?.toString() ?? 'lo';

    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEE', currentLocale).format(dateList[i]),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 2,
                            bottom: 2,
                            left: isStartDateRadius(date) ? 4 : 0,
                            right: isEndDateRadius(date) ? 4 : 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: startDate != null && endDate != null
                                ? getIsItStartAndEndDate(date) ||
                                        getIsInRange(date)
                                    ? kYellowColor.withOpacity(0.8)
                                    : Colors.transparent
                                : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: isStartDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                              topLeft: isStartDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                              topRight: isEndDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                              bottomRight: isEndDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {
                        if (currentMonthDate.month == date.month) {
                          if (widget.minimumDate != null &&
                              widget.maximumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isAfter(newminimumDate) &&
                                date.isBefore(newmaximumDate)) {
                              onDateClick(date);
                            }
                          } else if (widget.minimumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            if (date.isAfter(newminimumDate)) {
                              onDateClick(date);
                            }
                          } else if (widget.maximumDate != null) {
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isBefore(newmaximumDate)) {
                              onDateClick(date);
                            }
                          } else {
                            onDateClick(date);
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: getIsItStartAndEndDate(date)
                                ? Color(0xFFFFCE08)
                                : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32.0)),
                            border: _isCurrentDate(date)
                                ? Border.all(
                                    color: kGary,
                                    width: 2,
                                  )
                                : null,
                            boxShadow: getIsItStartAndEndDate(date)
                                ? <BoxShadow>[
                                    BoxShadow(
                                        color:
                                            Color(0xFFFFCE08).withOpacity(0.6),
                                        blurRadius: 4,
                                        offset: const Offset(0, 0)),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: _isCurrentDate(date)
                                    ? kBack
                                    : date.isBefore(DateTime.now())
                                        ? kGreyColor2
                                        : getIsItStartAndEndDate(date)
                                            ? Theme.of(context)
                                                .primaryColorLight
                                            : currentMonthDate.month ==
                                                    date.month
                                                ? Theme.of(context)
                                                    .primaryColorLight
                                                : kG,
                                fontSize:
                                    MediaQuery.of(context).size.width > 360
                                        ? 18
                                        : 16,
                                fontWeight: getIsItStartAndEndDate(date)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool _isCurrentDate(DateTime date) {
    final DateTime now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    // If no start date is selected, set the start date
    if (startDate == null) {
      startDate = date;
    }
    // If start date exists but no end date
    else if (startDate != null && endDate == null) {
      // Allow selecting any date relative to the start date
      if (date != startDate) {
        endDate = date;
      }
    }
    // If both start and end dates exist
    else if (startDate != null && endDate != null) {
      // Reset selection if clicking on an existing date
      if (date == startDate) {
        startDate = null;
        endDate = null;
      } else if (date == endDate) {
        endDate = null;
      } else {
        // Allow flexible selection between dates
        if (date.isBefore(startDate!)) {
          startDate = date;
        } else if (date.isAfter(endDate!)) {
          endDate = date;
        } else {
          // If date is between start and end, update accordingly
          if (date.difference(startDate!).inDays <
              endDate!.difference(date).inDays) {
            startDate = date;
          } else {
            endDate = date;
          }
        }
      }
    }

    // Ensure dates are in correct order if both exist
    if (startDate != null && endDate != null) {
      if (endDate!.isBefore(startDate!)) {
        final DateTime temp = startDate!;
        startDate = endDate;
        endDate = temp;
      }
    }

    setState(() {
      try {
        widget.startEndDateChange!(startDate!, endDate ?? startDate!);
      } catch (_) {}
    });

    // Modify getIsInRange to check if date is between start and end dates
    bool getIsInRange(DateTime date) {
      if (startDate != null && endDate != null) {
        return (date.isAfter(startDate!) && date.isBefore(endDate!)) ||
            (date.isBefore(startDate!) && date.isAfter(endDate!));
      }
      return false;
    }

    bool _isCurrentDate(DateTime date) {
      final DateTime now = DateTime.now();
      return date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;
    }
  }
}
