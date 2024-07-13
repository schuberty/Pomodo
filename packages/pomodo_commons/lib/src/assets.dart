enum AssetDataType {
  icon('assets/icons'),
  image('assets/images');

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
  static const filterIcon = AssetData._('filter_icon.svg', AssetDataType.icon);
  static const searchIcon = AssetData._('search_icon.svg', AssetDataType.icon);
  static const pauseIcon = AssetData._('pause_icon.svg', AssetDataType.icon);
  static const playIcon = AssetData._('play_icon.svg', AssetDataType.icon);
  static const doneIcon = AssetData._('done_icon.svg', AssetDataType.icon);
  static const editIcon = AssetData._('edit_icon.svg', AssetDataType.icon);
  static const addIcon = AssetData._('add_icon.svg', AssetDataType.icon);
  static const trashIcon = AssetData._('trash_icon.svg', AssetDataType.icon);
  static const clockIcon = AssetData._('clock_icon.svg', AssetDataType.icon);
  static const commentIcon = AssetData._('comment_icon.svg', AssetDataType.icon);
  static const chevronLeftIcon = AssetData._('chevron_left_icon.svg', AssetDataType.icon);
  static const chevronRightIcon = AssetData._('chevron_right_icon.svg', AssetDataType.icon);
  static const chevronDoubleRightIcon = AssetData._('chevron_double_right_icon.svg', AssetDataType.icon);
  static const chevronDoubleLeftIcon = AssetData._('chevron_double_left_icon.svg', AssetDataType.icon);
  static const dotsVerticalIcon = AssetData._('dots_vertical_icon.svg', AssetDataType.icon);

  static const checklistEmptyImage = AssetData._('checklist_empty_image.svg', AssetDataType.image);
}
