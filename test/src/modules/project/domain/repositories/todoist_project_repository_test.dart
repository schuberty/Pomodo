import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/modules/project/data/datasources/project_datasource.dart';
import 'package:pomodo/src/modules/project/data/datasources/project_sections_datasource.dart';
import 'package:pomodo/src/modules/project/data/repositories/project_repository.dart';
import 'package:pomodo/src/modules/project/domain/repositories/todoist_project_repository.dart';
import 'package:pomodo/src/modules/task/data/datasources/task_comment_datasource.dart';
import 'package:pomodo/src/modules/task/data/datasources/task_datasource.dart';
import 'package:pomodo/src/shared/models/project_model.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../../mocks/mocks.dart';
import '../../../../../utils.dart';

void main() {
  group('TodoistProjectRepository integration', () {
    late HttpClient restClient;
    late HttpClient syncClient;

    late ProjectDatasource projectDatasource;
    late ProjectSectionDatasource projectSectionDatasource;
    late TaskDatasource taskDatasource;
    late TaskCommentDatasource taskCommentDatasource;

    late ProjectRepository projectRepository;

    final testProjectName = 'PomodoTest_${DateTime.now().millisecondsSinceEpoch}';

    late final Project testProjectCreated;

    setUp(() {
      restClient = getTodoistIntegrationApiClient();
      syncClient = HttpClientMock();

      projectDatasource = TodoistProjectDatasource(client: restClient);
      projectSectionDatasource = TodoistProjectSectionDatasource(client: restClient);
      taskDatasource = TodoistTaskDatasource(restClient: restClient, syncClient: syncClient);
      taskCommentDatasource = TodoistTaskCommentDatasource(client: restClient);

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
        isA<Project>()
            .having((e) => e.name, 'name', testProjectName)
            .having((e) => e.sections, 'sections', hasLength(3)),
      );

      testProjectCreated = result.success;
    }, tags: kIntegrationTestTag);

    tearDown(() async {
      await projectDatasource.deleteProject(project: testProjectCreated);
    });
  });
}
