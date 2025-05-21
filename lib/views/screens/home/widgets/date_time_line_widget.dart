import 'package:enterprise/views/widgets/easy_date_time/src/properties/date_formatter.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/properties/day_style.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/properties/easy_day_props.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/properties/easy_header_props.dart';
import 'package:enterprise/views/widgets/easy_date_time/src/widgets/easy_date_timeline_widget/easy_date_timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/styles/size_config.dart';

class DateTimeLineWidget extends ConsumerStatefulWidget {
  const DateTimeLineWidget({super.key});

  @override
  ConsumerState<DateTimeLineWidget> createState() => _DateTimeLineWidgetState();
}

class _DateTimeLineWidgetState extends ConsumerState<DateTimeLineWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: _selectedDate,
      onDateChange: (selectedDate) {
        setState(() {
          _selectedDate = selectedDate;
        });
      },
      activeColor: const Color(0xFFFECE0A),
      headerProps: const EasyHeaderProps(
        dateFormatter: DateFormatter.monthOnly(),
      ),
      dayProps: EasyDayProps(
        height: 40,
        width: 40,
        dayStructure: DayStructure.dayNumDayStr,
        inactiveDayStyle: DayStyle(
          borderRadius: 25.0,
          dayNumStyle: TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
          dayStrStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 2.5,
            color: Colors.black54,
          ),
        ),
        activeDayStyle: DayStyle(
          borderRadius: 25.0,
          dayNumStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 2.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          dayStrStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 2.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
