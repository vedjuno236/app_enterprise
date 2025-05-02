import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/mock/mock.dart';
import 'package:enterprise/components/poviders/event_provider/event_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AllEventScreens extends ConsumerStatefulWidget {
  const AllEventScreens({Key? key}) : super(key: key);

  @override
  ConsumerState<AllEventScreens> createState() => _AllEventScreensState();
}

class _AllEventScreensState extends ConsumerState<AllEventScreens> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = ref.watch(stateEventProvider);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: kBack),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtEvent.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                  children: event.map((category) {
                    final id = category['categoryid'].toString();
                    logger.d(id);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                            onTap: () {
                              eventProvider.selectedIndexAllEvnet =
                                  int.parse(id);
                              logger.d("Selected ID: $id");
                            },
                            child: Container(
                              width: SizeConfig.widthMultiplier * 25,
                              decoration: BoxDecoration(
                                color: eventProvider.selectedIndexEventAll ==
                                        int.parse(id)
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
                                      .titleLarge!
                                      .copyWith(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.7,
                                      ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 900.ms, delay: 300.ms)
                                .move(
                                    begin: Offset(-16, 0),
                                    curve: Curves.easeOutQuad)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: event.length,
              itemBuilder: (context, index) {
                final data = event[index];

                if (data == null) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFF3F3F3),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: data['image'].toString(),
                          width: 100,
                          height: 120,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, size: 50),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 900.ms, delay: 300.ms)
                          .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                          .move(
                              begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['time'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: kBlueColor),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 40,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: kGary,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFFF3F3F3),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  data['date'].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: kRedColor,
                                          fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data['title'].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(),
                            softWrap: true,
                            // overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(ImagePath.iconLocation),
                              const SizedBox(width: 5),
                              Text(
                                data['location'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: kTextGrey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(duration: 900.ms, delay: 300.ms).move(
                              begin: Offset(10, 0), curve: Curves.easeOutQuad)),
                    ],
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
