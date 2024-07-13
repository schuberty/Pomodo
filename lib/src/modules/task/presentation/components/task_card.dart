import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../shared/enums/section_type_enum.dart';
import '../../../../shared/extensions/datetime_formatter_extension.dart';
import '../../../../shared/extensions/duration_formatter_extension.dart';
import '../../../../shared/models/task_model.dart';
import '../../data/objects/task_timer_state.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.data,
    required this.sectionType,
    this.onTapCard,
    this.onTapMoveToTodo,
    this.onTapMoveToInProgress,
    this.onTapMoveToDone,
    this.onTapDelete,
    this.timerStream,
  });

  final Task data;
  final SectionType sectionType;

  final VoidCallback? onTapCard;
  final VoidCallback? onTapMoveToTodo;
  final VoidCallback? onTapMoveToInProgress;
  final VoidCallback? onTapMoveToDone;
  final VoidCallback? onTapDelete;

  final Stream<TaskTimerState>? timerStream;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTapCard,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        data.content,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyles.title(),
                      ),
                    ),
                    _TaskPopUpMenuOptions(
                      sectionType: sectionType,
                      onTapMoveToTodo: onTapMoveToTodo,
                      onTapMoveToInProgress: onTapMoveToInProgress,
                      onTapMoveToDone: onTapMoveToDone,
                      onTapDelete: onTapDelete,
                    ),
                  ],
                ),
                if (data.description.isNotEmpty)
                  Text(
                    data.description,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyles.caption(),
                  ),
                _TaskCardBottom(
                  commentCount: data.commentCount,
                  trackingDuration: data.trackingDuration,
                  createdAt: data.createdAt,
                  timerStream: timerStream,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskPopUpMenuOptions extends StatelessWidget {
  const _TaskPopUpMenuOptions({
    required this.sectionType,
    this.onTapMoveToTodo,
    this.onTapMoveToInProgress,
    this.onTapMoveToDone,
    this.onTapDelete,
  });

  final SectionType sectionType;

  final VoidCallback? onTapMoveToTodo;
  final VoidCallback? onTapMoveToInProgress;
  final VoidCallback? onTapMoveToDone;
  final VoidCallback? onTapDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 24,
      child: PopupMenuButton(
        icon: const AssetWidget(Assets.dotsVerticalIcon),
        padding: EdgeInsets.zero,
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            if (sectionType != SectionType.todo)
              PopupMenuItem(
                child: ListTile(
                  title: Text(i18n.task.actionLabel.targetMoveTodo),
                  textColor: SectionType.todo.color,
                  onTap: () {
                    onTapMoveToTodo?.call();
                    context.pop();
                  },
                ),
              ),
            if (sectionType != SectionType.inProgress)
              PopupMenuItem(
                child: ListTile(
                  title: Text(i18n.task.actionLabel.targetMoveInProgress),
                  textColor: SectionType.inProgress.color,
                  onTap: () {
                    onTapMoveToInProgress?.call();
                    context.pop();
                  },
                ),
              ),
            if (sectionType != SectionType.done)
              PopupMenuItem(
                child: ListTile(
                  title: Text(i18n.task.actionLabel.targetMoveDone),
                  textColor: SectionType.done.color,
                  onTap: () {
                    onTapMoveToDone?.call();
                    context.pop();
                  },
                ),
              ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: ListTile(
                title: Text(i18n.task.actionLabel.delete),
                trailing: const AssetWidget(
                  Assets.trashIcon,
                  size: Size.square(20),
                  color: AppColors.red,
                ),
                onTap: () {
                  onTapDelete?.call();
                  context.pop();
                },
              ),
            ),
          ];
        },
      ),
    );
  }
}

class _TaskCardBottom extends StatelessWidget {
  const _TaskCardBottom({
    required this.createdAt,
    required this.commentCount,
    required this.trackingDuration,
    this.timerStream,
  });

  final int commentCount;
  final DateTime createdAt;
  final Duration trackingDuration;

  final Stream<TaskTimerState>? timerStream;

  @override
  Widget build(BuildContext context) {
    final hasComments = commentCount > 0;

    return StreamBuilder<TaskTimerState>(
        stream: timerStream,
        initialData: TaskTimerState(duration: trackingDuration),
        builder: (context, snapshot) {
          final trackingState = snapshot.data ?? TaskTimerState(duration: trackingDuration);

          final hasTrackingDuration = trackingState.duration.inSeconds > 0;

          return Column(
            children: [
              if (hasTrackingDuration)
                const AnimatedScale(
                  scale: 1.0,
                  duration: Duration(seconds: 4),
                  child: Divider(
                    thickness: 0.5,
                    color: AppColors.grey,
                  ),
                ),
              Row(
                children: [
                  if (hasComments) ...[
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: AssetWidget(
                        Assets.commentIcon,
                        size: Size.square(18),
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const Gap(2),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        commentCount.toString(),
                        style: AppFontStyles.caption(color: AppColors.black),
                      ),
                    ),
                    const Gap(16),
                  ],
                  if (hasTrackingDuration) ...[
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: AssetWidget(
                        Assets.clockIcon,
                        size: Size.square(18),
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      trackingState.duration.toFormattedString(),
                      style: AppFontStyles.caption(color: AppColors.black),
                    ),
                  ],
                  const Spacer(),
                  if (hasComments || hasTrackingDuration)
                    Text(
                      createdAt.toFormattedDateString(),
                      style: AppFontStyles.caption(),
                    ),
                ],
              ),
            ],
          );
        });
  }
}
