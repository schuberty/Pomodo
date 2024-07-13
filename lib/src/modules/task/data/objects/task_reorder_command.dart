import '../../../../shared/models/task_model.dart';
import 'task_command.dart';

typedef ChildOrder = int;

class TaskReorderCommand extends TaskCommand {
  const TaskReorderCommand({required this.args});

  final Map<Task, ChildOrder> args;

  @override
  final type = 'item_reorder';

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'args': {
        'items': [
          for (final arg in args.entries)
            {
              'id': arg.key.id,
              'child_order': arg.value,
            }
        ]
      }
    };
  }
}
