import 'package:equatable/equatable.dart';

import '../../../../shared/models/project_section_model.dart';
import '../../../../shared/models/task_model.dart';

class KanbanColumnViewData extends Equatable {
  const KanbanColumnViewData({
    required this.section,
    required this.tasks,
  });

  final ProjectSection section;
  final List<Task> tasks;

  @override
  List<Object?> get props => [section, tasks];
}
