import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/models/task_model.dart';
import '../objects/task_command.dart';
import '../objects/task_update.dart';

const _kSyncResponseSuccess = 'ok';

abstract class TaskDatasource {
  Result<List<Task>> getAllActiveTasks();

  Result<Task> createTask({
    required String projectId,
    required String sectionId,
    required String taskContent,
    required String taskDescription,
  });

  Result<Task> updateTask({required TaskUpdate taskUpdate});

  Result<void> deleteTask({required Task task});

  Result<void> syncCommands({required List<TaskCommand> commands});
}

class TodoistTaskDatasource implements TaskDatasource {
  const TodoistTaskDatasource({required this.restClient, required this.syncClient});

  final HttpClient restClient;
  final HttpClient syncClient;

  @override
  Result<List<Task>> getAllActiveTasks() async {
    final endpoint = Endpoint('/tasks', method: Method.GET);

    final response = await restClient.request(endpoint);

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
  Result<Task> createTask({
    required String projectId,
    required String sectionId,
    required String taskContent,
    required String taskDescription,
  }) async {
    final endpoint = Endpoint('/tasks', method: Method.POST);

    final response = await restClient.request(
      endpoint,
      data: {
        'project_id': projectId,
        'section_id': sectionId,
        'content': taskContent,
        'description': taskDescription,
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
  Result<Task> updateTask({required TaskUpdate taskUpdate}) async {
    final endpoint = Endpoint('/tasks/${taskUpdate.taskToUpdate.id}', method: Method.POST);

    // TODO: Add check if updatedTask has no changes to update
    final response = await restClient.request(
      endpoint,
      data: taskUpdate.toMap(),
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

    final response = await restClient.request(endpoint);

    if (response.isSuccess && response.success.statusCode != 204) {
      return Failure(TaskNotDeleted());
    }

    return response;
  }

  @override
  Result<void> syncCommands({required List<TaskCommand> commands}) async {
    final endpoint = Endpoint('/sync', method: Method.POST);

    final responseResult = await syncClient.request(
      endpoint,
      data: {
        'commands': commands.map((command) => command.toMap()).toList(),
      },
    );

    if (responseResult.isFailure) {
      return responseResult;
    }

    try {
      final response = responseResult.success;

      final Map<String, dynamic> map = response.data;

      final Map<String, dynamic> syncStatus = map['sync_status'];

      // While not the best aproach, I only saw that certain updates can only be done via the Sync API at the last moment.
      for (final syncStatus in syncStatus.entries) {
        if (syncStatus.value != _kSyncResponseSuccess) {
          return Failure(TaskCommandNotSynced());
        }
      }

      return const Success(null);
    } on Error catch (error) {
      AppLogger.error('Error while parsing of Sync commands return', error: error);

      return Failure(ParsingError());
    }
  }
}
