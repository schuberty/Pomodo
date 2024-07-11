import 'project_section_model.dart';
import 'task_model.dart';

class Project {
  Project({
    required this.id,
    required this.name,
    required this.parentId,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      parentId: map['parent_id'] ?? '',
    );
  }

  final String id;
  final String name;
  final String parentId;
  final List<Task> tasks = [];
  final List<ProjectSection> sections = [];
}
