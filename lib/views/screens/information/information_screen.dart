import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/logger/logger.dart';
import '../../../components/mock/mock.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 1);

class InformationScreen extends ConsumerWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final selectedIndexNotifier = ref.read(selectedIndexProvider.notifier);
    final selectedGroup = mockDataInformationNew.firstWhere(
      (group) => group['id'] == selectedIndex,
      orElse: () => {},
    );
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: mockDataInformationNew.map((item) {
                    final id = item['id'].toString();

                    return InkWell(
                      onTap: () {
                        selectedIndexNotifier.state = int.parse(id);
                        logger.d("Selected ID: $id");
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, right: 15),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: selectedIndex == int.parse(id)
                              ? kYellowColor
                              : null,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: selectedIndex == int.parse(id)
                                ? kYellowColor
                                : kGreyBGColor,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          item['name'].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    if (selectedGroup != null) ...[
                      for (var user in selectedGroup['users'] as List<dynamic>)
                        if (user['permission'] == 'CEO')
                          Column(
                            children: [
                              // CEO Card
                              ProfileCard(
                                name: user['name'] as String,
                                role: user['per'] as String,
                                profileImg: user['profileImg'] as String,
                                isCEO: true,
                              ),
                              // Vertical Line
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.grey[300],
                              ),
                              // Horizontal Line
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 1,
                                color: Colors.grey[300],
                              ),
                              // Subordinates Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (var subordinate in selectedGroup['users']
                                      as List<dynamic>)
                                    if (subordinate['permission'] != 'CEO')
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 2,
                                              height: 25,
                                              color: Colors.grey[300],
                                            ),
                                            ProfileCard(
                                              name:
                                                  subordinate['name'] as String,
                                              role:
                                                  subordinate['per'] as String,
                                              profileImg:
                                                  subordinate['profileImg']
                                                      as String,
                                              number: subordinate
                                                      .containsKey('number')
                                                  ? subordinate['number'] as int
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ],
                          ),
                    ],
                  ],
                ),
              )
            ]),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: kBack),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: const AppbarWidget(),
      title: const Text(
        Strings.txtStructute,
      ),
      actions: [
        GestureDetector(
          onTap: () {
            buildShowModalBottomSheet(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                        backgroundColor: kTextWhiteColor,
                        radius: 16,
                        child: Image.asset(ImagePath.iconMain)),
                    Positioned(
                      right: 0,
                      top: -9,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: kRedColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '',
                          style: TextStyle(
                            color: kYellowFirstColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    Strings.txtCompanies,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: SizeConfig.textMultiplier *
                            1.5), // Reduce font size if necessary
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: const Color(0xFfF8F9FC),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'New Concept Group',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2),
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
                Expanded(
                  child: logo == null
                      ? Shimmer.fromColors(
                          baseColor: kGreyColor1,
                          highlightColor: kGreyColor2,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 100,
                                    height: 10,
                                    color: Colors.black26,
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: logo.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      logo[index].imageUrls,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons
                                            .error); // Error handling for image loading
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  logo[index].name,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.8),
                                ),
                              ],
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String profileImg;
  final int? number;
  final bool isCEO;

  const ProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.profileImg,
    this.number,
    this.isCEO = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: isCEO ? 240 : 200,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: kTextWhiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCEO ? kYellowFirstColor : kBlueColor,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(profileImg),
                ),
              ),
              const SizedBox(height: 12),
              // Name
              Text(
                name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 1.8),
              ),
              const SizedBox(height: 4),
              // Role
              Text(
                role,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: txt),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (!isCEO && number != null)
          Positioned(
            bottom: -9,
            left: 40,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: kGreyColor2,
                    )
                  ],
                  color: kTextWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+$number',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                ),
              ),
            ),
          )
      ],
    );
  }
}
