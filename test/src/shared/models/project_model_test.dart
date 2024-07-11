import 'package:flutter_test/flutter_test.dart';
import 'package:pomodo/src/shared/models/project_model.dart';

import '../../../utils.dart';

void main() {
  group('Project', () {
    test('fromMap expect Project object', () {
      expect(
        Project.fromMap(<String, dynamic>{
          'id': '1',
          'name': 'Project name',
          'parent_id': '1',
        }),
        isA<Project>()
            .having((e) => e.id, 'id', '1')
            .having((e) => e.name, 'name', 'Project name')
            .having((e) => e.sections, 'sections', [])
            .having((e) => e.parentId, 'parent_id', '1')
            .having((e) => e.tasks, 'tasks', []),
      );
    }, tags: kUnitTestTag);

    test('fromMap when parent_id is null, expect Project object with empty parent_id', () {
      expect(
        Project.fromMap(<String, dynamic>{
          'id': '1',
          'name': 'Project name',
          'parent_id': null,
        }),
        isA<Project>()
            .having((e) => e.id, 'id', '1')
            .having((e) => e.name, 'name', 'Project name')
            .having((e) => e.sections, 'sections', [])
            .having((e) => e.parentId, 'parent_id', '')
            .having((e) => e.tasks, 'tasks', []),
      );
    }, tags: kUnitTestTag);
  });
}
