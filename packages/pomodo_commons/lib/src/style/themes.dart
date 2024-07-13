import 'package:flutter/material.dart';

import '../../pomodo_commons.dart';
import '../constants.dart';

abstract class AppThemes {
  static final lightThemeData = ThemeData(
    // General
    brightness: Brightness.light,
    fontFamily: AppFontStyles.fontFamily,
    package: kCommonsPackageName,

    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.blue,
    ),

    // Main widgets
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      elevation: 1.0,
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      shadowColor: AppColors.grey,
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.transparent,
      titleTextStyle: AppFontStyles.button(color: AppColors.black),
    ),
    // Widgets theme
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.grey,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.white,
      textTheme: ButtonTextTheme.primary,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
    ),
  );

  static final darkThemeData = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppFontStyles.fontFamily,
    package: kCommonsPackageName,
  );
}
