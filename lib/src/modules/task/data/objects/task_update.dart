import '../../../../shared/models/task_model.dart';
import '../../../../shared/utils/utils.dart';

// TODO: Remove task update if enough time
@Deprecated('Use [TaskUpdateCommand] with Sync API instead')
class TaskUpdate {
  TaskUpdate({
    required this.taskToUpdate,
    this.sectionId,
    this.order,
    this.content,
    this.description,
    this.trackingDuration,
  });

  final Task taskToUpdate;

  final String? sectionId;
  final int? order;
  final String? content;
  final String? description;
  final Duration? trackingDuration;

  Map<String, dynamic> toMap() {
    final updateMap = <String, dynamic>{};

    if (sectionId != null) {
      updateMap['section_id'] = sectionId;
    }

    if (order != null) {
      updateMap['order'] = order;
    }

    if (content != null) {
      updateMap['content'] = content;
    }

    if (description != null) {
      final currentDuration = trackingDuration ?? taskToUpdate.trackingDuration;

      updateMap['description'] = parseTaskDescriptionWithTrackingMetadata(
        description ?? '',
        currentDuration.inSeconds,
      );
    }

    // TODO: Better way to handle this
    if (trackingDuration != null) {
      final descriptionWithTracking = description ?? taskToUpdate.description;

      updateMap['description'] = parseTaskDescriptionWithTrackingMetadata(
        descriptionWithTracking,
        trackingDuration?.inSeconds ?? 0,
      );
    }

    return updateMap;
  }
}
