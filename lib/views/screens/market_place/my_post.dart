import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/mock/mock.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/screens/market_place/market_place_data/list_post_data.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/button/button_next_createAcc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widgets_easier/widgets_easier.dart';

class MyPostScaeens extends ConsumerStatefulWidget {
  const MyPostScaeens({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPostScaeensState();
}

class _MyPostScaeensState extends ConsumerState<MyPostScaeens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtMarketPlace.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        shape: DottedBorder(
                          dotSize: 4,
                          dotSpacing: 4,
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: headerProfileColor,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: SizeConfig.heightMultiplier * 3,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg',
                                  // imageUrl: userProvider.getUserModel!.data!.,
                                  width: SizeConfig.widthMultiplier * 15,
                                  height: SizeConfig.heightMultiplier * 7,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 900.ms, delay: 300.ms)
                                .shimmer(
                                    blendMode: BlendMode.srcOver, color: kGary)
                                .move(
                                    begin: Offset(-16, 0),
                                    curve: Curves.easeOutQuad)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Kouved',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: kBack,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: SizeConfig.heightMultiplier * 1,
                              backgroundColor: kBlueColor,
                              child: Icon(
                                Icons.check,
                                size: SizeConfig.imageSizeMultiplier * 4,
                                color: kTextWhiteColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("UX-UI Designer",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: kGreyColor2)),
                      ],
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 900.ms, delay: 300.ms)
                    .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                    .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                Icon(Icons.add)
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
                childAspectRatio: 2,
              ),
              itemCount: dataList.length ?? 0,
              itemBuilder: (context, index) {
                final data = dataList[index];
                var dataColor =
                    getItemColorAndIcon(dataList[index]['name'].toString());
                Color color = dataColor['color'];
                String icons = dataColor['icon'];
                if (data == null) {
                  return Shimmer.fromColors(
                    baseColor: kGreyColor1,
                    highlightColor: kGary,
                    child: Container(
                      width: SizeConfig.widthMultiplier * 20,
                      height: SizeConfig.heightMultiplier * 1,
                      decoration: BoxDecoration(
                        color: kTextWhiteColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: kTextWhiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: Image.asset(
                        icons,
                        width: SizeConfig.widthMultiplier * 6,
                        height: SizeConfig.heightMultiplier * 4,
                      ),
                      title: Text(
                        data['number'],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                            ),
                      ),
                      subtitle: Text(
                        data['name'],
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: SizeConfig.textMultiplier * 1.7,
                            fontWeight: FontWeight.bold,
                            color: kBack),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 900.ms, delay: 300.ms)
                    .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                    .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad);
              },
            ),
            Expanded(
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kTextWhiteColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: kGary)),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: SizeConfig.heightMultiplier *
                                              3.5, // Adjusted radius for responsive
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  post.userImage.toString(),
                                              width: SizeConfig
                                                      .widthMultiplier *
                                                  15, // Adjusted width for responsive
                                              height: SizeConfig
                                                      .heightMultiplier *
                                                  7, // Adjusted height for responsive
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  CupertinoActivityIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ).animate().scaleXY(
                                            begin: 0,
                                            end: 1,
                                            delay: 300.ms,
                                            duration: 500.ms,
                                            curve: Curves.easeInOutCubic),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(post.userName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            color: kBack87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                CircleAvatar(
                                                  radius: SizeConfig
                                                          .heightMultiplier *
                                                      1,
                                                  backgroundColor: kBlueColor,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: SizeConfig
                                                            .imageSizeMultiplier *
                                                        4,
                                                    color: kTextWhiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  ImagePath.iconAgo,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  post.postTime,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: kGreyColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ).animate().fade(duration: 300.ms).moveX(
                                      begin: -50,
                                      end: 0,
                                      duration: 500.ms,
                                      curve: Curves.easeOutCubic),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(post.postText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall)
                                  .animate()
                                  .fade(duration: 600.ms)
                                  .moveX(
                                      begin: -50,
                                      end: 0,
                                      duration: 2000.ms,
                                      curve: Curves.easeOutCubic),
                              const SizedBox(
                                height: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: post.userImage.toString(),
                                  width: double.infinity,
                                  height: SizeConfig.heightMultiplier * 27,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
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
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${post.likeCount} likes & ${post.commentCount} Comments",
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: kTextGrey),
                              )
                                  .animate()
                                  .fadeIn(duration: 900.ms, delay: 300.ms)
                                  .shimmer(
                                      blendMode: BlendMode.srcOver,
                                      color: kGary)
                                  .move(
                                      begin: Offset(-16, 0),
                                      curve: Curves.easeOutQuad),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          radius:
                                              SizeConfig.heightMultiplier * 2.2,
                                          backgroundColor: kGary,
                                          child:
                                              Image.asset(ImagePath.iconLike)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      CircleAvatar(
                                          radius:
                                              SizeConfig.heightMultiplier * 2.2,
                                          backgroundColor: kGary,
                                          child: Image.asset(
                                              ImagePath.iconComment)),
                                    ],
                                  ),
                                  buttonNext(
                                    width: 150,
                                    height: 40,
                                    onPressed: () {},
                                    text: "Order Now",
                                  ),
                                ],
                              )
                                  .animate()
                                  .fadeIn(duration: 900.ms, delay: 300.ms)
                                  .shimmer(
                                      blendMode: BlendMode.srcOver,
                                      color: kGary)
                                  .move(
                                      begin: Offset(-16, 0),
                                      curve: Curves.easeOutQuad),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                color: kGary,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: SizeConfig.heightMultiplier * 2.5,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: post.userImage.toString(),
                                        width: SizeConfig.widthMultiplier * 15,
                                        height: SizeConfig.heightMultiplier * 7,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    // Wrap the Row inside Expanded
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Ensure spacing is even
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.userName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: kBack87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                post.commentPreview,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                        color: kGreyColor),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          Strings.txtSeeAll,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: kGreyColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
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
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  final List<ModelPost> posts = [
    ModelPost(
      userName: "Kouved",
      userImage:
          "https://gratisography.com/wp-content/uploads/2025/01/gratisography-dog-vacation-800x525.jpg",
      postTime: "2 hours ago",
      postText:
          "Hey, guess what? 🎉🍪 I've just wrapped up my cookie rice. Really good smells of watermelon. Includes sweet and non-sweet. Order now!",
      postImage:
          "https://gratisography.com/wp-content/uploads/2025/01/gratisography-dog-vacation-800x525.jpg",
      price: "10.000",
      commentPreview: "Ao hai sis nae nong warn 10 thong der. 👏",
      likeCount: "20",
      commentCount: "40",
      option: false,
    ),
    ModelPost(
      userName: "Non",
      userImage:
          "https://gratisography.com/wp-content/uploads/2025/01/gratisography-dog-vacation-800x525.jpg",
      postTime: "2 hours ago",
      postText:
          "Hey, guess what? 🎉🍪 I've just wrapped up my cookie rice. Really good smells of watermelon. Includes sweet and non-sweet. Order now!",
      postImage:
          "https://gratisography.com/wp-content/uploads/2025/01/gratisography-dog-vacation-800x525.jpg",
      price: "10.000",
      commentPreview: "Ao hai sis nae nong warn 10 thong der. 👏",
      likeCount: "20",
      commentCount: "40",
      option: false,
    ),
    ModelPost(
      userName: "Seng",
      userImage:
          "https://gratisography.com/wp-content/uploads/2025/01/gratisography-dog-vacation-800x525.jpg",
      postTime: "2 hours ago",
      postText:
          "Hey, guess what? 🎉🍪 I've just wrapped up my cookie rice. Really good smells of watermelon. Includes sweet and non-sweet. Order now!",
      postImage:
          "https://gratisography.com/wp-content/uploads/2025/01/gratisography-dog-vacation-800x525.jpg",
      price: "10.000",
      commentPreview: "Ao hai sis nae nong warn 10 thong der. 👏",
      likeCount: "20",
      option: false,
      commentCount: "40",
    ),
  ];
  Map<String, dynamic> getItemColorAndIcon(String title) {
    switch (title) {
      case "posts":
        return {'color': const Color(0xFF23A26D), 'icon': ImagePath.iconPost};
      case "comments":
        return {
          'color': const Color(0xFFF45B69),
          'icon': ImagePath.iconComment
        };
      case "Annual Leave":
        return {'color': const Color(0xFF3085FE), 'icon': ImagePath.iconLike};
      case "likes":
        return {
          'color': const Color(0xFFF59E0B),
          'icon': ImagePath.iconMaternity
        };

      default:
        return {'color': Colors.red, 'icon': ImagePath.iconTotal};
    }
  }
}
