import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_provider.dart';
import 'package:enterprise/components/poviders/users_provider/users_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/views/widgets/chart_widgte/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class PieChartWidget extends ConsumerStatefulWidget {
  const PieChartWidget({super.key});

  @override
  ConsumerState<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends ConsumerState<PieChartWidget> {
  int touchedIndex = -1;
  bool isloadingLeave = false;

  Future fetchLeaveTypeApi() async {
    final userProvider = ref.read(stateUserProvider);
    setState(() => isloadingLeave = true);

    try {
      final value = await EnterpriseAPIService().callLeaveType(
        userID: userProvider.getUserModel!.data!.id ?? 0,
      );
      ref.read(stateLeaveProvider).setLeaveTypeModels(value: value);
    } catch (onError) {
      errorDialog(context: context, onError: onError);
    } finally {
      setState(() => isloadingLeave = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLeaveTypeApi();
  }

  @override
  Widget build(BuildContext context) {
    final leaveType = ref.watch(stateLeaveProvider);
    final totalUsedDays = leaveType.getLeaveTypeModel!.data!
        .fold<double>(0, (sum, leave) => sum + (leave.used ?? 0.0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          '${(totalUsedDays != null) ? (totalUsedDays! % 1 == 0 ? totalUsedDays!.toInt().toString() : totalUsedDays!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
              .tr,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: SizeConfig.textMultiplier * 2.3,
              fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 2.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: leaveType.getLeaveTypeModel!.data!
                    .asMap()
                    .entries
                    .map((entry) {
                  final leave = entry.value;
                  var dataColor = getItemColor(leave.keyWord.toString());
                  Color color = dataColor['color'];
                  String txt = dataColor['txt'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Indicator(
                      text: txt ?? '',
                      color: color,
                      isSquare: true,
                      size: 10,
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                      sections: leaveType.getLeaveTypeModel!.data!
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final leave = entry.value;
                        final isTouched = index == touchedIndex;
                        final radius = isTouched ? 60.0 : 50.0;
                        final total = leave.total ?? 0.0;
                        final used = leave.used ?? 0.0;
                        var dataColor = getItemColor(leaveType
                            .getLeaveTypeModel!.data![index].keyWord
                            .toString());
                        Color color = dataColor['color'];

                        return PieChartSectionData(
                          color: color,
                          // value: (used / total) * 100,
                          value: used.toDouble(),
                          title:
                              '${(leave.used != null) ? (leave.used! % 1 == 0 ? leave.used!.toInt().toString() : leave.used!.toStringAsFixed(1)) : '-'} ${Strings.txtdays.tr}'
                                  .tr,
                          radius: radius,
                          titleStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: kTextWhiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.textMultiplier * 1.2),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Map<String, dynamic> getItemColor(String keywrd) {
  keywrd = keywrd.toUpperCase();
  switch (keywrd) {
    case "ANNUAL":
      return {'color': Color(0xFF3085FE), 'txt': Strings.txtAnnual.tr};
    case "LAKIT":
      return {'color': Color(0xFFF45B69), 'txt': Strings.txtLakit.tr};
    case "SICK":
      return {'color': Color(0xFF23A26D), 'txt': Strings.txtSick.tr};
    case "MATERNITY":
      return {'color': Color(0xFFF59E0B), 'txt': Strings.txtMaternity.tr};
    default:
      return {
        'color': Colors.grey,
        'txt': keywrd,
      };
  }
}
