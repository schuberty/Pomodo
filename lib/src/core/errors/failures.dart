import 'package:pomodo_commons/pomodo_commons.dart';

class ProjectNotCreated implements ClientError {
  @override
  final message = 'Project not created';
}

class ObligatoryProjectSectionsNotCreated implements ClientError {
  @override
  final message = 'Obligatory Project sections not created';
}

class CommentNotDeleted implements ClientError {
  @override
  final message = 'Task comment not deleted';
}

class TaskNotDeleted implements ClientError {
  @override
  final message = 'Task not deleted';
}

class TaskCommandNotSynced implements ClientError {
  @override
  final message = 'At lest one Task command returned an error';
}
