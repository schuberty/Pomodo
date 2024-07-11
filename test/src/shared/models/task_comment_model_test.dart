import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/shared/models/task_comment_model.dart';

import '../../../utils.dart';

void main() {
  group('TaskComment', () {
    test('fromMap expect TaskComment object', () {
      expect(
        TaskComment.fromMap(<String, dynamic>{
          'id': '2992679862',
          'task_id': '2995104339',
          'content': 'Need one bottle of milk',
          'posted_at': '2016-09-22T07:00:00.000Z',
        }),
        isA<TaskComment>()
            .having((e) => e.id, 'id', '2992679862')
            .having((e) => e.taskId, 'task_id', '2995104339')
            .having((e) => e.content, 'content', 'Need one bottle of milk')
            .having((e) => e.postedAt, 'posted_at', DateTime.parse('2016-09-22T07:00:00.000Z')),
      );
    }, tags: kUnitTestTag);
  });
}
