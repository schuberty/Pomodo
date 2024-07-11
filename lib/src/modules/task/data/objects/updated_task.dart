import '../../../../shared/models/task_model.dart';
import '../../../../shared/utils/utils.dart';

class UpdatedTask {
  UpdatedTask({
    required this.oldTask,
    this.updatedContent,
    this.updatedDescription,
    this.updatedTrackingDuration,
  });

  final Task oldTask;

  final String? updatedContent;
  final String? updatedDescription;
  final Duration? updatedTrackingDuration;

  Map<String, dynamic> toMap() {
    var description = updatedDescription ?? oldTask.description;

    description = parseTaskDescriptionWithTrackingMetadata(
      description,
      updatedTrackingDuration?.inSeconds ?? oldTask.trackingDuration.inSeconds,
    );

    return {
      if (updatedContent != null) 'content': updatedContent,
      'description': description,
    };
  }
}
