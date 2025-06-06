import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart'; // Fixed typo
import 'package:enterprise/components/poviders/bottom_bar_provider/bottom_bar_provider.dart';
import 'package:enterprise/components/poviders/users_provider/users_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/screens/analytic/analytic_screen.dart';
import 'package:enterprise/views/screens/home/home_screen.dart';
import 'package:enterprise/views/screens/news/news_screen.dart';
import 'package:enterprise/views/screens/profile_screen/profile_screen.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class HomeScreenPage extends ConsumerWidget {
  const HomeScreenPage({super.key});

  static final List<Widget> listWidgets = [
    const HomeScreen(),
    const AnalyticScreen(),
    const NewsScreen(),
    const ProfileScreen(),
  ];

  static const List<String> _tabLabels = [
    Strings.txtHome,
    'Analytic',
    'News',
    'Profile',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(stateBottomBarProvider).selectedIndex;
    final notifier = ref.read(stateBottomBarProvider.notifier);
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text(Strings.txtDoubleTapToLeave.tr)),
        child: listWidgets[selectedIndex],
      ),
      bottomNavigationBar: ClipRRect(
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColorLight,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          showUnselectedLabels: true,
          showSelectedLabels: false,
          currentIndex: selectedIndex,
          unselectedLabelStyle:
              TextStyle(fontSize: SizeConfig.textMultiplier * 1.9),
          selectedLabelStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1,
            fontWeight: FontWeight.bold,
          ),

          // unselectedLabelStyle: TextStyle(),

          onTap: (index) {
            notifier.updateTabSelection(index, _tabLabels[index].tr);
          },
          items: [
            BottomNavigationBarItem(
              label: 'Home'.tr,
              icon: _buildIcon(context, ImagePath.iconHome),
              activeIcon: _buildActiveIcon(ImagePath.iconHome),
            ),
            BottomNavigationBarItem(
              label: 'Analytic'.tr,
              icon: _buildIcon(context, ImagePath.iconAnalytic),
              activeIcon: _buildActiveIcon(ImagePath.iconAnalytic),
            ),
            BottomNavigationBarItem(
              label: 'News'.tr,
              icon: _buildIcon(context, ImagePath.iconNews),
              activeIcon: _buildActiveIcon(ImagePath.iconNews),
            ),
            BottomNavigationBarItem(
              label: 'Profile'.tr,
              icon: _buildNetworkImage(
                ref.watch(stateUserProvider).getUserModel?.data?.profile ?? '',
              ),
              activeIcon: _buildActiveNetworkImage(
                ref.watch(stateUserProvider).getUserModel?.data?.profile ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, String imagePath) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Image.asset(
        imagePath,
        height: SizeConfig.imageSizeMultiplier * 7,
        width: SizeConfig.imageSizeMultiplier * 7,
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }

  Widget _buildActiveIcon(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        radius: SizeConfig.imageSizeMultiplier * 4.5,
        backgroundColor: Colors.white,
        child: Image.asset(
          imagePath,
          height: SizeConfig.imageSizeMultiplier * 6,
          width: SizeConfig.imageSizeMultiplier * 6,
          color: kBack87,
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipOval(
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: SizeConfig.imageSizeMultiplier * 7,
                  width: SizeConfig.imageSizeMultiplier * 7,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const LoadingPlatformV1(),
                )
              : const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                    child: Icon(Bootstrap.person_circle),
                )),
    );
  }

  Widget _buildActiveNetworkImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        radius: SizeConfig.imageSizeMultiplier * 4.5,
        backgroundColor: Colors.white,
        child: ClipOval(
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: SizeConfig.imageSizeMultiplier * 6,
                    width: SizeConfig.imageSizeMultiplier * 6,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const LoadingPlatformV1(),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Bootstrap.person_circle),
                  ),
                  ),
      ),
    );
  }
}
