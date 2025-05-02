// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/views/widgets/indicator/indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GrossIncomeWidget extends ConsumerStatefulWidget {
  const GrossIncomeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GrossIncomeWidgetState();
}

class _GrossIncomeWidgetState extends ConsumerState<GrossIncomeWidget> {
  int touchedIndex = -1;

  final List<ChartData> chartData = [
    ChartData('Basic', 20, Colors.amberAccent),
    ChartData('Position', 40, Colors.cyanAccent),
    ChartData('OT', 10, Colors.blueAccent),
    ChartData('Incentives', 30, Colors.greenAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.only(
        top: 15,
        left: 15,
        bottom: 15,
        right: 15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Strings.txtSalary,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: kGreyColor2)),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Text(
            "20.000.000",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: kBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.textMultiplier * 3),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 3,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.2,
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              series: <CircularSeries>[
                DoughnutSeries<ChartData, String>(
                  dataSource: chartData,
                  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  dataLabelMapper: (ChartData data, _) {
                    String percentage = (data.y % 1 == 0)
                        ? "${data.y.toInt()}%"
                        : "${data.y.toStringAsFixed(1)}%";
                    return percentage;
                  },
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  innerRadius: '30',
                  radius: '100%',
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Indicator(
              color: Colors.amber,
              text: 'Basic',
              isSqare: false,
              value: '10.000',
              size: 15),
          SizedBox(
            height: 10,
          ),
          Indicator(
              color: Colors.blueAccent,
              text: 'Position',
              isSqare: false,
              value: '100.000',
              size: 15),
          SizedBox(
            height: 10,
          ),
          Indicator(
              color: Colors.redAccent,
              text: 'OT',
              isSqare: false,
              value: '1.000.000',
              size: 15),
          SizedBox(
            height: 10,
          ),
          Indicator(
              color: Colors.purpleAccent,
              text: 'Incentives',
              value: '10.000',
              isSqare: false,
              size: 15),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
