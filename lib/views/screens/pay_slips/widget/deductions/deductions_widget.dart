// ignore_for_file: prefer_const_constructors

import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/screens/pay_slips/widget/deductions/deductions_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enterprise/components/constants/strings.dart';

class DeductionsWidget extends ConsumerStatefulWidget {
  const DeductionsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeductionsWidgetState();
}

class _DeductionsWidgetState extends ConsumerState<DeductionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.txtReductions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: SizeConfig.textMultiplier * 2, color: kGreyColor2)),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Text("300.000.000",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kRedColor,
                  fontSize: SizeConfig.textMultiplier * 2.2)),
          Text('  ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kRedColor,
                  fontSize: SizeConfig.textMultiplier * 2.2)),
          SizedBox(
            height: SizeConfig.heightMultiplier * 1,
          ),
          Center(child: BarChartBoard()),
        ],
      ),
    );
  }
}
