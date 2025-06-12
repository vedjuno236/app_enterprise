import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/languages/localization_service.dart';
import 'package:enterprise/components/poviders/bottom_bar_provider/bottom_bar_provider.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/styles/size_config.dart';

import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  String? _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedLanguage();
    });
  }

  Future<void> _loadSavedLanguage() async {
    final saveLocale = await LocalizationService.getSaveLocal();
    setState(() {
      _selectedLanguageCode =
          saveLocale?.languageCode ?? Get.deviceLocale!.languageCode;
    });
  }

  void _showLanguagePopover(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'en',
          child: ListTile(
            leading: _getFlagIcon('en'),
            title: Text(
              'English',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 2),
            ),
            selected: _selectedLanguageCode == 'en',
          ),
        ),
        PopupMenuItem(
          value: 'lo',
          child: ListTile(
            leading: _getFlagIcon('lo'),
            title: Text(
              'ພາສາລາວ',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 2),
            ),
            selected: _selectedLanguageCode == 'lo',
          ),
        ),
      ],
    ).then((value) async {
      if (value != null) {
        setState(() {
          _selectedLanguageCode = value;
        });
        await LocalizationService.changeLocale(value);
      }
    });
  }

  void _showDisplayMenu(BuildContext context) {
    final darkTheme = ref.watch(darkThemeProviderProvider);

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: false, // Light mode
          child: ListTile(
            leading: const Icon(IonIcons.sunny),
            title: Text(
              Strings.txtLight.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 2),
            ),
            selected: !darkTheme.darkTheme,
          ),
        ),
        PopupMenuItem(
          value: true, // Dark mode
          child: ListTile(
            leading: const Icon(IonIcons.moon),
            title: Text(
              Strings.txtDark.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 2),
            ),
            selected: darkTheme.darkTheme,
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        ref.read(darkThemeProviderProvider).darkTheme = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = ref.watch(darkThemeProviderProvider);

    darkTheme.darkTheme
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtSystemSettings.tr,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.txtContenDisplay.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 2.2),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  border: Border.all(color: Theme.of(context).cardColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showLanguagePopover(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Bootstrap.translate),
                                    const SizedBox(width: 10),
                                    Text(
                                      Strings.txtLanguage.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.2),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _selectedLanguageCode == 'en'
                                          ? 'English'
                                          : 'ພາສາລາວ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.2),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Theme.of(context).cardColor),
                      const SizedBox(height: 10),
                      Builder(
                        builder: (context) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showDisplayMenu(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    darkTheme.darkTheme == false
                                        ? Icon(IonIcons.sunny)
                                        : Icon(IonIcons.moon),
                                    const SizedBox(width: 10),
                                    Text(
                                      Strings.txtDisplayScreen.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.2),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                Strings.txtLogin.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 2.2),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(stateBottomBarProvider.notifier).resetState();
                    if (sharedPrefs.getStringNow(KeyShared.keyToken) != null) {
                      sharedPrefs.remove(KeyShared.keyToken);
                      sharedPrefs.remove(KeyShared.keyUserId);
                      sharedPrefs.remove(KeyShared.keyRole);
                      context.go(PageName.login);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).canvasColor,
                    side: BorderSide(color: Theme.of(context).canvasColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/log_out.png',
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        Strings.txtLogout.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: SizeConfig.textMultiplier * 2.2),
                      ),
                    ],
                  ),
                ),
              ),
    
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFlagIcon(String languageCode) {
    switch (languageCode) {
      case 'en':
        return Image.asset(
          'assets/icons/en.png',
        );
      case 'lo':
        return Image.asset(
          'assets/icons/la.png',
        );
      default:
        return Image.asset(
          'assets/icons/en.png',
        );
    }
  }
}
