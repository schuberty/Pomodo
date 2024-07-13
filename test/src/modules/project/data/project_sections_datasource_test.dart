import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/modules/project/data/datasources/project_sections_datasource.dart';
import 'package:pomodo/src/shared/enums/section_type_enum.dart';
import 'package:pomodo/src/shared/models/project_section_model.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../mocks/mocks.dart';
import '../../../../utils.dart';

void main() {
  group('ProjectSectionDatasource', () {
    late HttpClientMock client;
    late ProjectSectionDatasource datasource;

    setUp(() {
      client = HttpClientMock();
      datasource = TodoistProjectSectionDatasource(client: client);
    });

    test('getAllSections expect a list of ProjectSections', () async {
      client.whenSuccess(
        () => Response(data: [
          {
            'id': '7025',
            'project_id': '2203306141',
            'order': 1,
            'name': 'To Do',
          }
        ]),
      );

      final result = await datasource.getAllSections();

      expect(result, isA<Success>());
      expect(result.success, isA<List<ProjectSection>>());
      expect(result.success, hasLength(1));

      final firstSection = result.success.first;

      expect(
        firstSection,
        isA<ProjectSection>()
            .having((e) => e.id, 'id', '7025')
            .having((e) => e.projectId, 'project_id', '2203306141')
            .having((e) => e.order, 'order', 1)
            .having((e) => e.type, 'type', SectionType.todo),
      );
    }, tags: kUnitTestTag);

    test('getAllSections when wrong response data, expect a ParsingError', () async {
      client.whenSuccess(
        () => Response(data: [
          {
            'id': 7025,
            'project_id': '2203306141',
            'order': '1',
            'name': 'To Do',
          }
        ]),
      );

      final result = await datasource.getAllSections();

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);

    test('createSection expect a newly created ProjectSections', () async {
      const projectId = '2203306141';

      client.whenSuccess(
        () => Response(data: {
          'id': '7025',
          'project_id': projectId,
          'order': 1,
          'name': 'To Do',
        }),
      );

      final result = await datasource.createSection(
        projectId: projectId,
        type: SectionType.todo,
      );

      expect(result, isA<Success>());
      expect(result.success, isA<ProjectSection>());

      final section = result.success;

      expect(
        section,
        isA<ProjectSection>()
            .having((e) => e.id, 'id', '7025')
            .having((e) => e.projectId, 'project_id', projectId)
            .having((e) => e.order, 'order', 1)
            .having((e) => e.type, 'type', SectionType.todo),
      );
    }, tags: kUnitTestTag);

    test('createSection when wrong response data, expect a ParsingError', () async {
      const projectId = '2203306141';

      client.whenSuccess(
        () => Response(data: [
          {
            'id': 7025,
            'project_id': projectId,
            'order': '1',
            'name': 'To Do',
          }
        ]),
      );

      final result = await datasource.createSection(projectId: projectId, type: SectionType.todo);

      expect(result, isA<Failure>());
      expect(result.failure, isA<ParsingError>());
    }, tags: kUnitTestTag);
  });
}
