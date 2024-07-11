import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/modules/project/data/project_datasource.dart';
import 'package:pomodo/src/modules/project/data/project_sections_datasource.dart';
import 'package:pomodo/src/modules/project/data/repositories/project_repository.dart';
import 'package:pomodo/src/modules/project/domain/repositories/todoist_project_repository.dart';
import 'package:pomodo/src/modules/task/data/task_comment_datasource.dart';
import 'package:pomodo/src/modules/task/data/task_datasource.dart';
import 'package:pomodo/src/shared/models/project_model.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../../utils.dart';

void main() {
  group('TodoistProjectRepository integration', () {
    late HttpClient client;

    late ProjectDatasource projectDatasource;
    late ProjectSectionDatasource projectSectionDatasource;
    late TaskDatasource taskDatasource;
    late TaskCommentDatasource taskCommentDatasource;

    late ProjectRepository projectRepository;

    final testProjectName = 'PomodoTest_${DateTime.now().millisecondsSinceEpoch}';

    late final Project testProjectCreated;

    setUp(() {
      client = getTodoistIntegrationApiClient();

      projectDatasource = TodoistProjectDatasource(client: client);
      projectSectionDatasource = TodoistProjectSectionDatasource(client: client);
      taskDatasource = TodoistTaskDatasource(client: client);
      taskCommentDatasource = TodoistTaskCommentDatasource(client: client);

      projectRepository = TodoistProjectRepository(
        projectDatasource: projectDatasource,
        projectSectionDatasource: projectSectionDatasource,
        taskDatasource: taskDatasource,
        taskCommentDatasource: taskCommentDatasource,
      );
    });

    test('getPomodoProject expect the parent Pomodo Project object', () async {
      final result = await projectRepository.getPomodoProject(projectName: testProjectName);

      expect(result, isA<Success>());
      expect(
        result.success,
        isA<Project>().having((e) => e.name, 'name', testProjectName),
      );

      testProjectCreated = result.success;
    }, tags: kIntegrationTestTag);

    tearDown(() async {
      await projectDatasource.deleteProject(project: testProjectCreated);
    });
  });
}
