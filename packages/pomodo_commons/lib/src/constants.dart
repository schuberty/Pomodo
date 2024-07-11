abstract class Constants {
  static const todoistBaseUrl = 'https://api.todoist.com/rest/v2';
  static const todoistTestToken = String.fromEnvironment('TODOIST_API_TEST_TOKEN');

  static const taskTrackingMetadataTag = 'pomodo_app:time_s';
  static const taskTrackingMetadataRegexp = '<$taskTrackingMetadataTag:(\\d+)>';
}
