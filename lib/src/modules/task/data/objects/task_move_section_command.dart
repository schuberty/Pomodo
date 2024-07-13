import '../../../../shared/models/project_section_model.dart';
import '../../../../shared/models/task_model.dart';
import 'task_command.dart';

class TaskMoveSectionCommand extends TaskCommand {
  const TaskMoveSectionCommand({required this.task, required this.toSection});

  final Task task;
  final ProjectSection toSection;

  @override
  final type = 'item_move';

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'args': {
        'id': task.id,
        'section_id': toSection.id,
      },
    };
  }
}
