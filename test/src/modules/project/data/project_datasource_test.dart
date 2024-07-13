import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/modules/project/data/datasources/project_datasource.dart';
import 'package:pomodo/src/shared/models/project_model.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../mocks/mocks.dart';
import '../../../../utils.dart';

void main() {
  group('ProjectDatasource', () {
    late HttpClientMock client;
    late ProjectDatasource datasource;

    late final Project createdProject;

    setUp(() {
      client = HttpClientMock();
      datasource = TodoistProjectDatasource(client: client);
    });

    test('getAllProjects expect a list of Projects', () async {
      client.whenSuccess(
        () => Response(data: [
          {'id': '1', 'name': 'Project 1'},
          {'id': '2', 'name': 'Project 2'},
        ]),
      );

      final result = await datasource.getAllProjects();

      expect(result, isA<Success>());
      expect(result.success, isA<List<Project>>());
      expect(result.success, hasLength(2));

      final firstProject = result.success.first;

      expect(
        firstProject,
        isA<Project>().having((e) => e.id, 'id', '1').having((e) => e.name, 'name', 'Project 1'),
      );
    }, tags: kUnitTestTag);

    test('getAllProjects when wrong response data, expect a ParsingError', () async {
      client.whenSuccess(
        () => Response(data: [
          {'id': 1, 'name': 'Project 1'}
        ]),
      );

      final result = await datasource.getAllProjects();

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('createProject expect a newly created Project', () async {
      const projectName = 'New Project';

      client.whenSuccess(() => Response(data: {'id': '1', 'name': projectName}));

      final result = await datasource.createProject(projectName: projectName);

      expect(result, isA<Success>());
      expect(
        result.success,
        isA<Project>().having((e) => e.id, 'id', '1').having((e) => e.name, 'name', projectName),
      );

      createdProject = result.success;
    }, tags: kUnitTestTag);

    test('createProject when wrong response data, expect a ParsingError', () async {
      const projectName = 'New Project';

      client.whenSuccess(() => Response(data: {'id': 1, 'name': projectName}));

      final result = await datasource.createProject(projectName: projectName);

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('deleteProject expect the newly created Project to be deleted', () async {
      client.whenSuccess(() => Response(data: {}));

      final result = await datasource.deleteProject(project: createdProject);

      expect(result, isA<Success>());
    }, tags: kUnitTestTag);
  });

  group('ProjectDatasource integration', () {
    late HttpClient client;
    late ProjectDatasource datasource;

    late final Project createdProject;

    setUp(() {
      client = getTodoistIntegrationApiClient();
      datasource = TodoistProjectDatasource(client: client);
    });

    test('getAllProjects expect a list of Projects', () async {
      final result = await datasource.getAllProjects();

      expect(result, isA<Success>());
      expect(result.success, isA<List<Project>>());
    }, tags: kIntegrationTestTag);

    test('createProject expect a newly created Project', () async {
      const projectName = 'New Project';

      final result = await datasource.createProject(projectName: projectName);

      expect(result, isA<Success>());
      expect(result.success, isA<Project>().having((e) => e.name, 'name', projectName));

      createdProject = result.success;
    }, tags: kIntegrationTestTag);

    test('deleteProject expect the newly created Project to be deleted', () async {
      final result = await datasource.deleteProject(project: createdProject);

      expect(result, isA<Success>());
    }, tags: kIntegrationTestTag);
  });
}
