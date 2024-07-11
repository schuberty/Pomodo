import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/modules/task/data/objects/updated_task.dart';
import 'package:pomodo/src/modules/task/data/task_datasource.dart';
import 'package:pomodo/src/shared/models/task_model.dart';
import 'package:pomodo/src/shared/utils/utils.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../mocks/mocks.dart';
import '../../../../utils.dart';

void main() {
  group('ProjectSectionDatasource', () {
    late HttpClientMock client;
    late TaskDatasource datasource;

    const taskContent = 'Buy Milk';
    const taskProjectId = '2203306141';
    const taskSectionId = '7025';

    final taskMap = <String, dynamic>{
      'id': '2995104339',
      'project_id': taskProjectId,
      'section_id': taskSectionId,
      'created_at': '2019-12-11T22:36:50.000Z',
      'comment_count': 10,
      'content': taskContent,
      'description': '',
      'order': 1,
    };

    setUp(() {
      client = HttpClientMock();
      datasource = TodoistTaskDatasource(client: client);
    });

    test('getAllActiveTasks expect a list of Tasks', () async {
      client.whenSuccess(() => Response(data: [taskMap]));

      final result = await datasource.getAllActiveTasks();

      expect(result, isA<Success>());
      expect(result.success, isA<List<Task>>());
      expect(result.success, hasLength(1));

      final firstTask = result.success?.first;

      expect(
        firstTask,
        isA<Task>()
            .having((e) => e.id, 'id', '2995104339')
            .having((e) => e.projectId, 'project_id', taskProjectId)
            .having((e) => e.sectionId, 'section_id', taskSectionId)
            .having((e) => e.content, 'content', taskContent)
            .having((e) => e.createdAt, 'created_at', DateTime.parse('2019-12-11T22:36:50.000000Z'))
            .having((e) => e.commentCount, 'comment_count', 10)
            .having((e) => e.order, 'order', 1)
            .having((e) => e.description, 'description', ''),
      );
    }, tags: kUnitTestTag);

    test('getAllActiveTasks when wrong response data, expect a ParsingError', () async {
      final wrongMap = {...taskMap, 'id': null};

      client.whenSuccess(() => Response(data: [wrongMap]));

      final result = await datasource.getAllActiveTasks();

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('createTask expect a newly created Task', () async {
      client.whenSuccess(() => Response(data: taskMap));

      final result = await datasource.createTask(
        projectId: taskProjectId,
        sectionId: taskSectionId,
        taskContent: taskContent,
      );

      expect(result, isA<Success>());
      expect(result.success, isA<Task>());

      final task = result.success;

      expect(
        task,
        isA<Task>()
            .having((e) => e.id, 'id', '2995104339')
            .having((e) => e.projectId, 'project_id', taskProjectId)
            .having((e) => e.sectionId, 'section_id', taskSectionId)
            .having((e) => e.content, 'content', taskContent)
            .having((e) => e.createdAt, 'created_at', DateTime.parse('2019-12-11T22:36:50.000000Z'))
            .having((e) => e.commentCount, 'comment_count', 10)
            .having((e) => e.order, 'order', 1)
            .having((e) => e.description, 'description', ''),
      );
    }, tags: kUnitTestTag);

    test('createTask when wrong response data, expect a ParsingError', () async {
      final wrongMap = {...taskMap, 'id': null};

      client.whenSuccess(() => Response(data: wrongMap));

      final result = await datasource.createTask(
        projectId: taskProjectId,
        sectionId: taskSectionId,
        taskContent: taskContent,
      );

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('updateTask expect a updated Task', () async {
      const updatedTaskDurationSeconds = 2;
      const updatedTaskContent = 'Buy Milk and Eggs';
      const updatedTaskDescription = 'Buy Milk and Eggs from the store';
      final updatedTaskDescriptionWithMetadata = parseTaskDescriptionWithTrackingMetadata(
        updatedTaskDescription,
        updatedTaskDurationSeconds,
      );
      final updatedTaskMap = {
        ...taskMap,
        'content': updatedTaskContent,
        'description': updatedTaskDescriptionWithMetadata,
      };

      client.whenSuccess(() => Response(data: updatedTaskMap));

      final result = await datasource.updateTask(
        updatedTask: UpdatedTask(
          oldTask: Task.fromMap(taskMap),
          updatedContent: updatedTaskContent,
          updatedDescription: updatedTaskDescription,
          updatedTrackingDuration: const Duration(seconds: updatedTaskDurationSeconds),
        ),
      );

      expect(result, isA<Success>());
      expect(result.success, isA<Task>());

      final task = result.success;

      expect(
        task,
        isA<Task>()
            .having((e) => e.id, 'id', '2995104339')
            .having((e) => e.projectId, 'project_id', taskProjectId)
            .having((e) => e.sectionId, 'section_id', taskSectionId)
            .having((e) => e.content, 'content', updatedTaskContent)
            .having((e) => e.createdAt, 'created_at', DateTime.parse('2019-12-11T22:36:50.000000Z'))
            .having((e) => e.description, 'description', updatedTaskDescription)
            .having((e) => e.trackingDuration, 'task_duration', const Duration(seconds: updatedTaskDurationSeconds))
            .having((e) => e.commentCount, 'comment_count', 10)
            .having((e) => e.order, 'order', 1),
      );
    }, tags: kUnitTestTag);

    test('updateTask when wrong response data, expect a ParsingError', () async {
      final wrongMap = {...taskMap, 'content': null};

      client.whenSuccess(() => Response(data: wrongMap));

      final result = await datasource.updateTask(
        updatedTask: UpdatedTask(oldTask: Task.fromMap(taskMap)),
      );

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('deleteTask expect a Task to be deleted', () async {
      final task = Task.fromMap(taskMap);

      client.whenSuccess(() => Response(data: {}, statusCode: 204));

      final result = await datasource.deleteTask(task: task);

      expect(result, isA<Success>());
    }, tags: kUnitTestTag);

    test('deleteTask when failed to delete, expect a TaskNotDeleted error', () async {
      final task = Task.fromMap(taskMap);

      client.whenSuccess(() => Response(data: {}, statusCode: 200));

      final result = await datasource.deleteTask(task: task);

      expect(result, isA<Failure>());
      expect(result.failure, isA<TaskNotDeleted>());
    }, tags: kUnitTestTag);
  });
}
