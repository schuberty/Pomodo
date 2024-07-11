import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../shared/enums/section_type_enum.dart';
import '../../../shared/models/project_section_model.dart';

abstract class ProjectSectionDatasource {
  Result<List<ProjectSection>> getAllSections();

  Result<ProjectSection> createSection({required String projectId, required SectionType type});
}

class TodoistProjectSectionDatasource implements ProjectSectionDatasource {
  const TodoistProjectSectionDatasource({required this.client});

  final HttpClient client;

  @override
  Result<List<ProjectSection>> getAllSections() async {
    final endpoint = Endpoint('/sections', method: Method.GET);

    final response = await client.request(endpoint);

    try {
      return response.map<List<ProjectSection>>((response) {
        final sectionMaps = response.data as List;

        return sectionMaps.map((map) => ProjectSection.fromMap(map)).toList();
      });
    } on Error catch (error) {
      AppLogger.error('Error while parsing of ProjectSection model list', error: error);

      return Failure(ParsingError());
    }
  }

  @override
  Result<ProjectSection> createSection({required String projectId, required SectionType type}) async {
    final endpoint = Endpoint('/sections', method: Method.POST);

    final response = await client.request(
      endpoint,
      data: {
        'project_id': projectId,
        'name': type.name,
      },
    );

    try {
      return response.map<ProjectSection>((response) => ProjectSection.fromMap(response.data));
    } on Error catch (error) {
      AppLogger.error('Error while parsing of ProjectSection model', error: error);

      return Failure(ParsingError());
    }
  }
}
