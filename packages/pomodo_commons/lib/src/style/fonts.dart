import 'package:flutter/widgets.dart';

import '../../pomodo_commons.dart';
import '../constants.dart';

abstract class AppFontStyles {
  static const fontFamily = 'Montserrat';

  static TextStyle headline({Color? color = AppColors.black}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        package: kCommonsPackageName,
      );

  static TextStyle title({Color? color = AppColors.black}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        package: kCommonsPackageName,
      );

  static TextStyle body({Color? color = AppColors.black}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        package: kCommonsPackageName,
      );

  static TextStyle caption({Color? color = AppColors.grey}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        package: kCommonsPackageName,
      );

  static TextStyle button({Color? color = AppColors.white}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
        package: kCommonsPackageName,
      );
}
