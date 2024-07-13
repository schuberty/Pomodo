import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../shared/models/project_section_model.dart';
import '../../../../shared/models/task_model.dart';
import '../objects/task_command.dart';
import '../types.dart';

abstract class TaskRepository {
  Result<Task> createTask({required ProjectSection section, required NewTaskData data});

  Result<void> deleteTask({required Task task});

  Result<void> sendSyncCommands({required List<TaskCommand> commands});
}
