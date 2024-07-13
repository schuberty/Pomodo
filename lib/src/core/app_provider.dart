import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../modules/project/data/datasources/project_datasource.dart';
import '../modules/project/data/datasources/project_sections_datasource.dart';
import '../modules/project/data/repositories/project_repository.dart';
import '../modules/project/domain/repositories/todoist_project_repository.dart';
import '../modules/project/presentation/cubit/project_store_cubit.dart';
import '../modules/task/data/datasources/task_comment_datasource.dart';
import '../modules/task/data/datasources/task_datasource.dart';
import '../modules/task/data/repositories/task_repository.dart';
import '../modules/task/domain/repositories/todoist_task_repository.dart';

class AppProvider extends StatefulWidget {
  const AppProvider({super.key, required this.child});

  final Widget child;

  @override
  State<AppProvider> createState() => _AppProviderState();
}

class _AppProviderState extends State<AppProvider> {
  late final HttpClient todoistRestClient = DioClient.baseUrl(
    Constants.todoistBaseRestUrl,
    interceptors: [ApiTokenInterceptor(apiToken: Constants.todoistTestToken)],
  );

  late final HttpClient todoistSyncClient = DioClient.baseUrl(
    Constants.todoistBaseSyncUrl,
    interceptors: [ApiTokenInterceptor(apiToken: Constants.todoistTestToken)],
  );

  late final ProjectDatasource projectDatasource = TodoistProjectDatasource(client: todoistRestClient);
  late final ProjectSectionDatasource projectSectionDatasource =
      TodoistProjectSectionDatasource(client: todoistRestClient);
  late final TaskDatasource taskDatasource =
      TodoistTaskDatasource(restClient: todoistRestClient, syncClient: todoistSyncClient);
  late final TaskCommentDatasource taskCommentDatasource = TodoistTaskCommentDatasource(client: todoistRestClient);

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
        RepositoryProvider<TaskRepository>(
          create: (_) => TodoistTaskRepository(
            taskDatasource: taskDatasource,
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
        child: TranslationProvider(
          child: widget.child,
        ),
      ),
    );
  }
}
