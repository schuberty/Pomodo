enum AssetDataType {
  icon('assets/icons');

  const AssetDataType(this.folder);

  final String folder;
}

class AssetData {
  const AssetData._(String filename, this.dataType) : _filename = filename;

  final String _filename;
  final AssetDataType dataType;

  String get path => '${dataType.folder}/$_filename';
}

abstract class Assets {
  static const addIcon = AssetData._('add_icon.svg', AssetDataType.icon);
  static const trashIcon = AssetData._('trash_icon.svg', AssetDataType.icon);
  static const clockIcon = AssetData._('clock_icon.svg', AssetDataType.icon);
  static const commentIcon = AssetData._('comment_icon.svg', AssetDataType.icon);
}
