import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/constants/strings.dart';
import '../../../../components/logger/logger.dart';
import '../../../../components/styles/size_config.dart';

class StructureScreen extends ConsumerStatefulWidget {
  // final String name;
  // final String image;
  final Map<String, dynamic> information;

  const StructureScreen({
    super.key,
    required this.information,
  });

  @override
  ConsumerState createState() => _StructureScreenState();
}

class Logo {
  final String imageUrls;
  final String name;

  Logo({required this.imageUrls, required this.name});
}

List<Logo> logo = [
  Logo(
    imageUrls: 'https://ncc.com.la/assets/naga-market-logo-CPeRkOAy.png',
    name: 'New Concept Consulting (NCC) ',
  ),
  Logo(
    imageUrls: 'https://ncc.com.la/assets/ncc-CpajitjR.png',
    name: 'New Concept Sole (NCS Naga lottery)',
  ),
  Logo(
    imageUrls: 'https://ncc.com.la/assets/ncf-logo-BAWOU7FZ.png',
    name: 'New Concept Consulting (NCC) ',
  ),
  Logo(
    imageUrls: 'https://ncc.com.la/assets/ncr-logo-DHkbqSod.png',
    name: 'New Concept Sole (NCS Naga lottery)',
  ),
];

class _StructureScreenState extends ConsumerState<StructureScreen> {
  @override
  Widget build(BuildContext context) {
    final information = widget.information;

    logger.d(information);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: const AppbarWidget(),
          title: const Text(Strings.txtStructute),
          actions: [
            GestureDetector(
              onTap: () {
                buildShowModalBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: kTextBack,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(ImagePath.iconMain),
                    ),
                    Positioned(
                      right: 0,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                left: 50,
                top: 80,
                bottom: 10,
                child: Container(
                  width: 1,
                  color: kGreyColor.withOpacity(0.4),
                ),
              ),
              Column(
                children: [
                  if (information != null && information['users'] != null)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: information['users'].length,
                        itemBuilder: (context, index) {
                          final user = information['users'][index];

                          return Stack(
                            children: [
                              if (user['permission'] != 'CTO')
                                Positioned(
                                  left: 50,
                                  top: 35,
                                  child: Container(
                                    height: 1,
                                    width: 200,
                                    color: kGreyColor.withOpacity(0.4),
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: getLeftMargin(user['permission']),
                                  bottom: 20,
                                ),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              NetworkImage(user['profileImg']),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user['name'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.8),
                                            ),
                                            Text(
                                              user['permission'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.8),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  else
                    const Center(
                      child: Text('No users found',
                          style: TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            ],
          ),
        ));
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
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
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'New Concept Group',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close))
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
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
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            logo[index].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

double getLeftMargin(String permission) {
  switch (permission) {
    case 'CTO':
      return 0;
    case 'Head IT':
      return 80;
    case 'Vice Head IT':
      return 120;
    case 'Network':
      return 120;
    case 'Head Dev':
      return 120;
    case 'Head IT Support':
      return 120;
    case 'Senior':
      return 150;
    case 'Junior':
      return 190;
    default:
      return 90;
  }
}
