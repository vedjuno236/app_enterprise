import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/views/widgets/custom_date_range_picker/custom_calendar.dart.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomDateRangePicker extends StatefulWidget {
  /// The minimum date that can be selected in the calendar.
  final DateTime minimumDate;

  /// The maximum date that can be selected in the calendar.
  final DateTime maximumDate;

  /// Whether the widget can be dismissed by tapping outside of it.
  final bool barrierDismissible;

  /// The initial start date for the date range picker. If not provided, the calendar will default to the minimum date.
  final DateTime? initialStartDate;

  /// The initial end date for the date range picker. If not provided, the calendar will default to the maximum date.
  final DateTime? initialEndDate;

  /// The primary color used for the date range picker.
  final Color primaryColor;

  /// The background color used for the date range picker.
  final Color backgroundColor;

  /// A callback function that is called when the user applies the selected date range.
  final Function(DateTime, DateTime) onApplyClick;

  /// A callback function that is called when the user cancels the selection of the date range.
  final Function() onCancelClick;

  const CustomDateRangePicker({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    required this.primaryColor,
    required this.backgroundColor,
    required this.onApplyClick,
    this.barrierDismissible = true,
    required this.minimumDate,
    required this.maximumDate,
    required this.onCancelClick,
  }) : super(key: key);

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();
}

class CustomDateRangePickerState extends State<CustomDateRangePicker>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(
                    color: const Color(0xFFFDC604),
                    width: 1.0,
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'ຈາກວັນທີ',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    startDate != null
                                        ? DateFormatUtil.formatedm(
                                            startDate!, null)
                                        : '',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: kYellowColor.withOpacity(0.4),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'ຫາວັນທີ',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    endDate != null
                                        ? DateFormatUtil.formatedm(
                                            endDate!, null)
                                        : '',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: kYellowColor.withOpacity(0.4),
                      ),
                     
                      CustomCalendar(
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        initialEndDate: widget.initialEndDate,
                        initialStartDate: widget.initialStartDate,
                        primaryColor: widget.primaryColor,
                        startEndDateChange:
                            (DateTime startDateData, DateTime endDateData) {
                          setState(() {
                            startDate = startDateData;
                            endDate = endDateData;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 110,
                              height: 48,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0)),
                              ),
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  side: WidgetStateProperty.all(
                                      BorderSide(color: Color(0xFFE4E4E7))),
                                  shape: WidgetStateProperty.all(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                    ),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                      Color(0xFFE4E4E7)),
                                ),
                                onPressed: () {
                                  try {
                                    widget.onCancelClick();
                                    Navigator.pop(context);
                                  } catch (_) {}
                                },
                                child: Center(
                                  child: Text(
                                    Strings.txtCancel.tr,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 110,
                              height: 48,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0)),
                              ),
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  side:
                                      WidgetStateProperty.all(const BorderSide(
                                    color: Color(0xFFFDC604),
                                  )),
                                  shape: WidgetStateProperty.all(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                    ),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    Color(0xFFFDC604),
                                  ),
                                ),
                                onPressed: () {
                                  try {
                                    if (startDate != null) {
                                      widget.onApplyClick(
                                          startDate!, endDate ?? startDate!);
                                    }

                                    Navigator.pop(context);
                                  } catch (e) {}
                                },
                                child: Center(
                                  child: Text(
                                    Strings.txtOkay.tr,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomDateRangePicker(
  BuildContext context, {
  required bool dismissible,
  required DateTime minimumDate,
  required DateTime maximumDate,
  DateTime? startDate,
  DateTime? endDate,
  required Function(DateTime startDate, DateTime endDate) onApplyClick,
  required Function() onCancelClick,
  required Color backgroundColor,
  required Color primaryColor,
  String? fontFamily,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) => CustomDateRangePicker(
      barrierDismissible: true,
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      initialStartDate: startDate,
      initialEndDate: endDate,
      onApplyClick: onApplyClick,
      onCancelClick: onCancelClick,
    ),
  );
}



//  void onDateClick(DateTime date) {
//   if (startDate == null) {
//     startDate = date;
//   } else if (startDate != date && endDate == null) {
//     endDate = date;
//   } else if (startDate!.day == date.day && startDate!.month == date.month) {
//     startDate = null;
//   } else if (endDate != null && endDate!.day == date.day && endDate!.month == date.month) {
//     endDate = null;
//   }

//   // If only start date exists, use it as both start and end date
//   if (startDate != null && endDate == null) {
//     endDate = startDate;
//   }

//   setState(() {
//     try {
//       widget.startEndDateChange!(startDate!, endDate!);
//     } catch (_) {}
//   });
// }


 // void onDateClick(DateTime date) {
  //   if (startDate == null) {
  //     startDate = date;
  //   } else if (startDate != date && endDate == null) {
  //     endDate = date;
  //   } else if (startDate!.day == date.day && startDate!.month == date.month) {
  //     startDate = null;
  //   } else if (endDate!.day == date.day && endDate!.month == date.month) {
  //     endDate = null;
  //   }
  //   if (startDate == null && endDate != null) {
  //     startDate = endDate;
  //     endDate = null;
  //   }
  //   if (startDate != null && endDate != null) {
  //     if (!endDate!.isAfter(startDate!)) {
  //       final DateTime d = startDate!;
  //       startDate = endDate;
  //       endDate = d;
  //     }
  //     if (date.isBefore(startDate!)) {
  //       startDate = date;
  //     }
  //     if (date.isAfter(endDate!)) {
  //       endDate = date;
  //     }
  //   }
  //   setState(() {
  //     try {
  //       widget.startEndDateChange!(startDate!, endDate!);
  //     } catch (_) {}
  //   });
  // }