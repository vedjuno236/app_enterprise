import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/views/screens/requestOT/requestOT_screens.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/easy_date_time_line_picker/sealed_classes/selection_mode.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/easy_infinite_date_time/easy_infinite_date_timeline.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/easy_infinite_date_time/widgets/infinite_time_line_widget.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/properties/easy_day_props.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/utils/easy_date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateTimeBuilderWidget extends StatefulWidget {
  const DateTimeBuilderWidget({super.key});

  @override
  State<DateTimeBuilderWidget> createState() => _DateTimeBuilderWidgetState();
}

class _DateTimeBuilderWidgetState extends State<DateTimeBuilderWidget> {
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  DateTime? _focusDate = DateTime.now();

  void _changeMonth(int step) {
    setState(() {
      _focusDate = DateTime(_focusDate!.year, _focusDate!.month + step, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    const selectedColor = kYellowFirstColor;
    final unselectedColor = Colors.white.withOpacity(0.1);
    final currentLocale = Get.locale?.toString() ?? 'lo';

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM', currentLocale).format(DateTime.now()),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: SizeConfig.textMultiplier * 2.1,
                fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: () {
              context.push(PageName.calendarScreenRoute);
            },
            child: const Icon(
              Icons.chevron_right,
              size: 20,
              color: kBack,
            ),
          )
        ],
      ),
      EasyInfiniteDateTimeLine(
        selectionMode: const SelectionMode.autoCenter(),
        controller: _controller,
        firstDate: DateTime(2000),
        focusDate: _focusDate,
        lastDate: DateTime(2100),
        showTimelineHeader: false,
        onDateChange: (selectedDate) {
          // setState(() {
          //   _focusDate = selectedDate;
          // });
        },
        dayProps: const EasyDayProps(
          width: 49.0,
          height: 95.0,
        ),
        itemBuilder: (
          BuildContext context,
          DateTime date,
          bool isSelected,
          VoidCallback onTap,
        ) {
          bool isPast = date.isBefore(DateTime.now());
          return InkResponse(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  EasyDateFormatter.shortDayName(date, currentLocale),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                ),
                const SizedBox(height: 5.0),
                Flexible(
                  child: CircleAvatar(
                    backgroundColor:
                        isSelected ? selectedColor : unselectedColor,
                    radius: 19.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            date.day.toString(),
                            // style: TextStyle(
                            //   color: isPast ? kGreyColor2 : kBack87,
                            //   fontFamily: GoogleFonts.notoSansLao().fontFamily,
                            // ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: isPast ? kGreyColor2 : kBack87,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )
    ]);
  }
}
