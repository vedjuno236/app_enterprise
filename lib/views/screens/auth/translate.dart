import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:popover/popover.dart';

import '../../../components/languages/localization_service.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  String? _selectedLanguageCode;

  @override
  // void initState() {
  //   _loadSavedLanguage();
  //   super.initState();
  // }
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
    showPopover(
      context: context,
      bodyBuilder: (context) => _buildLanguageList(),
      direction: PopoverDirection.bottom,
      width: 200,
      arrowHeight: 15,
      arrowWidth: 30,
    );
  }

  Widget _buildLanguageList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(LocalizationService.langCodes.length * 2 - 1,
            (index) {
          if (index % 2 == 0) {
            final langCode = LocalizationService.langCodes[index ~/ 2];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: _getFlagIcon(langCode),
              title: Text(
                LocalizationService.langs[langCode]!,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                setState(() {
                  _selectedLanguageCode = langCode;
                });
                LocalizationService.changeLocale(langCode);
                Navigator.pop(context);
              },
            );
          } else {
            return const Divider(
              color: kGary,
            );
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLanguagePopover(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getFlagIcon(_selectedLanguageCode ?? 'en'),
          const SizedBox(width: 8),
          Text(
            _selectedLanguageCode == 'lo' ? 'language' : 'ພາສາ',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          ),
          const SizedBox(width: 8),
          // const Icon(Ionicons.language_outline),
          const Icon(
            IonIcons.language,
      
          ),
        ],
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
