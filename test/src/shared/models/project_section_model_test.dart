import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/shared/enums/section_type_enum.dart';
import 'package:pomodo/src/shared/models/project_section_model.dart';

import '../../../utils.dart';

void main() {
  group('ProjectSection', () {
    test('fromMap expect ProjectSection object', () {
      expect(
        ProjectSection.fromMap(<String, dynamic>{
          'id': '1',
          'project_id': '1',
          'name': 'To Do',
          'order': 0,
        }),
        isA<ProjectSection>()
            .having((e) => e.id, 'id', '1')
            .having((e) => e.projectId, 'project_id', '1')
            .having((e) => e.type, 'type', SectionType.todo)
            .having((e) => e.order, 'order', 0),
      );
    }, tags: kUnitTestTag);
  });
}
