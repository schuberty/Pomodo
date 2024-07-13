import '../../../../shared/models/task_model.dart';
import '../../../../shared/utils/utils.dart';
import 'task_command.dart';

class TaskUpdateCommand extends TaskCommand {
  const TaskUpdateCommand({
    required this.taskToUpdate,
    this.content,
    this.description,
    this.trackingDuration,
  });

  final Task taskToUpdate;

  final String? content;
  final String? description;
  final Duration? trackingDuration;

  @override
  final type = 'item_update';

  @override
  Map<String, dynamic> toMap() {
    final args = <String, dynamic>{
      'id': taskToUpdate.id,
    };

    if (content != null) {
      args['content'] = content;
    }

    if (description != null || trackingDuration != null) {
      final currentDescription = description ?? taskToUpdate.description;
      final currentDuration = trackingDuration ?? taskToUpdate.trackingDuration;

      args['description'] = parseTaskDescriptionWithTrackingMetadata(
        currentDescription,
        currentDuration.inSeconds,
      );
    }

    return {
      ...super.toMap(),
      'args': args,
    };
  }
}
