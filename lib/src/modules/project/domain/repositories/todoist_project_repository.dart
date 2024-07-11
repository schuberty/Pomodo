import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/enums/section_type_enum.dart';
import '../../../../shared/models/project_model.dart';
import '../../../../shared/models/project_section_model.dart';
import '../../../../shared/models/task_model.dart';
import '../../../task/data/task_comment_datasource.dart';
import '../../../task/data/task_datasource.dart';
import '../../data/project_datasource.dart';
import '../../data/project_sections_datasource.dart';
import '../../data/repositories/project_repository.dart';

class TodoistProjectRepository implements ProjectRepository {
  TodoistProjectRepository({
    required this.projectDatasource,
    required this.projectSectionDatasource,
    required this.taskDatasource,
    required this.taskCommentDatasource,
  });

  final ProjectDatasource projectDatasource;
  final ProjectSectionDatasource projectSectionDatasource;
  final TaskDatasource taskDatasource;
  final TaskCommentDatasource taskCommentDatasource;

  @override
  Result<Project> getPomodoProject({required String projectName}) async {
    final parentProjectResult = await getParentProject(projectName);

    if (parentProjectResult.isFailure) {
      return Failure(parentProjectResult.failure);
    }

    // TODO: In case multiple projects are implemented, here the parent project will filter throw all projects that have the parent as a ID
    final parentProject = parentProjectResult.success;

    final sectionsResult = await getParentProjectSections(parentProject);

    if (sectionsResult.isFailure) {
      return Failure(sectionsResult.failure);
    }

    final sections = sectionsResult.success;

    final tasksResult = await getParentProjectTasks(parentProject);

    if (tasksResult.isFailure) {
      return Failure(tasksResult.failure);
    }

    final tasks = tasksResult.success;

    final pomodoProject = joinProjectData(parentProject, sections, tasks);

    return Success(pomodoProject);
  }

  Result<Project> getParentProject(String projectName) async {
    final projectsResult = await projectDatasource.getAllProjects();

    if (projectsResult.isFailure) {
      return Failure(projectsResult.failure);
    }

    final projects = projectsResult.success;

    Project? parentProject;

    for (var project in projects) {
      if (project.name == projectName) {
        parentProject = project;
        break;
      }
    }

    if (parentProject == null) {
      final pomodoProjectResult = await createParentProject(projectName);

      if (pomodoProjectResult.isFailure) {
        return Failure(ProjectNotCreated());
      }

      parentProject = pomodoProjectResult.success;
    }

    return Success(parentProject);
  }

  Result<Project> createParentProject(String projectName) async {
    return await projectDatasource.createProject(projectName: projectName);
  }

  Result<List<ProjectSection>> getParentProjectSections(Project project) async {
    final sectionsResult = await projectSectionDatasource.getAllSections();

    if (sectionsResult.isFailure) {
      return Failure(sectionsResult.failure);
    }

    // Filter only correct section types
    final sections = sectionsResult.success;
    sections.removeWhere((section) => section.type == SectionType.invalid);

    // Check if all valid sections are present
    final missingSectionTypes = [...SectionType.values];
    missingSectionTypes.removeWhere((type) => type == SectionType.invalid);

    for (var section in sections) {
      missingSectionTypes.remove(section.type);
    }

    if (missingSectionTypes.isEmpty) {
      return Success(sections);
    }

    // If missing, create them and add to the list
    final missingTypesResult = await createMissingParentProjectSections(missingSectionTypes, project);

    if (missingTypesResult.isFailure) {
      return Failure(ObligatoryProjectSectionsNotCreated());
    }

    sections.addAll(missingTypesResult.success);

    return Success(sections);
  }

  Result<List<ProjectSection>> createMissingParentProjectSections(
      List<SectionType> missingTypes, Project project) async {
    final newSections = <ProjectSection>[];

    for (var missingType in missingTypes) {
      final sectionResult = await projectSectionDatasource.createSection(projectId: project.id, type: missingType);

      if (sectionResult.isFailure) {
        return Failure(sectionResult.failure);
      }

      newSections.add(sectionResult.success);
    }

    return Success(newSections);
  }

  Result<List<Task>> getParentProjectTasks(Project project) async {
    final tasksResult = await taskDatasource.getAllActiveTasks();

    if (tasksResult.isFailure) {
      return Failure(tasksResult.failure);
    }

    final tasks = tasksResult.success;

    final parentProjectTasks = tasks.where((task) => task.projectId == project.id).toList();

    return Success(parentProjectTasks);
  }

  Project joinProjectData(Project project, List<ProjectSection> sections, List<Task> tasks) {
    project.sections.addAll(sections);

    project.tasks.addAll(tasks);

    return project;
  }
}
