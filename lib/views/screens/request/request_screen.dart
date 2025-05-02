import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/mock/mock.dart';
import 'package:enterprise/components/poviders/report_HR_provider/report_HR_provider.dart';
import 'package:enterprise/components/poviders/repuest_provider/repuest_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/views/widgets/text_input/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 1);

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  Future fetchDepartmentAPI() async {
    EnterpriseAPIService().callDepartment().then((value) {
      ref.watch(stateReportHRProvider).setDepartmentModel(value: value);
      logger.d(value);
    });
  }

  @override
  @override
  void initState() {
    super.initState();
    fetchDepartmentAPI();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: mockReques.map((item) {
                  final id = item["id"].toString();
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedIndexProvider.notifier).state =
                          int.parse(id);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: ref.watch(selectedIndexProvider) == int.parse(id)
                            ? kYellowFirstColor
                            : kTextWhiteColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color:
                              ref.watch(selectedIndexProvider) == int.parse(id)
                                  ? kYellowFirstColor
                                  : const Color(0xFFE4E4E7),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        item["category"].toString(),
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(),
                      ), // Display the category name
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: mockReques.length,
                itemBuilder: (context, index) {
                  final data = mockReques[index];
                  final status = data['statusBooking'];

                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: kTextWhiteColor,
                          border: Border.all(
                            color: status == true ? kYellowColor : kGary,
                          )),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: status == true ? kYellowColor : kGary,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  children: [
                                    // const Icon(
                                    //   Ionicons.time_outline,
                                    //   color: kGreyColor2,
                                    // ),
                                    const Icon(
                                      IonIcons.time,
                                      color: kGreyColor2,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      data['time'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(),
                                    ),
                                  ],
                                ), // Display the category name
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: kBColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),

                                child: Text(
                                  data['status'].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.7,
                                          color: kTextWhiteColor),
                                ), // Display the category name
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                height: SizeConfig.heightMultiplier * 6,
                                width: SizeConfig.widthMultiplier * 15,
                                decoration: BoxDecoration(
                                    color: Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset("assets/images/car.png"),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['title'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    data['description'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          const Divider(
                            color: kGary,
                            thickness: 1,
                            height: 10,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: SizeConfig.widthMultiplier * 3.5,
                                    backgroundColor: kTextBack,
                                    child: const ClipOval(
                                        child:
                                            Icon(Icons.location_on_outlined)),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['location'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.5,
                                            ),
                                      ),
                                      Text(
                                        data['locationName'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                thickness: 5,
                                width: 10,
                              ),
                              data['isstatus'] == true
                                  ? Text(
                                      DateFormat('hh:mm:ss')
                                          .format(DateTime.now()),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: kYellowFirstColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),

                                      child: Text(
                                        'Book Now ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.7,
                                                color: kTextWhiteColor),
                                      ), // Display the category name
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
                }),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: const AppbarWidget(),
      title: Text(Strings.txtRequest,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith()),
      actions: [
        GestureDetector(
          onTap: () {
            buildShowModalBottomSheet(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: kBack,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: kTextWhiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: const Color(0xFFF8F9FC),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Consumer(builder: (context, ref, child) {
          final departmentProvider = ref.watch(stateReportHRProvider);
          final departmentData = departmentProvider.getDepartmentModel;
          final selectedIndex = ref.watch(stateRepuestprovider).selectedIndex;

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
                            Strings.txtAddRequest,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(stateRepuestprovider)
                                .updateSelectedIndex(null);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: selectedIndex == null
                                  ? getCheckStatus("All")['color']
                                      .withOpacity(0.10)
                                  : const Color(0xFF1A7529).withOpacity(0.10),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: selectedIndex == null
                                    ? getCheckStatus("All")['color']
                                    : const Color(0xFFE4E4E7),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: getCheckStatus("All")['color'],
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "All",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ...departmentData!.data!.map((item) {
                          final id = item.id.toString();
                          var dataStatus =
                              getCheckStatus(item.keyWord.toString());

                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(stateRepuestprovider)
                                  .updateSelectedIndex(int.parse(id));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: dataStatus['color'].withOpacity(0.10),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: selectedIndex == int.parse(id)
                                      ? kYellowFirstColor
                                      : const Color(0xFFE4E4E7),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: dataStatus['color'],
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    item.departmentName.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
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
                        'Send Request ',
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
}
