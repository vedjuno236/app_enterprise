import 'package:enterprise/views/screens/profile_screen/peopleSmilar.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 1);

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final selectedIndexNotifier = ref.read(selectedIndexProvider.notifier);

    final mockData = [
      {
        "id": 1,
        "category": "Week",
        "Leave": [
          {
            "id": 1,
            "title": "Annual Leave ",
            'icon': Icons.sunny,
            'color': '#3a86ff',
            "date": "20-26 Sept",
            "status": "Waiting for approval ",
            "user": {
              "profileImg": "http://via.placeholder.com/350x150",
            },
            "totalData": "5 Days"
          },
          {
            "id": 2,
            "title": "Annual Leave ",
            'icon': Icons.sunny,
            'color': '#3a86ff',
            "date": "20-26 Sept",
            "status": "Waiting for approval ",
            "user": {
              "profileImg": "http://via.placeholder.com/350x150",
            },
            "totalData": "5 Days"
          },
        ]
      },
      {
        "id": 2,
        "category": "Month",
        "Leave": [
          {
            "id": 1,
            "title": "Lakit Leave ",
            'color': '#ffbe0b',
            'icon': Icons.favorite_sharp,
            "date": "20-26 Sept",
            "status": "Waiting for approval ",
            "user": {
              "profileImg": "http://via.placeholder.com/350x150",
            },
            "totalData": "5 Days"
          },
        ]
      },
      {
        "id": 3,
        "category": "Year",
        "Leave": [
          {
            "id": 1,
            "title": "Sick Leave ",
            'color': '#2ec4b6',
            'icon': Icons.fire_hydrant_alt,
            "date": "20-26 Sept",
            "status": "Approved at 19 Sept 2024",
            "user": {
              "profileImg": "http://via.placeholder.com/350x150",
            },
            "totalData": "5 Days"
          },
        ]
      },
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtRanking.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ProfileNetworkWidget()),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: kBack87,
                    radius: 16,
                    child: Icon(
                      AntDesign.gitlab_fill, 
                      color: kTextWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kTextWhiteColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: mockData.map((category) {
                      final id = category['id'].toString();
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            selectedIndexNotifier.state = int.parse(id);
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: selectedIndex == int.parse(id)
                                  ? kYellowColor
                                  : null,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                category['category'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontSize: SizeConfig.textMultiplier * 1.9,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('All Member',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: SizeConfig.textMultiplier * 2)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(68 people)',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 2),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kRedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
