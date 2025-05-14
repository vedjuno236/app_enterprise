import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/languages/localization_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    if (isDarkTheme) {
      ///dark theme
      return ThemeData(
        // fontFamily: LocalizationService.locale!.languageCode == "lo"
        // ? GoogleFonts.notoSansLao().fontFamily
        // : GoogleFonts.rubik().fontFamily,
        fontFamily: GoogleFonts.notoSansLao().fontFamily,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Color(0xff262626),
          secondary: Color(0xffF56C15),
        ),
        cardTheme: const CardTheme(
          color: Color(0xff262626),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color(0xff818181),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xff2D2D2E),
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,
        primarySwatch: Colors.green,
        secondaryHeaderColor: Colors.black,
        primaryColor: const Color(0xff282727),
        indicatorColor: const Color(0xff0E1D36),
        hintColor: Colors.grey.shade700,
        highlightColor: Colors.transparent,
        hoverColor: const Color(0xff3A3A3B),
        focusColor: const Color(0xff0B2512),
        disabledColor: Colors.grey,
        cardColor: const Color(0xFF211B10),
        canvasColor: const Color(0xff242424),
        brightness: Brightness.dark,
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.black),
        buttonTheme: Theme.of(context)
            .buttonTheme
            .copyWith(colorScheme: const ColorScheme.dark()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.8,
          ),
          color: const Color(0xff262626),
        ),
      );
    } else {
      ///light theme
      return ThemeData(
        // fontFamily: LocalizationService.locale!.languageCode == "lo"
        //     ? GoogleFonts.notoSansLao().fontFamily
        //     : GoogleFonts.rubik().fontFamily,
        fontFamily: GoogleFonts.notoSansLao().fontFamily,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: kYellowColor,
          secondary: Color(0xffF56C15),
        ),
        cardTheme: const CardTheme(
          color: Color(0xffF3F5F7),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color(0xff9B9B9B),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xffF0F2F6),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kYellowColor,
        ),
        primaryColorDark: Colors.white,
        primaryColorLight: Colors.black,
        primarySwatch: Colors.green,
        secondaryHeaderColor: Colors.white,
        primaryColor: Colors.white,
        indicatorColor: const Color(0xffCBDCF8),
        hintColor: Colors.grey.shade400,
        highlightColor: kGary,
        hoverColor: kGreyColor1,
        focusColor: const Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        cardColor: Color(0xFFF5F6FA),
        canvasColor: kTextWhiteColor,
        brightness: Brightness.light,
        buttonTheme: Theme.of(context)
            .buttonTheme
            .copyWith(colorScheme: const ColorScheme.light()),
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ),
      );
    }
  }
}
