import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/modules/task/data/task_comment_datasource.dart';
import 'package:pomodo/src/shared/models/task_comment_model.dart';
import 'package:pomodo/src/shared/models/task_model.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../mocks/mocks.dart';
import '../../../../utils.dart';

void main() {
  group('ProjectSectionDatasource', () {
    late HttpClientMock client;
    late TaskCommentDatasource datasource;

    const commentId = '2992679862';
    const commentContent = 'Need one bottle of milk';
    const commentPostedAt = '2019-12-11T22:36:50.000Z';

    final task = Task(
      id: '2995104339',
      projectId: '2203306141',
      sectionId: '7025',
      content: 'Buy Milk',
      createdAt: DateTime.parse('2019-12-11T22:36:50.000Z'),
      commentCount: 10,
      order: 1,
      description: '',
      trackingDuration: Duration.zero,
    );

    final commentMap = <String, dynamic>{
      'id': commentId,
      'task_id': task.id,
      'content': commentContent,
      'posted_at': commentPostedAt,
    };

    setUp(() {
      client = HttpClientMock();
      datasource = TodoistTaskCommentDatasource(client: client);
    });

    test('getTaskComments expect a list of TasksComments', () async {
      client.whenSuccess(() => Response(data: [commentMap]));

      final result = await datasource.getTaskComments(task: task);

      expect(result, isA<Success>());
      expect(result.success, isA<List<TaskComment>>());
      expect(result.success, hasLength(1));

      final firstComment = result.success?.first;

      expect(
        firstComment,
        isA<TaskComment>()
            .having((e) => e.id, 'id', commentId)
            .having((e) => e.taskId, 'task_id', task.id)
            .having((e) => e.content, 'content', commentContent)
            .having((e) => e.postedAt, 'posted_at', DateTime.parse(commentPostedAt)),
      );
    }, tags: kUnitTestTag);

    test('getTaskComments when wrong response data, expect a ParsingError', () async {
      final wrongMap = {...commentMap, 'posted_at': null};

      client.whenSuccess(() => Response(data: [wrongMap]));

      final result = await datasource.getTaskComments(task: task);

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('createComment expect a newly created TaskComment', () async {
      client.whenSuccess(() => Response(data: commentMap));

      final result = await datasource.createComment(
        commentContent: commentContent,
        task: task,
      );

      expect(result, isA<Success>());
      expect(result.success, isA<TaskComment>());

      final createdComment = result.success;

      expect(
        createdComment,
        isA<TaskComment>()
            .having((e) => e.id, 'id', commentId)
            .having((e) => e.taskId, 'task_id', task.id)
            .having((e) => e.content, 'content', commentContent)
            .having((e) => e.postedAt, 'posted_at', DateTime.parse(commentPostedAt)),
      );
    }, tags: kUnitTestTag);

    test('createComment when wrong response data, expect a ParsingError', () async {
      final wrongMap = {...commentMap, 'posted_at': null};

      client.whenSuccess(() => Response(data: wrongMap));

      final result = await datasource.createComment(
        commentContent: commentContent,
        task: task,
      );

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('deleteComment expect a TaskComment to be deleted', () async {
      final taskComment = TaskComment.fromMap(commentMap);

      client.whenSuccess(() => Response(data: {}, statusCode: 204));

      final result = await datasource.deleteComment(comment: taskComment);

      expect(result, isA<Success>());
    }, tags: kUnitTestTag);

    test('deleteComment when failed to delete, expect a CommentNotDeleted error', () async {
      final taskComment = TaskComment.fromMap(commentMap);

      client.whenSuccess(() => Response(data: {}, statusCode: 200));

      final result = await datasource.deleteComment(comment: taskComment);

      expect(result, isA<Failure>());
      expect(result.failure, isA<CommentNotDeleted>());
    }, tags: kUnitTestTag);
  });
}
