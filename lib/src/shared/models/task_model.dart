import 'package:equatable/equatable.dart';

import '../utils/utils.dart';

class Task extends Equatable {
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

  factory Task.unsynced({
    required String id,
    required String content,
    required String description,
    required String sectionId,
    required int order,
  }) {
    return Task(
      id: id,
      projectId: '',
      sectionId: sectionId,
      content: content,
      description: description,
      commentCount: 0,
      trackingDuration: Duration.zero,
      createdAt: DateTime.now(),
      order: order,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final String rawDescription = map['description'];

    final metadata = parseTaskMetadataFromTaskDescription(rawDescription);

    return Task(
      id: map['id'],
      projectId: map['project_id'],
      sectionId: map['section_id'] ?? '',
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

  Task copyWith({
    String? sectionId,
    String? content,
    String? description,
    int? commentCount,
    int? order,
    Duration? trackingDuration,
    bool? isUpdating,
  }) {
    return Task(
      id: id,
      projectId: projectId,
      sectionId: sectionId ?? this.sectionId,
      content: content ?? this.content,
      description: description ?? this.description,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt,
      order: order ?? this.order,
      trackingDuration: trackingDuration ?? this.trackingDuration,
    );
  }

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

  @override
  List<Object?> get props => [
        id,
        projectId,
        sectionId,
        content,
        description,
        commentCount,
        trackingDuration,
        createdAt,
        order,
      ];
}
