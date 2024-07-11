import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../shared/models/project_model.dart';

abstract class ProjectRepository {
  Result<Project> getPomodoProject({required String projectName});
}
