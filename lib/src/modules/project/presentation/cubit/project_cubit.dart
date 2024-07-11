import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../shared/models/project_model.dart';
import '../../data/repositories/project_repository.dart';

part 'project_state.dart';

abstract class ProjectStoreCubit extends Cubit<ProjectStoreState> {
  ProjectStoreCubit(super.initialState);

  void loadMainProject();
}

class AppProjectStoreCubit extends ProjectStoreCubit {
  AppProjectStoreCubit({required this.projectRepository}) : super(ProjectStoreInitial());

  final ProjectRepository projectRepository;

  @override
  Future<void> loadMainProject() async {
    emit(ProjectStoreLoading());

    final projectResult = await projectRepository.getPomodoProject(projectName: Constants.pomodoTodoistProjectName);

    if (projectResult.isFailure) {
      final failure = projectResult.failure;

      emit(ProjectStoreError(message: failure.message));
    }

    final project = projectResult.success;

    emit(ProjectStoreLoaded(project: project));
  }
}
