import '../enums/section_type_enum.dart';

class ProjectSection {
  ProjectSection({
    required this.id,
    required this.projectId,
    required this.type,
    required this.order,
  });

  factory ProjectSection.fromMap(Map<String, dynamic> map) {
    return ProjectSection(
      id: map['id'],
      projectId: map['project_id'],
      type: SectionType.fromMap(map),
      order: map['order'],
    );
  }

  final String id;
  final String projectId;
  final SectionType type;
  final int order;
}
