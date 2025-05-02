// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/button/button_next_createAcc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModelPost {
  final String userName;
  final String userImage;
  final String postTime;
  final String postText;
  final String postImage;
  final String price;
  final String commentPreview;
  final String likeCount;
  final String commentCount;
  final bool option;

  ModelPost({
    required this.userName,
    required this.userImage,
    required this.postTime,
    required this.postText,
    required this.postImage,
    required this.price,
    required this.commentPreview,
    required this.likeCount,
    required this.commentCount,
    required this.option,
  });
}

class PostModel extends ConsumerWidget {
  final List<ModelPost> posts = [
    ModelPost(
      userName: "Kouved",
      userImage:
          "https://gratisography.com/wp-content/uploads/2025/01/gratisography-dog-vacation-800x525.jpg",
      postTime: "2 hours ago",
      postText:
          "Hey, guess what? 🎉🍪 I've just wrapped up my cookie rice. Really good smells of watermelon. Includes sweet and non-sweet. Order now!",
      postImage:
          "https://images.pexels.com/photos/1581484/pexels-photo-1581484.jpeg?cs=srgb&dl=pexels-nipananlifestyle-com-625927-1581484.jpg&fm=jpg",
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
          "https://eatwellconcept.com/wp-content/uploads/2020/03/fresh-fruit-smoothies-wooden-background_23-2148227524.jpg",
      commentPreview: "Ao hai sis nae nong warn 10 thong der. 👏",
      likeCount: "20",
      price: "10.000",
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
      postImage: "https://pangpond.com/wp-content/uploads/219376.webp",
      price: "10.000",
      commentPreview: "Ao hai sis nae nong warn 10 thong der. 👏",
      likeCount: "20",
      option: false,
      commentCount: "40",
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
          physics: ClampingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: SizeConfig.heightMultiplier *
                                      3.5, // Adjusted radius for responsive
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: post.userImage.toString(),
                                      width: SizeConfig.widthMultiplier *
                                          15, // Adjusted width for responsive
                                      height: SizeConfig.heightMultiplier *
                                          7, // Adjusted height for responsive
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              CupertinoActivityIndicator(),
                                      errorWidget: (context, url, error) =>
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                                        FontWeight.bold)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircleAvatar(
                                          radius:
                                              SizeConfig.heightMultiplier * 1,
                                          backgroundColor: kBlueColor,
                                          child: Icon(
                                            Icons.check,
                                            size:
                                                SizeConfig.imageSizeMultiplier *
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
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          post.postTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: kGreyColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(post.postText,
                              style: Theme.of(context).textTheme.titleSmall)
                          .animate()
                          .fade(duration: 300.ms)
                          .moveX(
                              begin: -50,
                              end: 0,
                              duration: 500.ms,
                              curve: Curves.easeOutCubic),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: post.postImage.toString(),
                          width: double.infinity,
                          height: SizeConfig.heightMultiplier * 27,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 900.ms, delay: 300.ms)
                          .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                          .move(
                              begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${post.likeCount} likes & ${post.commentCount} Comments",
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: kTextGrey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: SizeConfig.heightMultiplier * 2.2,
                                  backgroundColor: kGary,
                                  child: Image.asset(ImagePath.iconLike)),
                              SizedBox(
                                width: 20,
                              ),
                              CircleAvatar(
                                  radius: SizeConfig.heightMultiplier * 2.2,
                                  backgroundColor: kGary,
                                  child: Image.asset(ImagePath.iconComment)),
                            ],
                          ),
                          buttonNext(
                            width: 150,
                            height: 40,
                            onPressed: () {},
                            text: "Order Now",
                          )
                              .animate()
                              .fadeIn(duration: 900.ms, delay: 300.ms)
                              .shimmer(
                                  blendMode: BlendMode.srcOver, color: kGary)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
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
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
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
                                  curve: Curves.easeOutQuad),
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        post.commentPreview,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: kGreyColor),
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
                            )
                                .animate()
                                .slideY(
                                    duration: 900.ms,
                                    curve: Curves.easeOutCubic)
                                .fadeIn(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: PostModel(),
//   ));
// }
