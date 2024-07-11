import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/shared/utils/utils.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

void main() {
  group('Task utils', () {
    const taskDescription = 'description';
    const taskTrackingSeconds = 1;

    final trackingMetadataRegex = RegExp(Constants.taskTrackingMetadataRegexp);

    test('parseTrackingMetadataTag expect parsed Task tracking time tag', () {
      final parsedTag = parseTrackingMetadataTag(taskTrackingSeconds);

      final match = trackingMetadataRegex.firstMatch(parsedTag);

      expect(match, isNotNull);
      expect(match?.group(1), taskTrackingSeconds.toString());
    });

    test('parseTaskDescriptionWithTrackingMetadata expect parsed description with tag', () {
      final parsedTaskDescriptipn = parseTaskDescriptionWithTrackingMetadata(taskDescription, taskTrackingSeconds);

      final tag = parseTrackingMetadataTag(taskTrackingSeconds);

      expect(parsedTaskDescriptipn, '$taskDescription$tag');
    });

    test('parseTaskMetadataFromTaskDescription expect parsed description and tracking time ', () {
      final descriptionWithMetadata = parseTaskDescriptionWithTrackingMetadata(taskDescription, taskTrackingSeconds);

      final parsedTaskMetadata = parseTaskMetadataFromTaskDescription(descriptionWithMetadata);

      expect(parsedTaskMetadata.trackingDuration, const Duration(seconds: taskTrackingSeconds));
      expect(parsedTaskMetadata.parsedDescription, taskDescription);
    });

    test('parseTaskMetadataFromTaskDescription expect parsed description and tracking time zeroed', () {
      final parsedTaskMetadata = parseTaskMetadataFromTaskDescription(taskDescription);

      expect(parsedTaskMetadata.trackingDuration, const Duration());
      expect(parsedTaskMetadata.parsedDescription, taskDescription);
    });
  });
}
