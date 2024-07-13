import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../pomodo_commons.dart';
import '../constants.dart';

class AssetWidget extends StatelessWidget {
  const AssetWidget(
    this.asset, {
    super.key,
    this.color,
    this.size,
    this.fit = BoxFit.contain,
  });

  final Size? size;
  final BoxFit fit;
  final Color? color;
  final AssetData asset;

  @override
  Widget build(BuildContext context) {
    var assetColor = color;
    var assetSize = size;

    final isAssetIcon = asset.dataType == AssetDataType.icon;

    if (isAssetIcon && color == null) {
      assetColor = AppColors.black;
    }

    if (isAssetIcon && size == null) {
      assetSize = const Size.square(24);
    }

    return SvgPicture.asset(
      asset.path,
      fit: fit,
      width: assetSize?.width,
      height: assetSize?.height,
      package: kCommonsPackageName,
      colorFilter: assetColor != null ? ColorFilter.mode(assetColor, BlendMode.srcIn) : null,
    );
  }
}
