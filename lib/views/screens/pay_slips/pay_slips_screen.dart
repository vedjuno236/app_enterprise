// ignore_for_file: prefer_const_constructors

import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/screens/pay_slips/widget/deductions/deductions_widget.dart';
import 'package:enterprise/views/screens/pay_slips/widget/gross_income/gross_income_widget.dart';
import 'package:enterprise/views/screens/pay_slips/widget/net_salary/net_salary_widget.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaySlipsScreen extends ConsumerStatefulWidget {
  const PaySlipsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaySlipsScreenState();
}

class _PaySlipsScreenState extends ConsumerState<PaySlipsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Strings.txtPayslips,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: AppbarWidget(),
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetSalaryWidget(),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Strings.txtGrossIncome,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: SizeConfig.textMultiplier * 2)),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/gross_income_screen');
                    },
                    child: Text(
                      Strings.txtSeeAll,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/gross_income_screen');
                  },
                  child: GrossIncomeWidget()),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.txtDeductions,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/deductions_screen');
                    },
                    child: Text(
                      Strings.txtSeeAll,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push('/deductions_screen');
                },
                child: DeductionsWidget(),
              )
            ],
          ),
        ));
  }
}
