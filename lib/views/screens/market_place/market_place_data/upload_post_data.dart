// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:widgets_easier/widgets_easier.dart';

class PostInputDelegate extends StatelessWidget {
  const PostInputDelegate({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        ).animate().scaleXY(
                            begin: 0,
                            end: 1,
                            delay: 300.ms,
                            duration: 500.ms,
                            curve: Curves.easeInOutCubic),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(Strings.txtWhatIsOnYourProduct,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: kGreyColor2))
              ],
            ),
            Divider(
              color: kGary,
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: SizeConfig.heightMultiplier * 6,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: kGary,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImagePath.iconPost,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(Strings.txtPostVdo,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kBack87, fontWeight: FontWeight.bold)),
                  ],
                ),
                alignment: Alignment.center,
              )
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 300.ms)
                  .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                  .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
            )
          ],
        ),
      ),
    );
  }
}
