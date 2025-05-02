import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/constants/colors.dart';
import '../../../../components/constants/strings.dart';
import '../../../../components/router/router.dart';

class InformationScreenOld extends ConsumerStatefulWidget {
  const InformationScreenOld({super.key});

  @override
  ConsumerState createState() => _InformationScreenState();
}

final mockDataInformation = [
  {
    "id": 1,
    "name": "Main structure organisation",
    "number": 106,
    "users": [
      {
        "name": "Phet",
        "profileImg": "https://tinypng.com/images/social/website.jpg",
        "permission": 'Senior'
      },
      {
        "name": "Pui",
        "permission": 'Senior',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
      {
        "name": "Lee",
        "permission": 'Senior',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
      {
        "name": "Non",
        "permission": 'Senior',
        "profileImg": "http://via.placeholder.com/350x150",
      },
    ]
  },
  {
    "id": 2,
    "name": "Human Resources (HR)",
    "number": 6,
    "users": [
      {
        "name": "B",
        "permission": 'Senior',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
      {
        "name": "A",
        "permission": 'Senior',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
      {
        "name": "A",
        "permission": 'Senior',
        "profileImg": "https://tinypng.com/images/social/website.jpg",
      },
    ]
  },
  {
    "id": 3,
    "name": "Information Teachnology (IT)",
    "number": 18,
    "users": [
      {
        "name": "A",
        "permission": 'CTO',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
      {
        "name": "B",
        "permission": 'Head IT',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
      {
        "name": "C",
        "permission": 'Vice Head IT',
        "profileImg": "https://tinypng.com/images/social/website.jpg",
      },
      {
        "name": "D",
        "permission": 'Network',
        "profileImg":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxXnC3fwMwkbIt3ejGRIw3NmbDyUtgS5g2jA&s",
      },
      {
        "name": "F",
        "permission": 'Head IT Support',
        "profileImg": "https://tinypng.com/images/social/website.jpg",
      },
      {
        "name": "E",
        "permission": 'Head Dev',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
      {
        "name": "F",
        "permission": 'Senior',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
      {
        "name": "G",
        "permission": 'Junior',
        "profileImg":
            "https://huggingface.co/datasets/huggingfacejs/tasks/resolve/main/image-segmentation/image-segmentation-input.jpeg",
      },
    ]
  }
];

class _InformationScreenState extends ConsumerState<InformationScreenOld> {
  Widget _buildInformationCard(Map<String, dynamic> information) {
    return InkWell(
      onTap: () {
        context.push(
          PageName.structureScreenRoute,
          extra: information,
        );
      },
      child: Container(
        width: SizeConfig.widthMultiplier * 100,
        height: SizeConfig.heightMultiplier * 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kTextWhiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 30,
                height: SizeConfig.heightMultiplier * 19,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFEDEFF7),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      information['name'] as String,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: SizeConfig.textMultiplier * 1.8),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int j = 0;
                            j <
                                ((information['users'] as List).length > 3
                                    ? 3
                                    : (information['users'] as List).length);
                            j++)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 0),
                            child: Align(
                              widthFactor: 0.5,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      (information['users'] as List)[j]
                                          ['profileImg'] as String),
                                ),
                              ),
                            ),
                          ),
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: kGary,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: kTextWhiteColor,
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: kGary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Align(
                          widthFactor: 0.5,
                          child: Text(
                            '${information['number']} people',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 15, color: kGreyColor2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: const Text(Strings.txtInformation),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockDataInformation.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _buildInformationCard(mockDataInformation[index]);
        },
      ),
    );
  }
}
