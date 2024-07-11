import 'package:flutter/widgets.dart';

import '../../pomodo_commons.dart';

abstract class AppFontStyles {
  static const fontFamily = 'Montserrat';

  static TextStyle headline({Color? color = AppColors.black}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle body({Color? color = AppColors.black}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle caption({Color? color = AppColors.grey}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle button({Color? color = AppColors.white}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
      );
}
