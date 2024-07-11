import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../pomodo_commons.dart';

const _kCommonsPackageName = 'pomodo_commons';

class IconAsset extends StatelessWidget {
  IconAsset({
    super.key,
    required this.asset,
    this.color = AppColors.black,
    this.size = const Size.square(24),
  }) : assert(asset.dataType == AssetDataType.icon, 'Asset type must be icon to be used in IconAsset widget.');

  final Size size;
  final Color color;
  final AssetData asset;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset.path,
      width: size.width,
      height: size.height,
      package: _kCommonsPackageName,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
