import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/models/task_comment_model.dart';
import '../../../../shared/models/task_model.dart';

abstract class TaskCommentDatasource {
  Result<List<TaskComment>> getTaskComments({required Task task});

  Result<TaskComment> createComment({required Task task, required String commentContent});

  Result<void> deleteComment({required TaskComment comment});
}

class TodoistTaskCommentDatasource implements TaskCommentDatasource {
  const TodoistTaskCommentDatasource({required this.client});

  final HttpClient client;

  @override
  Result<List<TaskComment>> getTaskComments({required Task task}) async {
    final endpoint = Endpoint(
      '/comments',
      method: Method.GET,
      queries: {'task_id': task.id},
    );

    final response = await client.request(endpoint);

    try {
      return response.map<List<TaskComment>>((response) {
        final taskMaps = response.data as List;

        return taskMaps.map((map) => TaskComment.fromMap(map)).toList();
      });
    } on Error catch (error) {
      AppLogger.error('Error while parsing of TaskComment model list', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<TaskComment> createComment({required Task task, required String commentContent}) async {
    final endpoint = Endpoint('/comments', method: Method.POST);

    final response = await client.request(
      endpoint,
      data: {
        'task_id': task.id,
        'content': commentContent,
      },
    );

    try {
      return response.map<TaskComment>((response) => TaskComment.fromMap(response.data));
    } on Error catch (error) {
      AppLogger.error('Error while parsing of TaskComment model', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<void> deleteComment({required TaskComment comment}) async {
    final endpoint = Endpoint('/comments/${comment.id}', method: Method.DELETE);

    final response = await client.request(endpoint);

    if (response.isSuccess && response.success.statusCode != 204) {
      return Failure(CommentNotDeleted());
    }

    return response;
  }
}
