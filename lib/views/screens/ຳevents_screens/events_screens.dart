import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/mock/mock.dart';
import 'package:enterprise/components/poviders/event_provider/event_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EventsScreens extends ConsumerStatefulWidget {
  const EventsScreens({super.key});

  @override
  ConsumerState<EventsScreens> createState() => _EventsScreensState();
}

class _EventsScreensState extends ConsumerState<EventsScreens> {
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
            padding: const EdgeInsets.all(15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: mockDataEvent.map((item) {
                      final id = item['id'].toString();
                      var dataColor = getItemColorAndIcon(item['category']
                          .toString()); // Use item['category'] here
                      String icons = dataColor['icon'];

                      return InkWell(
                          onTap: () {
                            eventProvider.selectedIndex = int.parse(id);
                            logger.d("Selected ID: $id");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, right: 15),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: eventProvider.selectedIndexEvent ==
                                        int.parse(id)
                                    ? kYellowColor
                                    : kGreyBGColor,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.asset(icons),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  item['category'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 900.ms, delay: 300.ms)
                              .shimmer(
                                  blendMode: BlendMode.srcOver, color: kGary)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad));
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upcomming Events',
                      style: Theme.of(context).textTheme.titleMedium),
                  GestureDetector(
                    onTap: () {
                      context.push(PageName.eventsAllScreens);
                    },
                    child: Row(
                      children: [
                        Text(Strings.txtSeeAll,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith()),
                        const Icon(Icons.arrow_right)
                      ],
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 300.ms)
                  .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                  .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: mockDataEvent.length,
                  itemBuilder: (context, index) {
                    final eventCategory = mockDataEvent[index];
                    final eventList = eventCategory['event'] as List?;
                    if (eventList == null || eventList.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final event = eventList[0] as Map<String, dynamic>?;
                    if (event == null) {
                      return const SizedBox.shrink();
                    }
                    // logger.d(event);
                    return GestureDetector(
                      onTap: () {
                        context.push(PageName.eventDetailScreen, extra: event);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
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
                            // Remove Expanded here
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: event['image'] ?? '',
                                    width: double.infinity,
                                    height: 200, //add height here
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 900.ms, delay: 300.ms)
                                    .shimmer(
                                        blendMode: BlendMode.srcOver,
                                        color: kGary)
                                    .move(
                                        begin: Offset(-16, 0),
                                        curve: Curves.easeOutQuad),
                                Positioned(
                                  // bottom: SizeConfig.widthMultiplier * 58,
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
                                          '${event['title'] ?? ''} ', // Add null check
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.8,
                                                  color: kTextWhiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 900.ms, delay: 300.ms)
                                    .shimmer(
                                        blendMode: BlendMode.srcOver,
                                        color: kGary)
                                    .move(
                                        begin: Offset(-16, 0),
                                        curve: Curves.easeOutQuad)
                              ],
                            ),
                            //Remove Expanded here
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['title'] ?? '', // Add null check
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.8),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEEEFF6),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Image.asset(
                                          ImagePath.iconCalendar,
                                          width:
                                              SizeConfig.widthMultiplier * 10,
                                          height:
                                              SizeConfig.heightMultiplier * 7,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['createAt'] ??
                                                '', // Add null check
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.8),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            event['time'] ??
                                                '', // Add null check
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.6),
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
                                  Row(
                                    children: [
                                      Container(
                                        child: Align(
                                          widthFactor: 0.5,
                                          child: CircleAvatar(
                                            radius:
                                                SizeConfig.heightMultiplier * 3,
                                            backgroundColor:
                                                Theme.of(context).canvasColor,
                                            child: CircleAvatar(
                                              radius:
                                                  SizeConfig.heightMultiplier *
                                                      2,
                                              backgroundImage: event['user'] !=
                                                          null &&
                                                      event['user']
                                                              ['profileImg'] !=
                                                          null
                                                  ? NetworkImage(event['user']
                                                      ['profileImg'])
                                                  : null, // Add null check

                                              //Add this line
                                              onBackgroundImageError:
                                                  (exception, stackTrace) {
                                                // show error
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Align(
                                        child: Text(
                                          '+Going',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      2,
                                                  color: kYellowFirstColor),
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.push(
                                              PageName.eventDetailScreen,
                                              extra: event);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kYellowFirstColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        child: Text(
                                          '+Join',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(ImagePath.iconLocation),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(event['location'] ??
                                          '') // Add null check
                                    ],
                                  )
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 900.ms, delay: 300.ms)
                                .move(
                                    begin: Offset(-16, 0),
                                    curve: Curves.easeOutQuad)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ])));
  }

  Map<String, dynamic> getItemColorAndIcon(String title) {
    switch (title) {
      case "Sports":
        return {'icon': ImagePath.iconSport};
      case "Party":
        return {'icon': ImagePath.iconParty};
      case "Food":
        return {'icon': ImagePath.iconFood};

      default:
        return {'icon': ImagePath.iconTotal};
    }
  }
}
