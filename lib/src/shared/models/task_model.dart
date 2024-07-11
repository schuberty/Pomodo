import '../utils/utils.dart';

class Task {
  const Task({
    required this.id,
    required this.projectId,
    required this.sectionId,
    required this.content,
    required this.description,
    required this.commentCount,
    required this.trackingDuration,
    required this.createdAt,
    required this.order,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    final String rawDescription = map['description'];

    final metadata = parseTaskMetadataFromTaskDescription(rawDescription);

    return Task(
      id: map['id'],
      projectId: map['project_id'],
      sectionId: map['section_id'],
      content: map['content'],
      description: metadata.parsedDescription,
      commentCount: map['comment_count'],
      trackingDuration: metadata.trackingDuration,
      createdAt: DateTime.parse(map['created_at']),
      order: map['order'],
    );
  }

  final String id;
  final String projectId;
  final String sectionId;

  final String content;
  final DateTime createdAt;
  final String description;
  final int commentCount;
  final int order;

  /// Metadata field for how long the task has been tracked for
  final Duration trackingDuration;

  Map<String, dynamic> toMap() {
    final descriptionWithMetadata = parseTaskDescriptionWithTrackingMetadata(description, trackingDuration.inSeconds);

    return {
      'id': id,
      'project_id': projectId,
      'section_id': sectionId,
      'content': content,
      'description': descriptionWithMetadata,
      'comment_count': commentCount,
      'created_at': createdAt.toIso8601String(),
      'order': order,
    };
  }
}
