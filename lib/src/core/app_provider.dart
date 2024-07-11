import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../modules/project/data/project_datasource.dart';
import '../modules/project/data/project_sections_datasource.dart';
import '../modules/project/data/repositories/project_repository.dart';
import '../modules/project/domain/repositories/todoist_project_repository.dart';
import '../modules/project/presentation/cubit/project_cubit.dart';
import '../modules/task/data/task_comment_datasource.dart';
import '../modules/task/data/task_datasource.dart';

class AppProvider extends StatefulWidget {
  const AppProvider({super.key, required this.child});

  final Widget child;

  @override
  State<AppProvider> createState() => _AppProviderState();
}

class _AppProviderState extends State<AppProvider> {
  late final HttpClient todoistClient = DioClient.baseUrl(
    Constants.todoistBaseUrl,
    interceptors: [ApiTokenInterceptor(apiToken: Constants.todoistTestToken)],
  );

  late final ProjectDatasource projectDatasource = TodoistProjectDatasource(client: todoistClient);
  late final ProjectSectionDatasource projectSectionDatasource = TodoistProjectSectionDatasource(client: todoistClient);
  late final TaskDatasource taskDatasource = TodoistTaskDatasource(client: todoistClient);
  late final TaskCommentDatasource taskCommentDatasource = TodoistTaskCommentDatasource(client: todoistClient);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProjectRepository>(
          create: (_) => TodoistProjectRepository(
            projectDatasource: projectDatasource,
            projectSectionDatasource: projectSectionDatasource,
            taskDatasource: taskDatasource,
            taskCommentDatasource: taskCommentDatasource,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProjectStoreCubit>(
            create: (context) => AppProjectStoreCubit(
              projectRepository: context.read(),
            ),
          ),
        ],
        child: widget.child,
      ),
    );
  }
}
