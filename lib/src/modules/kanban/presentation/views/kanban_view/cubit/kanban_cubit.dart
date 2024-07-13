import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pomodo_commons/pomodo_commons.dart';
import 'package:uuid/v4.dart';

import '../../../../../../shared/enums/section_type_enum.dart';
import '../../../../../../shared/models/project_section_model.dart';
import '../../../../../../shared/models/task_model.dart';
import '../../../../../task/data/objects/task_move_section_command.dart';
import '../../../../../task/data/objects/task_reorder_command.dart';
import '../../../../../task/data/objects/task_timer_state.dart';
import '../../../../../task/data/objects/task_update_command.dart';
import '../../../../../task/data/repositories/task_repository.dart';
import '../../../../domain/objects/kanban_view_data.dart';

part 'kanban_state.dart';

typedef Id = String;

abstract class KanbanCubit extends Cubit<KanbanState> {
  KanbanCubit(super.initialState);

  void addTask({required ProjectSection section, required String content, required String description});

  void deleteTask({required ProjectSection section, required Task task});

  void moveTask({required ProjectSection fromSection, required Task task, required SectionType toSectionType});

  void reorderTask({required ProjectSection section, required int oldIndex, required int newIndex});

  void updateTask({
    required ProjectSection section,
    required Task task,
    required String content,
    required String description,
  });

  Stream<TaskTimerState> getTaskTimerStream(Task task);

  void resumeTaskTimer(Task task);

  void pauseTaskTimer(Task task);
}

class AppKanbanCubit extends KanbanCubit {
  AppKanbanCubit({
    required List<KanbanColumnViewData> columnsData,
    required this.taskRepository,
  }) : super(KanbanInitial(columnsData)) {
    tasksTimer = Timer.periodic(const Duration(seconds: 1), onTaskTimerUpdate);
  }

  final TaskRepository taskRepository;

  // TODO: Implement a timed queue so that updates are sended in batches
  // final Set<TaskCommand> taksCommandQueue = {};

  final timerStreamControllers = <Id, StreamController<TaskTimerState>>{};
  final Set<Id> pausedTasks = {};
  late final Timer tasksTimer;

  @override
  Future<void> addTask({
    required ProjectSection section,
    required String content,
    required String description,
  }) async {
    final tempId = const UuidV4().generate();

    final sectionData = sectionDataFromSectionId(section.id);

    final unsyncedTask = Task.unsynced(
      id: tempId,
      content: content,
      description: description,
      sectionId: section.id,
      order: sectionData.tasks.length,
    );

    sectionData.tasks.add(unsyncedTask);

    emit(KanbanUpdating(state.columnsData));

    final taskCreateResult = await taskRepository.createTask(
      section: sectionData.section,
      data: (taskContent: content, taskDescription: description),
    );

    if (taskCreateResult.isFailure) {
      emit(KanbanUpdateFailed(state.columnsData, reason: taskCreateResult.failure));

      return;
    }

    final task = taskCreateResult.success;

    for (var column in state.columnsData) {
      if (column.section.id != section.id) {
        continue;
      }

      final index = column.tasks.indexOf(unsyncedTask);
      column.tasks.remove(unsyncedTask);
      column.tasks.insert(index, task);

      break;
    }

    emit(KanbanUpdated(state.columnsData));
  }

  @override
  Future<void> deleteTask({required ProjectSection section, required Task task}) async {
    final sectionData = sectionDataFromSectionId(section.id);

    final taskIndex = sectionData.tasks.indexOf(task);
    final removedTask = sectionData.tasks.removeAt(taskIndex);

    emit(KanbanUpdating(state.columnsData));

    final taskDeleteResult = await taskRepository.deleteTask(task: task);

    if (taskDeleteResult.isFailure) {
      sectionData.tasks.insert(taskIndex, removedTask);

      emit(KanbanUpdateFailed(state.columnsData, reason: taskDeleteResult.failure));

      return;
    }

    emit(KanbanUpdated(state.columnsData));
  }

  @override
  Future<void> moveTask({
    required ProjectSection fromSection,
    required Task task,
    required SectionType toSectionType,
  }) async {
    final fromSectionData = sectionDataFromSectionId(fromSection.id);
    final toSectionData = state.columnsData.firstWhere((element) => element.section.type == toSectionType);

    final taskIndex = fromSectionData.tasks.indexOf(task);
    final movedTask = fromSectionData.tasks.removeAt(taskIndex).copyWith(
          sectionId: toSectionData.section.id,
          order: toSectionData.tasks.length,
        );

    toSectionData.tasks.add(movedTask);

    emit(KanbanUpdating(state.columnsData));

    final taskMoveResult = await taskRepository.sendSyncCommands(
      commands: [TaskMoveSectionCommand(task: movedTask, toSection: toSectionData.section)],
    );

    if (taskMoveResult.isFailure) {
      toSectionData.tasks.remove(movedTask);

      final reMovedTask = movedTask.copyWith(sectionId: fromSection.id, order: taskIndex);

      fromSectionData.tasks.insert(taskIndex, reMovedTask);

      emit(KanbanUpdateFailed(state.columnsData, reason: taskMoveResult.failure));

      return;
    }

    emit(KanbanUpdated(state.columnsData));
  }

