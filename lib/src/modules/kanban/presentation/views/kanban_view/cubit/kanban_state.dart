part of 'kanban_cubit.dart';

sealed class KanbanState extends Equatable {
  const KanbanState(this.columnsData);

  final List<KanbanColumnViewData> columnsData;

  @override
  List<Object> get props => [columnsData, columnsData.length];
}

final class KanbanInitial extends KanbanState {
  const KanbanInitial(super.columnsData);
}

final class KanbanUpdating extends KanbanState {
  const KanbanUpdating(super.columnsData);
}

final class KanbanUpdateFailed extends KanbanState {
  const KanbanUpdateFailed(super.columnsData, {required this.reason});

  final ClientError reason;
}

final class KanbanUpdated extends KanbanState {
  const KanbanUpdated(super.columnsData);
}
