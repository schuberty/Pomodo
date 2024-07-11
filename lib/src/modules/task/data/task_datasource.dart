import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../shared/models/task_model.dart';
import 'objects/updated_task.dart';

class TaskNotDeleted implements ClientError {
  @override
  final message = 'Task not deleted';
}

abstract class TaskDatasource {
  Result<List<Task>> getAllActiveTasks();

  Result<Task> createTask({required String projectId, required String sectionId, required String taskContent});

  Result<Task> updateTask({required UpdatedTask updatedTask});

  Result<void> deleteTask({required Task task});
}

class TodoistTaskDatasource implements TaskDatasource {
  const TodoistTaskDatasource({required this.client});

  final HttpClient client;

  @override
  Result<List<Task>> getAllActiveTasks() async {
    final endpoint = Endpoint('/tasks', method: Method.GET);

    final response = await client.request(endpoint);

    try {
      return response.map<List<Task>>((response) {
        final taskMaps = response.data as List;

        return taskMaps.map((map) => Task.fromMap(map)).toList();
      });
    } on Error catch (error) {
      AppLogger.error('Error while parsing of Task model list', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<Task> createTask({required String projectId, required String sectionId, required String taskContent}) async {
    final endpoint = Endpoint('/tasks', method: Method.POST);

    final response = await client.request(
      endpoint,
      data: {
        'project_id': projectId,
        'section_id': sectionId,
        'content': taskContent,
      },
    );

    try {
      return response.map<Task>((response) => Task.fromMap(response.data));
    } on Error catch (error) {
      AppLogger.error('Error while parsing of Task model', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<Task> updateTask({required UpdatedTask updatedTask}) async {
    final endpoint = Endpoint('/tasks/${updatedTask.oldTask.id}', method: Method.POST);

    final response = await client.request(
      endpoint,
      data: updatedTask.toMap(),
    );

    try {
      return response.map<Task>((response) => Task.fromMap(response.data));
    } on Error catch (error) {
      AppLogger.error('Error while parsing of Task model updated', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<void> deleteTask({required Task task}) async {
    final endpoint = Endpoint('/tasks/${task.id}', method: Method.DELETE);

    final response = await client.request(endpoint);

    if (response.isSuccess && response.success?.statusCode != 204) {
      return Failure(TaskNotDeleted());
    }

    return response;
  }
}