  @override
  Future<void> reorderTask({
    required ProjectSection section,
    required int oldIndex,
    required int newIndex,
  }) async {
    final sectionData = sectionDataFromSectionId(section.id);

    if (oldIndex < newIndex) {
      newIndex--;
    }

    final task = sectionData.tasks.removeAt(oldIndex).copyWith(order: newIndex);

    sectionData.tasks.insert(newIndex, task);

    emit(KanbanUpdating(state.columnsData));

    final updatedSectionTasksListOrder = {
      for (var index = 0; index < sectionData.tasks.length; index++) sectionData.tasks[index]: index
    };

    final taskUpdateResult = await taskRepository.sendSyncCommands(
      commands: [TaskReorderCommand(args: updatedSectionTasksListOrder)],
    );

    if (taskUpdateResult.isFailure) {
      emit(KanbanUpdateFailed(state.columnsData, reason: taskUpdateResult.failure));

      return;
    }

    emit(KanbanUpdated(state.columnsData));
  }

  @override
  Future<void> updateTask({
    required ProjectSection section,
    required Task task,
    required String content,
    required String description,
  }) async {
    if (task.content == content && task.description == description) {
      return;
    }

    final sectionData = sectionDataFromSectionId(section.id);

    final taskIndex = sectionData.tasks.indexOf(task);
    final updatedTask = task.copyWith(content: content, description: description);

    sectionData.tasks[taskIndex] = updatedTask;

    emit(KanbanUpdating(state.columnsData));

    final taskUpdateResult = await taskRepository.sendSyncCommands(commands: [
      TaskUpdateCommand(
        taskToUpdate: task,
        content: content,
        description: description,
      ),
    ]);

    if (taskUpdateResult.isFailure) {
      sectionData.tasks[taskIndex] = task;

      emit(KanbanUpdateFailed(state.columnsData, reason: taskUpdateResult.failure));

      return;
    }

    emit(KanbanUpdated(state.columnsData));
  }

  @override
  Stream<TaskTimerState> getTaskTimerStream(Task task) {
    final streamController = timerStreamControllers[task.id];

    if (streamController != null) {
      return streamController.stream;
    }

    pausedTasks.add(task.id);

    final newStreamController = StreamController<TaskTimerState>.broadcast();

    timerStreamControllers[task.id] = newStreamController;

    return newStreamController.stream;
  }

  @override
  void resumeTaskTimer(Task task) {
    pausedTasks.remove(task.id);

    if (timerStreamControllers.containsKey(task.id)) {
      final updatedTask = taskFromId(task.id);

      timerStreamControllers[task.id]?.add(
        TaskTimerState(
          isRunning: true,
          duration: updatedTask.trackingDuration,
        ),
      );

      return;
    }

    timerStreamControllers[task.id] = StreamController<TaskTimerState>.broadcast();
  }

  @override
  void pauseTaskTimer(Task task) {
    pausedTasks.add(task.id);

    final streamController = timerStreamControllers[task.id];

    if (streamController != null) {
      final updatedTask = taskFromId(task.id);

      streamController.add(
        TaskTimerState(duration: updatedTask.trackingDuration),
      );
    }
  }

  void onTaskTimerUpdate(Timer _) {
    for (var streamEntry in timerStreamControllers.entries) {
      final task = taskFromId(streamEntry.key);

      if (pausedTasks.contains(task.id)) {
        continue;
      }

      final streamController = streamEntry.value;

      final newDuration = task.trackingDuration + const Duration(seconds: 1);

      final sectionData = sectionDataFromSectionId(task.sectionId);

      final taskIndex = sectionData.tasks.indexOf(task);
      final updatedTask = task.copyWith(trackingDuration: newDuration);

      sectionData.tasks[taskIndex] = updatedTask;

      final taskTimerState = TaskTimerState(duration: newDuration, isRunning: true);

      streamController.add(taskTimerState);
    }
  }

  Task taskFromId(Id id) {
    return state.columnsData.expand((element) => element.tasks).firstWhere((element) => element.id == id);
  }

  KanbanColumnViewData sectionDataFromSectionId(String sectionId) {
    return state.columnsData.firstWhere((element) => element.section.id == sectionId);
  }

  @override
  Future<void> close() {
    tasksTimer.cancel();

    for (var controller in timerStreamControllers.values) {
      controller.close();
    }

    return super.close();
  }
}
