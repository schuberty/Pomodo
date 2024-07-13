import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../../shared/enums/section_type_enum.dart';
import '../../../../../shared/models/project_section_model.dart';
import '../../../../../shared/models/task_model.dart';
import '../../../../task/data/types.dart';
import '../../../../task/presentation/components/task_card.dart';
import '../../../../task/presentation/components/task_details_modal.dart';
import '../../components/add_task_kanban_modal.dart';
import 'cubit/kanban_cubit.dart';

class KanbanColumnView extends StatelessWidget {
  KanbanColumnView({
    super.key,
    required this.tasks,
    required this.section,
    required this.width,
    required this.height,
    this.margin = EdgeInsets.zero,
    this.onPullToRefreshColumn,
  });

  final kanbanScrollController = ScrollController();

  final List<Task> tasks;
  final ProjectSection section;

  final double width;
  final double height;
  final EdgeInsets margin;

  final VoidCallback? onPullToRefreshColumn;

  @override
  Widget build(BuildContext context) {
    final kanbanColumnDecoration = BoxDecoration(
      color: AppColors.lightGrey,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      border: Border.all(width: 4, color: AppColors.outlineGrey),
    );

    final kanbanHeaderWidget = Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _KanbanHeader(
        header: section.type.nameLocalized,
        taskCount: tasks.length,
        color: section.type.color,
        onTapAddTask: () => _onTapToAddTask(context),
      ),
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: kanbanColumnDecoration,
      child: RefreshIndicator(
        onRefresh: () async => onPullToRefreshColumn?.call(),
        child: ReorderableListView.builder(
          scrollController: kanbanScrollController,
          header: kanbanHeaderWidget,
          footer: const Gap(32),
          itemCount: tasks.length,
          proxyDecorator: _customProxyDecorator,
          itemBuilder: _kanbanReorderableItemBuilder,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onReorder: (oldIndex, newIndex) => _onKanbanItemReorder(context, oldIndex, newIndex),
        ),
      ),
    );
  }

  Widget _kanbanReorderableItemBuilder(BuildContext context, int index) {
    final task = tasks[index];

    final kanbanCubit = context.read<KanbanCubit>();

    return TaskCard(
      key: ValueKey(task.id),
      onTapCard: () => _onTapCardItem(context, section, task),
      data: tasks[index],
      sectionType: section.type,
      timerStream: kanbanCubit.getTaskTimerStream(task),
      onTapDelete: () {
        kanbanCubit.deleteTask(section: section, task: tasks[index]);
      },
      onTapMoveToTodo: () {
        kanbanCubit.moveTask(
          fromSection: section,
          task: tasks[index],
          toSectionType: SectionType.todo,
        );
      },
      onTapMoveToInProgress: () {
        kanbanCubit.moveTask(
          fromSection: section,
          task: tasks[index],
          toSectionType: SectionType.inProgress,
        );
      },
      onTapMoveToDone: () {
        kanbanCubit.moveTask(
          fromSection: section,
          task: tasks[index],
          toSectionType: SectionType.done,
        );
      },
    );
  }

  void _onTapCardItem(BuildContext context, section, Task task) {
    final kanbanCubit = context.read<KanbanCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskDetailsModal(
        data: task,
        taskSection: section,
        onTapUpdateTask: (newContent, newDescription) {
          kanbanCubit.updateTask(
            section: section,
            task: task,
            content: newContent,
            description: newDescription,
          );
        },
        onResumeTimer: () => kanbanCubit.resumeTaskTimer(task),
        onPauseTimer: () => kanbanCubit.pauseTaskTimer(task),
        timerStream: kanbanCubit.getTaskTimerStream(task),
      ),
    );
  }

  void _onTapToAddTask(BuildContext context) {
    showModalBottomSheet<NewTaskData?>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddTaskKanbanModal(),
    ).then(
      (newTaskData) {
        if (newTaskData != null) {
          context.read<KanbanCubit>().addTask(
                section: section,
                content: newTaskData.taskContent,
                description: newTaskData.taskDescription,
              );

          kanbanScrollController.animateTo(
            kanbanScrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
    );
  }

  void _onKanbanItemReorder(BuildContext context, int oldIndex, int newIndex) {
    context.read<KanbanCubit>().reorderTask(
          section: section,
          oldIndex: oldIndex,
          newIndex: newIndex,
        );
  }

  Widget _customProxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final animationDelta = Curves.easeIn.transform(animation.value);

        final angle = lerpDouble(0.0, -pi / 48, animationDelta) ?? 0.0;
        final elevation = lerpDouble(5.0, 8.0, animationDelta) ?? 5.0;
        final scale = lerpDouble(1.0, 1.02, animationDelta) ?? 1.0;

        return Transform.rotate(
          angle: angle,
          child: Material(
            elevation: elevation,
            clipBehavior: Clip.antiAlias,
            shadowColor: AppColors.black.withOpacity(0.6),
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: Transform.scale(
              scale: scale,
              child: TaskCard(
                data: tasks[index],
                sectionType: section.type,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _KanbanHeader extends StatelessWidget {
  const _KanbanHeader({
    required this.color,
    required this.header,
    required this.taskCount,
    this.onTapAddTask,
  });

  final Color color;
  final String header;
  final int taskCount;

  final VoidCallback? onTapAddTask;

  @override
  Widget build(BuildContext context) {
    final hasTasks = taskCount != 0;

    Widget result = Row(
      children: [
        SizedBox(
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(96)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: FittedBox(
                  child: Text(
                    header,
                    style: AppFontStyles.button(),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasTasks) ...[
          const Gap(8),
          DecoratedBox(
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(color: color),
              ),
            ),
            child: SizedBox.square(
              dimension: 40,
              child: Center(
                child: FittedBox(
                  child: Text(
                    taskCount.toString(),
                    style: AppFontStyles.button(color: color),
                  ),
                ),
              ),
            ),
          ),
        ],
        const Spacer(),
        IconButton(
          onPressed: onTapAddTask,
          icon: AssetWidget(
            Assets.addIcon,
            color: color.withOpacity(0.6),
          ),
        )
      ],
    );

    if (!hasTasks) {
      final size = MediaQuery.sizeOf(context);

      result = Column(
        children: [
          result,
          Gap(size.height * 0.12),
          const AssetWidget(Assets.checklistEmptyImage),
          Text(
            i18n.kanban.emptyColumnBody,
            style: AppFontStyles.body(color: AppColors.grey),
          ),
          const Gap(8),
          Text(
            i18n.kanban.emptyColumnCaption,
            style: AppFontStyles.caption(color: AppColors.grey.withOpacity(0.3)),
          ),
        ],
      );
    }

    return result;
  }
}
