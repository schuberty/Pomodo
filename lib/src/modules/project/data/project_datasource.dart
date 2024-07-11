import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../shared/models/project_model.dart';

abstract class ProjectDatasource {
  Result<List<Project>> getAllProjects();

  Result<Project> createProject({required String projectName});

  Result<void> deleteProject({required Project project});
}

class TodoistProjectDatasource implements ProjectDatasource {
  const TodoistProjectDatasource({required this.client});

  final HttpClient client;

  @override
  Result<List<Project>> getAllProjects() async {
    final endpoint = Endpoint('/projects', method: Method.GET);

    final response = await client.request(endpoint);

    try {
      return response.map<List<Project>>((response) {
        final projectMaps = response.data as List;

        return projectMaps.map((map) => Project.fromMap(map)).toList();
      });
    } on Error catch (error) {
      AppLogger.error('Error while parsing of Project model list', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<Project> createProject({required String projectName}) async {
    final endpoint = Endpoint('/projects', method: Method.POST);

    final response = await client.request(
      endpoint,
      data: {
        'name': projectName,
        // In case it's visualized in the Todoist view, show as a board
        'view_style': 'board'
      },
    );

    try {
      return response.map<Project>((response) => Project.fromMap(response.data));
    } on Error catch (error) {
      AppLogger.error('Error while parsing of Project model', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<void> deleteProject({required Project project}) async {
    final endpoint = Endpoint('/projects/${project.id}', method: Method.DELETE);

    final response = await client.request(endpoint);

    return response.map<void>((_) {});
  }
}
