class TaskComment {
  TaskComment({
    required this.id,
    required this.taskId,
    required this.content,
    required this.postedAt,
  });

  factory TaskComment.fromMap(Map<String, dynamic> map) {
    return TaskComment(
      id: map['id'],
      taskId: map['task_id'],
      content: map['content'],
      postedAt: DateTime.parse(map['posted_at']),
    );
  }

  final String id;
  final String taskId;
  final String content;
  final DateTime postedAt;
}
