import 'package:collection/collection.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/models/analytic_model/overview_attendance_month_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/key_shared.dart';
import '../../../components/constants/strings.dart';
import '../../../components/logger/logger.dart';
import '../../../components/poviders/analytic_provider/analytic_provider.dart';
import '../../../components/poviders/users_provider/users_provider.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/utils/date_format_utils.dart';
import '../../widgets/appbar/appbar_widget.dart';

class AttendanceHistory extends ConsumerStatefulWidget {
  final DateTime selectedMonth;

  const AttendanceHistory({super.key, required this.selectedMonth});

  @override
  AttendanceHistoryState createState() => AttendanceHistoryState();
}

class AttendanceHistoryState extends ConsumerState<AttendanceHistory> {
  ScrollController? _scrollController;
  int limit = 100;
  int page = 1;

  bool isLoading = false;
  bool cancelled = false;

  SharedPrefs sharedPrefs = SharedPrefs();

  Future fetchUserApi() async {
    EnterpriseAPIService()
        .callUserInfos(token: sharedPrefs.getStringNow(KeyShared.keyToken))
        .then((value) {
      ref.watch(stateUserProvider).setUserModel(value: value);
    });
  }

  Future fetchAnalyticAttendanceMonth() async {
    final userProvider = ref.read(stateUserProvider);

    String formattedDate = DateFormat('yyyy-MM').format(widget.selectedMonth);

    if (mounted) {
      setState(() => isLoading = true);
    }
    EnterpriseAPIService()
        .callAnalyticAttendanceMonth(
      userID: userProvider.getUserModel!.data!.id ?? 0,
      month: formattedDate,
      perPage: limit,
      currentPage: page,
    )
        .then((value) {
      if (!cancelled) {
        ref.watch(stateAnalyticProvider).setAnalyticMonthModel(value: value);
      }
    }).catchError((onError) {
      logger.e("onError Attendance $onError");
      if (onError.runtimeType.toString() == 'DioError') {}
    }).whenComplete(() {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    fetchAnalyticAttendanceMonth();

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.atEdge) {
        if (_scrollController!.position.pixels == 0) {
          if (mounted) {
            setState(() {
              page--;
              fetchAnalyticAttendanceMonth();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              page++;
              fetchAnalyticAttendanceMonth();
            });
          }
        }
      }
    });
  }

  void cancel() {
    cancelled = true;
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (int.parse(ref
            .watch(stateAnalyticProvider)
            .getAttendanceModel!
            .data!
            .currentPage
            .toString()) >
        1) {
      if (mounted) {
        setState(() {
          page--;
          fetchAnalyticAttendanceMonth();
        });
      }
    }

    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (int.parse(ref
            .watch(stateAnalyticProvider)
            .getAttendanceModel!
            .data!
            .currentPage
            .toString()) <
        int.parse(ref
            .watch(stateAnalyticProvider)
            .getAttendanceModel!
            .data!
            .totalPages
            .toString())) {
      if (mounted) {
        setState(() {
          page++;
          fetchAnalyticAttendanceMonth();
        });
      }
    }
    // print("_onLoading");
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final analyticState = ref.watch(stateAnalyticProvider);
final isDataEmpty = analyticState.getAttendanceModel?.data?.items?.isEmpty ?? true;

    final dataProvider = ref.watch(stateAnalyticProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: Text(
          Strings.txtAttendanceHistory.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 500.ms)
            .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              // child: Icon(
              //   Ionicons.options_outline,
              //   size: 24.0,
              // ),
              child: const Icon(
                IonIcons.options,
                size: 24.0,
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 500.ms)
                .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isDataEmpty
              ?   GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2),
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
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Text(
                  //     "Attendance History ${analyticState.getAnalyticModel!.data!.length} day"),
                  // const SizedBox(height: 10),
                  Expanded(
                      child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          header: const WaterDropMaterialHeader(
                            backgroundColor: kYellowFirstColor,
                            color: kTextWhiteColor,
                          ),
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = const Text(Strings.txtPull);
                              } else if (mode == LoadStatus.loading) {
                                body = const CupertinoActivityIndicator();
                              } else if (mode == LoadStatus.failed) {
                                body = const Text(Strings.txtLoadFailed);
                              } else if (mode == LoadStatus.canLoading) {
                                body = const Text(Strings.txtLoadMore);
                              } else {
                                body = const Text(Strings.txtMore);
                              }
                              return SizedBox(
                                height: 55.0,
                                child: Center(child: body),
                              );
                            },
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: analyticState
                                    .getAttendanceModel?.data?.items?.length ??
                                0,
                            itemBuilder: (context, index) {
                              final userItem = analyticState
                                  .getAttendanceModel!.data!.items![index];

                              final dateKey = userItem.date;
                              final attendanceRecords =
                                  userItem.attendanceRecordResponse ?? [];

                              final lastOutRecord =
                                  attendanceRecords.firstWhereOrNull(
                                (record) => record.typeClock == 'OUT',
                              );

                              final lastTotalHours =
                                  lastOutRecord?.totalHours ?? "00:00";

                              logger.d(lastTotalHours);

                              final isToday = DateTime.parse(dateKey.toString())
                                          .year ==
                                      DateTime.now().year &&
                                  DateTime.parse(dateKey.toString()).month ==
                                      DateTime.now().month &&
                                  DateTime.parse(dateKey.toString()).day ==
                                      DateTime.now().day;

                              String formatDate(String? dateString) {
                                if (dateString == null || dateString.isEmpty) {
                                  return '- - - -';
                                }
                                try {
                                  final dateTime = DateTime.parse(dateString);
                                  return DateFormat('HH:mm').format(dateTime);
                                } catch (e) {
                                  return dateString;
                                }
                              }

                              Map<String, dynamic> showLocation(
                                  String keyWord, String? recordTitle) {
                                if (keyWord == "REMOTE") {
                                  return {
                                    'text': recordTitle ?? 'ນອກຫ້ອງການ'
                                  }; // If recordTitle is null, default to 'ນອກຫ້ອງການ'
                                } else if (keyWord == "OFFICE") {
                                  return {'text': 'ຫ້ອງການ'};
                                }
                                return {'text': ''};
                              }

                              bool isValidDate(String? dateString) {
                                try {
                                  if (dateString == null ||
                                      dateString.isEmpty) {
                                    return false;
                                  }

                                  DateTime attendanceDate =
                                      DateTime.parse(dateString);
                                  DateTime now = DateTime.now();

                                  return attendanceDate
                                      .isBefore(now.add(Duration(days: 0)));
                                } catch (e) {
                                  return false;
                                }
                              }

                              if (!isValidDate(dateKey)) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: kTextWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isToday ? kYellowFirstColor : kGary,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Date and Day Header
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              const Color(0xFFEFEFFF),
                                          child: Image.asset(
                                              ImagePath.iconCalende2),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            DateFormatUtil.formatA(
                                                DateTime.parse(dateKey!)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        Text(
                                          isToday
                                              ? Strings.txtToday.tr
                                              : DateFormatUtil.formatD(
                                                  DateTime.parse(dateKey)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () {
                                            logger.d(userItem.date);
                                            ref
                                                .read(stateAnalyticProvider
                                                    .notifier)
                                                .toggleDropdown(index);
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color(0xFFEFEFFF),
                                            child: Icon(ref
                                                        .watch(
                                                            stateAnalyticProvider)
                                                        .dropdownState[index] ==
                                                    true
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Hours Summary Box
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F6FA),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Total Hours
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Strings.txtTotalHours.tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.grey[600],
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${lastTotalHours} hrs',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          // Overtime Hours
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'OT',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.grey[600],
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${lastTotalHours} hrs', // Use actual OT hours here
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    ...attendanceRecords.map((record) {
                                      final bool isIn =
                                          record.typeClock == 'IN';
                                      final String timeStr =
                                          formatDate(record.createdAt);

                                      final isLate = record.statusLate == false;
                                      logger.d(isLate);

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: isIn
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  isIn
                                                      ? Strings.txtIn.tr
                                                      : Strings.txtOut.tr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: kTextGrey,
                                                      ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  timeStr,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isLate
                                                              ? kBack87
                                                              : kRedColor),
                                                ),
                                              ],
                                            ),
                                            // if (dataProvider.isDropdownOpenData)
                                            if (ref
                                                    .watch(
                                                        stateAnalyticProvider)
                                                    .dropdownState[index] ==
                                                true)
                                              Row(
                                                children: [
                                                  CustomPaint(
                                                    size: const Size(0, 40),
                                                    painter:
                                                        DashedLinePainter(),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5.0),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFF5F6FA),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: kG,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              FontAwesome
                                                                  .location_dot_solid,
                                                              size: 15,
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              showLocation(
                                                                      record
                                                                          .type
                                                                          .toString(),
                                                                      record
                                                                          .title)['text'] ??
                                                                  '', // Ensure correct argument is passed
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            const Divider(
                                              color: kGary,
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms, delay: 400.ms)
                                  .move(
                                    begin: const Offset(-16, 0),
                                    curve: Curves.easeOutQuad,
                                  );
                            },
                          )))
                ])),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashHeight = 5;
    const double dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
