import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComingEventsWidget extends ConsumerStatefulWidget {
  const ComingEventsWidget({super.key});

  @override
  ConsumerState createState() => _ComingEventsWidgetState();
}

class _ComingEventsWidgetState extends ConsumerState<ComingEventsWidget> {
  @override
  Widget build(BuildContext context) {
    List<String> joinImage = [
      'https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg',
      'https://pbs.twimg.com/profile_images/1249432648684109824/J0k1DN1T_400x400.jpg',
      'https://i0.wp.com/thatrandomagency.com/wp-content/uploads/2021/06/headshot.png?resize=618%2C617&ssl=1',
      'https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg',
      'https://pbs.twimg.com/profile_images/1249432648684109824/J0k1DN1T_400x400.jpg',
      'https://i0.wp.com/thatrandomagency.com/wp-content/uploads/2021/06/headshot.png?resize=618%2C617&ssl=1',
    ];

    return Container(
      width: double.infinity,
      height: SizeConfig.heightMultiplier * 45,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor,
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: "https://ncc.com.la/assets/act3-CXqS4cgQ.png",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      // progressIndicatorBuilder:
                      //     (context, url, downloadProgress) => Center(
                      //         child: CircularProgressIndicator(
                      //             value: downloadProgress.progress)),
                      // errorWidget: (context, url, error) =>
                      //     const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    bottom: SizeConfig.widthMultiplier * 30,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: SizeConfig.heightMultiplier * 4.5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.50),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'New year Celebration/ All Department  ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.8,
                                    color: kTextWhiteColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New year Celebration 2025',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 1.8),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEEFF6),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          ImagePath.iconCalendar,
                          width: SizeConfig.widthMultiplier * 10,
                          height: SizeConfig.heightMultiplier * 7,
                        ), // Replace with your own icon
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '14 December, 2021',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.8),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tuesday, 4:00PM - 9:00PM',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.6),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color(0xFFF3F3F3),
                    thickness: 1.0,
                    height: 20.0,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0;
                                i <
                                    (joinImage.length > 3
                                        ? 3
                                        : joinImage.length);
                                i++)
                              Container(
                                child: Align(
                                  widthFactor: 0.5,
                                  child: CircleAvatar(
                                    radius: SizeConfig.heightMultiplier * 2.9,
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    child: CircleAvatar(
                                      radius: SizeConfig.heightMultiplier * 2.2,
                                      backgroundImage:
                                          NetworkImage(joinImage[i]),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 30),
                            if (joinImage.length > 3)
                              Align(
                                widthFactor: 0.6,
                                child: Text(
                                  '+${joinImage.length} Going',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2,
                                          color: kYellowFirstColor),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kYellowFirstColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            '+Join',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
