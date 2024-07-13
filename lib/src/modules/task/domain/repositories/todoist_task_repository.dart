import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../shared/models/project_section_model.dart';
import '../../../../shared/models/task_model.dart';
import '../../data/datasources/task_datasource.dart';
import '../../data/objects/task_command.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/types.dart';

class TodoistTaskRepository implements TaskRepository {
  TodoistTaskRepository({required this.taskDatasource});

  final TaskDatasource taskDatasource;

  @override
  Result<Task> createTask({required ProjectSection section, required NewTaskData data}) async {
    return await taskDatasource.createTask(
      projectId: section.projectId,
      sectionId: section.id,
      taskContent: data.taskContent,
      taskDescription: data.taskDescription,
    );
  }

  @override
  Result<void> deleteTask({required Task task}) async {
    return await taskDatasource.deleteTask(task: task);
  }

  @override
  Result<void> sendSyncCommands({required List<TaskCommand> commands}) async {
    return await taskDatasource.syncCommands(commands: commands);
  }
}
