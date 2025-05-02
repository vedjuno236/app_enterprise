import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/screens/pay_slips/widget/list/list_widget.dart';
import 'package:flutter/material.dart';
class GrossIncomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> deductions = [
    {
      "icon": Icons.check,
      "title": "Basic",
      "description": "Basic salary",
      "value": "+2.000.000",
      "date": DateTime.now(),
      "percentPaidOff": "49%",
      "valueMicrofinance": "15,670,000",
      "valueNCCFund": "10,000,000",
    },
    {
      "icon": Icons.stacked_bar_chart_outlined,
      "title": "Position",
      "description": "Salary",
      "value": "+2.500.000",
      "date": DateTime.now(),
      "percentPaidOff": "60%",
      "valueMicrofinance": "12,000,000",
      "valueNCCFund": "5,000,000",
    },
    {
      "icon": Icons.lock_clock_outlined,
      "title": "OT",
      "description": "40 Hours",
      "value": "+500,000",
      "date": DateTime.now(),
      "percentPaidOff": "35%",
      "valueMicrofinance": "5,000,000",
      "valueNCCFund": "2,000,000",
    },
    {
      "icon": Icons.restaurant_menu_outlined,
      "title": "Incentives",
      "description": "Work out door food fee",
      "value": "+600,000",
      "date": DateTime.now(),
      "percentPaidOff": "35%",
      "valueMicrofinance": "5,000,000",
      "valueNCCFund": "2,000,000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gross Income',
            style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(Strings.txtAllIncome),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: deductions.length,
                itemBuilder: (context, index) {
                  final item = deductions[index];
                  return ListWidget(
                    icon: item["icon"],
                    title: item["title"],
                    description: item["description"],
                    value: item["value"],
                    date: item["date"],
                    percentPaidOff: item["percentPaidOff"],
                    valueMicrofinance: item["valueMicrofinance"],
                    valueNCCFund: item["valueNCCFund"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



