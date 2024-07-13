const kCommonsPackageName = 'pomodo_commons';

abstract class Constants {
  static const pomodoTodoistProjectName = 'Pomodo';

  static const todoistBaseRestUrl = 'https://api.todoist.com/rest/v2';
  static const todoistBaseSyncUrl = 'https://api.todoist.com/sync/v9';
  static const todoistTestToken = String.fromEnvironment('TODOIST_API_TEST_TOKEN');

  static const taskTrackingMetadataTag = 'pomodo_app:time_s';
  static const taskTrackingMetadataRegexp = '<$taskTrackingMetadataTag:(\\d+)>';
}
