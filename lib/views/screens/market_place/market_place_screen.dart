// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/views/screens/market_place/market_place_data/list_post_data.dart';
import 'package:enterprise/views/screens/market_place/market_place_data/upload_post_data.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/background/main_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class MarketPlaceScreen extends ConsumerStatefulWidget {
  const MarketPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends ConsumerState<MarketPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kTextWhiteColor,
        extendBodyBehindAppBar: true,
        appBar: widgetAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(flex: 0, child: PostInputDelegate()),
              Expanded(flex: 2, child: PostModel()),
            ],
          ),
        ));
  }

  AppBar widgetAppBar() {
    return AppBar(
      elevation: 0,
      flexibleSpace: const AppbarWidget(),
      title: AnimatedTextAppBarWidget(
        text: Strings.txtMarketPlace.tr,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize Column height
            children: [
              GestureDetector(
                onTap: () {
                  context.push(PageName.myPost);
                },
                child: CircleAvatar(
                    backgroundColor: kTextWhiteColor,
                    radius: 16,
                    child: Image.asset(ImagePath.iconMypost)),
              ),
              // Add some spacing
              Expanded(
                child: Text(
                  Strings.txtMyPost.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: SizeConfig.textMultiplier *
                          1.5), // Reduce font size if necessary
                ),
              ),
            ],
          )
              .animate()
              .slideY(duration: 900.ms, curve: Curves.easeOutCubic)
              .fadeIn(),
        ),
      ],
    );
  }
}
