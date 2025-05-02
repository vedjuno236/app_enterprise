import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';
import 'package:enterprise/views/widgets/app_dialog/alerts_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? event;
  const EventDetailScreen({super.key, this.event});
  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isShowText = false;

  @override
  Widget build(BuildContext context) {
    final event = GoRouterState.of(context).extra as Map<String, dynamic>?;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: event?['image'] ?? '',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 900.ms, delay: 300.ms)
                    .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                    .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),

                // Back Button
                Positioned(
                  top: 40,
                  left: 16,
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: const Center(
                          child: Icon(Icons.arrow_back_ios_new_outlined,
                              color: Colors.white)),
                    ),
                  ),
                ).animate().scaleXY(
                    begin: 0,
                    end: 1,
                    delay: 1000.ms,
                    duration: 500.ms,
                    curve: Curves.easeInOutCubic),

                Positioned(
                  bottom: -25,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 56,
                      width: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        // boxShadow: const [
                        //   BoxShadow(color: Colors.black12, blurRadius: 5)
                        // ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                                event?['user']?['profileImage'] ?? ''),
                          ),
                          const SizedBox(width: 5),
                          Text("+20 Going",
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                ).animate().scaleXY(
                    begin: 0,
                    end: 1,
                    delay: 1000.ms,
                    duration: 1000.ms,
                    curve: Curves.easeInOutCubic),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event?['title'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge)
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Image.asset(ImagePath.iconCalendar),
                    title: Text(event?['createAt'] ?? ''),
                    subtitle: Text(event?['time'] ?? ''),
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  ListTile(
                    leading: Image.asset(ImagePath.iconLocation),
                    title: Text(event?['location'] ?? ''),
                    subtitle: const Text("Link location"),
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  SizedBox(height: 10),
                  const Text(
                    "About Event",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  SizedBox(height: 5),
                  Text(
                    event?['description'] ?? '',
                    style: const TextStyle(color: Colors.black87),
                    maxLines: _isShowText ? 2000 : 2,
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isShowText = !_isShowText;
                      });
                    },
                    child: Text(_isShowText ? "Read Less" : "Read More...",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: kBlueColor)),
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad)
                ],
              ),
            ),

            //   Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return _buildAndroidDialog();
            //           },
            //         );
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.amber,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //         padding: EdgeInsets.symmetric(vertical: 16),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text("I’m in!",
            //               style: Theme.of(context).textTheme.bodyLarge),
            //           const SizedBox(width: 8),
            //           const CircleAvatar(
            //               child:
            //                   Icon(Icons.arrow_forward, color: kTextWhiteColor)),
            //         ],
            //       ),
            //     ),
            //   )
            //       .animate()
            //       .fadeIn(duration: 800.ms, delay: 800.ms)
            //       .move(begin: Offset(0, 20), curve: Curves.easeInOutCubic)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildAndroidDialog();
                },
              );
            },
            child: Container(
              width: SizeConfig.widthMultiplier * 100,
              height: SizeConfig.heightMultiplier * 6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kYellowFirstColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I’m in!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                      child: Icon(Icons.arrow_forward, color: kTextWhiteColor)),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 900.ms, delay: 300.ms)
                .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad)),
      ),
    );
  }

  Widget _buildAndroidDialog() {
    return AlertSuccessDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.3,
        child: SvgPicture.network(
          'https://www.svgrepo.com/show/434191/party-popper.svg',
          width: SizeConfig.widthMultiplier * 6,
          height: SizeConfig.heightMultiplier * 6,
        ),
      ),
      content: _buildDialogContent(),
      onTapOK: () => context.pop(),
    );
  }

  Widget _buildDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Thanks for joining us!",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: SizeConfig.textMultiplier * 2.5),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1),
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: SizeConfig.textMultiplier * 1.9, color: txt),
            text: " See you soon! on ",
            children: [
              TextSpan(
                text: DateFormatUtil.formatA(
                    DateTime.parse(DateTime.now().toString())),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: SizeConfig.textMultiplier * 1.9, color: txt),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1),
        Text(
          DateFormatUtil.formatA(DateTime.parse(DateTime.now().toString())),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: SizeConfig.textMultiplier * 2,
                color: kBlueColor,
              ),
        ),
      ],
    );
  }
}
