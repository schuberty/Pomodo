import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/shared/models/task_model.dart';
import 'package:pomodo/src/shared/utils/utils.dart';

import '../../../utils.dart';

void main() {
  group('Task', () {
    const taskDescription = 'description';
    const taskTrackingSeconds = 1;

    final taskMap = <String, dynamic>{
      'id': '2995104339',
      'project_id': '2203306141',
      'section_id': '7025',
      'created_at': '2019-12-11T22:36:50.000Z',
      'comment_count': 10,
      'content': 'Buy Milk',
      'description': parseTaskDescriptionWithTrackingMetadata(taskDescription, taskTrackingSeconds),
      'order': 1,
    };

    test('fromMap expect Task object', () {
      expect(
        Task.fromMap(taskMap),
        isA<Task>()
            .having((e) => e.id, 'id', '2995104339')
            .having((e) => e.projectId, 'project_id', '2203306141')
            .having((e) => e.sectionId, 'section_id', '7025')
            .having((e) => e.content, 'content', 'Buy Milk')
            .having((e) => e.description, 'description', taskDescription)
            .having((e) => e.commentCount, 'comment_count', 10)
            .having((e) => e.trackingDuration, 'trackingDuration', const Duration(seconds: taskTrackingSeconds))
            .having((e) => e.createdAt, 'created_at', DateTime.parse('2019-12-11T22:36:50.000000Z'))
            .having((e) => e.order, 'order', 1),
      );
    }, tags: kUnitTestTag);

    test('toMap expect map to be same as Project object', () {
      expect(
        Task.fromMap(taskMap).toMap(),
        isA<Map<String, dynamic>>()
            .having((e) => e.length, 'map length', taskMap.length)
            .having((e) => e, 'map', taskMap),
      );
    }, tags: kUnitTestTag);
  });
}
