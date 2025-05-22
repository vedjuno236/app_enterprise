import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/models/news_model/news_pagination_model.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/styles/size_config.dart';
import '../../../components/utils/date_format_utils.dart';
import '../../widgets/appbar/appbar_widget.dart';

class NewsDetailsScreen extends ConsumerWidget {
  final ItemsNews news;

  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkTheme = ref.watch(darkThemeProviderProvider);
    darkTheme.darkTheme
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtDetails.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).canvasColor,
                    blurRadius: 4.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Hero(
                        tag: news.image!,
                        child: CachedNetworkImage(
                          imageUrl: news.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          height: SizeConfig.heightMultiplier * 30,
                          width: double.infinity,
                        ),
                      ),
                    ).animate().scaleXY(
                        begin: 0,
                        end: 1,
                        delay: 900.ms,
                        duration: 900.ms,
                        curve: Curves.easeInOutCubic),
                    const SizedBox(height: 16.0),
                    Text(
                      news.title!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ).animate().fade(duration: 300.ms).moveX(
                        begin: -50,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KingKunyar',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(DateFormatUtil.formatA(
                                DateTime.parse(news.createdAt!))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 10,
                    ),
                    Text(
                      news.description!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    ).animate().fade(duration: 1000.ms).moveX(
                        begin: -50,
                        end: 0,
                        duration: 1000.ms,
                        curve: Curves.easeOutCubic)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: SizeConfig.heightMultiplier * 6,
              width: SizeConfig.widthMultiplier * 100,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kYellowFirstColor, width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const ShapeDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFE7BA), Color(0xFFFFD275)],
                            ),
                            shape: CircleBorder(),
                          ),
                          child: Image.asset(ImagePath.iconShare),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          Strings.txtSharNow.tr,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.8,
                                  ),
                        )
                      ],
                    ),
                    const Icon(Icons.arrow_forward)
                  ],
                ),
                onPressed: () {
                  final Uri uri = Uri.parse(news.link!);
                  launchUrl(uri);
                  print(uri);
                },
              ),
            ).animate().fade(duration: 400.ms).moveY(
                begin: 20, end: 0, duration: 500.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
