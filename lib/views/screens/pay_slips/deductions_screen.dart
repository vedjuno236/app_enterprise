import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/screens/pay_slips/widget/list/list_widget.dart';
import 'package:flutter/material.dart';

class DeductionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> deductions = [
    {
      "icon": Icons.policy_outlined,
      "title": "Policy",
      "description": "Wearing",
      "value": "-200,000",
      "date": DateTime.now(),
      "percentPaidOff": "49%",
      "valueMicrofinance": "15,670,000",
      "valueNCCFund": "10,000,000",
    },
    {
      "icon": Icons.location_city_outlined,
      "title": "Loan",
      "description": "Reduction loan fee + interest",
      "value": "-1,500,000",
      "date": DateTime.now(),
      "percentPaidOff": "60%",
      "valueMicrofinance": "12,000,000",
      "valueNCCFund": "5,000,000",
    },
    {
      "icon": Icons.calendar_today_outlined,
      "title": "Last",
      "description": "You were late more than 3 times",
      "value": "-500,000",
      "date": DateTime.now(),
      "percentPaidOff": "35%",
      "valueMicrofinance": "5,000,000",
      "valueNCCFund": "2,000,000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reductions'),flexibleSpace: AppbarWidget(),backgroundColor: Colors.transparent,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(Strings.txtAllDeduction),
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
