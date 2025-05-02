import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/report_HR_provider/report_HR_provider.dart';
import 'package:enterprise/components/poviders/repuest_provider/repuest_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/text_input/custom_text_filed.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:table_calendar/table_calendar.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime.now();
});
final events = [
  {
    'date': '2025-03-13 15:30:45',
    "time": "09:00 AM",
    "keywork": "Meeting",
    "title": "Meeting with Dev team",
    "duration": "30 minutes",
    "start": '09 am - 10 am',
    "floor": "4 floor",
    "participants": [
      "https://i.chzbgr.com/full/9836262400/h06DD08DE",
      "https://i.chzbgr.com/full/9836262400/h06DD08DE",
      "https://as1.ftcdn.net/v2/jpg/05/67/05/74/1000_F_567057488_WxhGgAJAWpA8KAzTnYxQZTXS9b9Hr1zm.jpg",
    ],
    "color": Colors.blue,
  },
  {
    'date': '2025-03-20 15:30:45',
    "time": "10:00 AM",
    "keywork": "Happy",
    "title": "Happy birthday celebration 🎂🎉",
    "duration": "1 hour",
    "start": '16:30 pm - 17:00 pm',
    "floor": "3 floor",
    "participants": [
      "https://as1.ftcdn.net/v2/jpg/05/67/05/74/1000_F_567057488_WxhGgAJAWpA8KAzTnYxQZTXS9b9Hr1zm.jpg",
    ],
    "color": Colors.yellowAccent,
  },
  {
    "time": "01:00 PM",
    "keywork": "Wedding",
    'date': '2025-03-20 15:30:45',
    "title": "Koukham Wedding 👰🏻‍♀️💍🎉  ",
    "duration": "1 hour",
    "start": '09 am - 10 am ',
    "floor": "4 floor",
    "participants": [
      "https://ichef.bbci.co.uk/images/ic/480xn/p0jkdrqs.jpg.webp"
    ],
    "color": Colors.orangeAccent,
  },
  {
    'date': '2025-03-21 15:30:45',
    "time": "11:00 AM",
    "keywork": "Meeting",
    "title": "Meeting with Dev team",
    "start": '09 am - 10 am ',
    "duration": "1 hour",
    "floor": "4 floor",
    "participants": [
      "https://as1.ftcdn.net/v2/jpg/05/67/05/74/1000_F_567057488_WxhGgAJAWpA8KAzTnYxQZTXS9b9Hr1zm.jpg",
    ],
    "color": Colors.redAccent
  },
];

class CalendarScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final String currentLocale = Get.locale?.toString() ?? 'lo';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: Text(Strings.txtCalendar,
            style: Theme.of(context).textTheme.titleMedium),
        actions: [
          GestureDetector(
            onTap: () {
              buildShowModalBottomSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: kTextBack,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: kRedColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '',
                        style: TextStyle(
                          color: kTextWhiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TableCalendar(
              rowHeight: 40,
              daysOfWeekHeight: 20,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 15, color: kTextGrey),
                weekendStyle: TextStyle(fontSize: 15, color: kTextGrey),
              ),
              calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: kRedColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: kGary,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: kYellowColor,
                    shape: BoxShape.circle,
                  ),
                  outsideTextStyle: TextStyle(color: Color(0xFFB3B3B3)),
                  disabledTextStyle: TextStyle(color: kBack87),
                  defaultTextStyle: TextStyle(color: Color(0xFF293050))),
              locale: currentLocale,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              focusedDay: ref.watch(selectedDateProvider),
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2100),
              selectedDayPredicate: (day) {
                return isSameDay(ref.watch(selectedDateProvider), day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                ref.read(selectedDateProvider.notifier).state = selectedDay;
                logger.d("Selected day: $selectedDay");
              },
              eventLoader: (date) {
                return events.where((event) {
                  DateTime? eventDate =
                      DateTime.tryParse(event['date']?.toString() ?? '');
                  return eventDate != null && isSameDay(eventDate, date);
                }).toList();
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    final firstEvent = events.first;
                    if (firstEvent != null && firstEvent is Map) {
                      String keywork = firstEvent['keywork']?.toString() ?? '';
                      Map<String, dynamic> iconData =
                          getItemColorAndIcon(keywork);

                      return Positioned(
                        right: 18,
                        bottom: 32,
                        child: iconData['icon'],
                      );
                    }
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final selectedDate = ref.watch(selectedDateProvider);
                  logger.d("Filtered for date: $selectedDate");
                  final filteredEvents = events.where((event) {
                    DateTime eventDate =
                        DateTime.parse(event['date'].toString());
                    return isSameDay(eventDate, selectedDate);
                  }).toList();

                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return EventCard(event: event);
                    },
                  );
                },
              ),
            ),
          ]
              .animate()
              .slideY(duration: 1000.ms, curve: Curves.easeOutCubic)
              .fadeIn(),
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Color(0xFFF8F9FC),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Consumer(builder: (context, ref, child) {
          // final departmentProvider = ref.watch(stateReportHRProvider);
          // final departmentData = departmentProvider.getDepartmentModel;
          // final selectedIndex = ref.watch(stateRepuestprovider).selectedIndex;

          return FractionallySizedBox(
            heightFactor: 0.7,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Schedule',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                ),
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
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: Strings.txttitle.tr,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    maxLines: 4,
                    hintText: Strings.txtDescription.tr,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    prefixIcon: Image.asset(ImagePath.iconCalendar),
                    suffixIcon: const Icon(
                      Icons.arrow_right,
                    ),
                    hintText: Strings.txtDescription.tr,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: Strings.txtStrTime.tr,
                          suffixIcon: Image.asset(ImagePath.iconIn),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomTextField(
                          suffixIcon: Image.asset(ImagePath.iconOut),
                          hintText: Strings.txtEndTime.tr,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           ref.read(stateRepuestprovider).updateSelectedIndex(null);
                  //         },
                  //         child: Container(
                  //           margin: const EdgeInsets.only(right: 10),
                  //           padding: const EdgeInsets.all(8.0),
                  //           decoration: BoxDecoration(
                  //             color: selectedIndex == null
                  //                 ? getCheckStatus("All")['color'].withOpacity(0.10)
                  //                 : Color(0xFF1A7529).withOpacity(0.10),
                  //             borderRadius: BorderRadius.circular(50),
                  //             border: Border.all(
                  //               color: selectedIndex == null
                  //                   ? getCheckStatus("All")['color']
                  //                   : const Color(0xFFE4E4E7),
                  //               width: 1.0,
                  //             ),
                  //           ),
                  //           child: Row(
                  //             children: [
                  //               Container(
                  //                 height: 20,
                  //                 width: 20,
                  //                 decoration: BoxDecoration(
                  //                     color: getCheckStatus("All")['color'],
                  //                     shape: BoxShape.circle),
                  //               ),
                  //               const SizedBox(
                  //                 width: 5,
                  //               ),
                  //               Text(
                  //                 "All",
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .bodyMedium!
                  //                     .copyWith(),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       ...departmentData!.data!.map((item) {
                  //         final id = item.id.toString();
                  //         var dataStatus = getCheckStatus(item.keyWord.toString());

                  //         return GestureDetector(
                  //           onTap: () {
                  //             ref.read(stateRepuestprovider).updateSelectedIndex(int.parse(id));
                  //           },
                  //           child: Container(
                  //             margin: const EdgeInsets.only(right: 10),
                  //             padding: const EdgeInsets.all(8.0),
                  //             decoration: BoxDecoration(
                  //               color: dataStatus['color'].withOpacity(0.10),
                  //               borderRadius: BorderRadius.circular(50),
                  //               border: Border.all(
                  //                 color: selectedIndex == int.parse(id)
                  //                     ? kYellowFirstColor
                  //                     : const Color(0xFFE4E4E7),
                  //                 width: 1.0,
                  //               ),
                  //             ),
                  //             child: Row(
                  //               children: [
                  //                 Container(
                  //                   height: 20,
                  //                   width: 20,
                  //                   decoration: BoxDecoration(
                  //                       color: dataStatus['color'],
                  //                       shape: BoxShape.circle),
                  //                 ),
                  //                 const SizedBox(
                  //                   width: 5,
                  //                 ),
                  //                 Text(
                  //                   item.departmentName.toString(),
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyMedium!
                  //                       .copyWith(),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    height: SizeConfig.widthMultiplier * 12,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFDADADA),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        'Create calendar ',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: SizeConfig.textMultiplier * 1.7,
                            color: kBack),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Map<String, dynamic> getCheckStatus(String title) {
    switch (title) {
      case "All":
        return {'color': Color(0xFF1A7529)};

      case "IT":
        return {
          'color': const Color(0xFFF59E0B),
        };

      case "Marketing":
        return {
          'color': const Color(0xFFF701A75),
        };

      default:
        return {
          'color': Color(0xFF1A7529),
        };
    }
  }

  Map<String, dynamic> getItemColorAndIcon(String keywork) {
    switch (keywork) {
      case "Meeting":
        return {
          'color': const Color(0xFF23A26D),
          'icon': Text('🌺'),
        };
      case "Happy":
        return {
          'color': const Color(0xFFF45B69),
          'icon': Text('🎂🎉'),
        };
      case "Wedding":
        return {
          'color': const Color(0xFF3085FE),
          'icon': Text('⚽️'),
        };

      default:
        return {
          'color': Colors.red,
          'icon': Text('🎖️'),
        };
    }
  }
}

class EventCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> event;

  const EventCard({super.key, required this.event});

  @override
  ConsumerState<EventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<EventCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0), // แก้ไขจาก custom เป็น bottom
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.event["time"],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFfE4E4E7))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.event["title"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      checkColor: kTextWhiteColor,
                                      activeColor: kYellowFirstColor,
                                      splashRadius: 10,
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value ?? false;
                                        });
                                      })
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Before ${widget.event["duration"]}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'start ${widget.event["start"]}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.event["floor"],
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: widget.event["participants"]
                              .map<Widget>((avatar) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Align(
                                      widthFactor: 0.5,
                                      child: CircleAvatar(
                                        radius: SizeConfig.heightMultiplier * 2,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius:
                                              SizeConfig.heightMultiplier * 1.5,
                                          backgroundImage: NetworkImage(avatar),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    width: 12,
                    height: 174,
                    decoration: BoxDecoration(
                        color: _CalendarScreenState().getItemColorAndIcon(
                            widget.event["keywork"]?.toString() ?? "")['color'],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
