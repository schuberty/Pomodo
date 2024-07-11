part of 'project_cubit.dart';

sealed class ProjectStoreState extends Equatable {
  const ProjectStoreState();

  @override
  List<Object> get props => [];
}

final class ProjectStoreInitial extends ProjectStoreState {}

final class ProjectStoreLoading extends ProjectStoreState {}

final class ProjectStoreLoaded extends ProjectStoreState {
  const ProjectStoreLoaded({required this.project});

  final Project project;

  @override
  List<Object> get props => [project];
}

final class ProjectStoreError extends ProjectStoreState {
  const ProjectStoreError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
