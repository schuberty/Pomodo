import 'package:pomodo_commons/pomodo_commons.dart';

class ProjectNotCreated implements ClientError {
  @override
  final message = 'Project not created';
}

class ObligatoryProjectSectionsNotCreated implements ClientError {
  @override
  final message = 'Obligatory Project sections not created';
}
