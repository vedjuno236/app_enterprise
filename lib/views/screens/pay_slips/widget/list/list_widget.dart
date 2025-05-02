// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/poviders/values_provider/get_value_color_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/screens/pay_slips/widget/gross_income/gross_income_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:enterprise/views/widgets/indicator/indicator.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ListWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String value;
  final String percentPaidOff;
  final String valueMicrofinance;
  final String valueNCCFund;
  final DateTime date;
  final TextStyle? valueStyle;

  ListWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.percentPaidOff,
    required this.valueMicrofinance,
    required this.valueNCCFund,
    required this.date,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = getValueColor(value);

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: kGary,
          child: Image.asset(
            getItemColorAndIcon(title)['icon'],
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image_not_supported,
                  size: 30, color: Colors.red);
            },
          ),
        ),
        title: Text(
          title,
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(color: kBack87),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: kTextGrey),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Color(0xFf058A53)),
            ),
            Text(DateFormat('dd-MM-yyyy').format(date)),
          ],
        ),
        onTap: () => showBottomSheet(context),
      ),
    );
  }

  Map<String, dynamic> getItemColorAndIcon(String title) {
    switch (title) {
      case "Basic":
        return {
          'color': const Color(0xFF23A26D),
          'icon': "assets/logo/Basic.png"
        };
      case "Position":
        return {
          'color': const Color(0xFFF45B69),
          'icon': "assets/logo/position.png"
        };
      case "OT":
        return {'color': const Color(0xFF3085FE), 'icon': "assets/logo/ot.png"};
      case "Incentives":
        return {
          'color': const Color(0xFFF59E0B),
          'icon': "assets/logo/incentives.png"
        };

      default:
        return {'color': Colors.red, 'icon': "assets/logo/Basic.png"};
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DefaultTabController(
          length: 2,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 1),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    decoration: BoxDecoration(
                        color: kTextWhiteColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: SizeConfig.widthMultiplier * 1,
                                ),
                                Text(
                                  "${Strings.txtPaidOff} : $percentPaidOff",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: kTextGrey),
                                ),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 0.5),
                                Text(
                                  value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: kBack87,
                                          fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 2),
                                Indicator(
                                    color: kpurple,
                                    text: "Microfinance",
                                    isSqare: false,
                                    size: 15,
                                    value: value),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 0.5),
                                Indicator(
                                    color: kYellowColor,
                                    text: "NCC Fund",
                                    isSqare: false,
                                    size: 15,
                                    value: value),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        width: 1, color: kYellowColor),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'NCC Fund',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(),
                                          ),
                                          const Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Container(
                                //   width: 100,
                                //   height: 100,
                                //   decoration: BoxDecoration(color: Colors.black),
                                // )
                              ],
                            )
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Circular Chart
                            Center(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: SfCircularChart(
                                  margin: EdgeInsets.zero,
                                  series: <CircularSeries>[
                                    RadialBarSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) =>
                                          data.category,
                                      yValueMapper: (ChartData data, _) =>
                                          data.value,
                                      pointColorMapper: (ChartData data, _) =>
                                          data.color,
                                      trackColor: Colors
                                          .grey.shade200, // Background track
                                      cornerStyle: CornerStyle.bothCurve,
                                      gap: '20%',
                                      innerRadius:
                                          '50%', // Creates space for the profile image
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              '59 %',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Color(0xFF0AA263),
                                      fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      color: kTextWhiteColor,
                      border: Border.all(
                        color: kYellowColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text("Balance left All"),
                        SizedBox(height: SizeConfig.heightMultiplier * 1),
                        Text(
                          "5.700.000",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.textMultiplier * 2.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: TabBar(
                      dividerColor: kGary,
                      indicatorColor: kYellowColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          text: "Paid",
                        ),
                        Tab(
                          text: "Unpaid",
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TabBarView(children: [
                      buildList(),
                      buildList(),
                    ]),
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildList() {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.lock_clock_outlined,
        'month': 'November',
        'date': "${DateFormat('dd-MM-yyyy').format(date)}",
        'value': '-2.000.000'
      },
      {
        'icon': Icons.restaurant_menu,
        'month': 'November',
        'date': "${DateFormat('dd-MM-yyyy').format(date)}",
        'value': '-2.000.000'
      },
      {
        'icon': Icons.stacked_bar_chart_outlined,
        'month': 'November',
        'date': "${DateFormat('dd-MM-yyyy').format(date)}",
        'value': '-2.000.000'
      },
      {
        'icon': Icons.attach_money_outlined,
        'month': 'November',
        'date': "${DateFormat('dd-MM-yyyy').format(date)}",
        'value': '-2.000.000'
      },
    ];
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final valueColor = getValueColor(item['value']);
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: kGary,
            ),
            minLeadingWidth: 40,
            title: Text(item['month']!),
            subtitle: Text(item['date']!),
            trailing: Text(item['value']!,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: valueColor)),
          );
        });
  }
}

final List<ChartData> chartData = [
  ChartData('ມາວຽກ', 90, Colors.blueAccent),
  ChartData('ມາຊ້າ', 10, Colors.orange),
];

class ChartData {
  final String category;
  final double value;
  final Color color;
  ChartData(this.category, this.value, this.color);
}

class ChartDataPie {
  final String category;
  final double value;
  final Color color;

  ChartDataPie(this.category, this.value, this.color);

  // Calculate percentage based on total value
  double percentage(List<ChartDataPie> dataList) {
    double total = dataList.fold(0, (sum, item) => sum + item.value);
    return (value / total) * 100;
  }
}
