import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../shared/extensions/datetime_formatter_extension.dart';
import '../../../../shared/extensions/duration_formatter_extension.dart';
import '../../../../shared/models/project_section_model.dart';
import '../../../../shared/models/task_model.dart';
import '../../data/objects/task_timer_state.dart';
import 'task_details_edit_modal.dart';

class TaskDetailsModal extends StatelessWidget {
  const TaskDetailsModal({
    super.key,
    required this.data,
    required this.taskSection,
    required this.timerStream,
    this.onTapUpdateTask,
    this.onResumeTimer,
    this.onPauseTimer,
  });

  final Task data;
  final ProjectSection taskSection;
  final Stream<TaskTimerState> timerStream;

  final VoidCallback? onResumeTimer;
  final VoidCallback? onPauseTimer;

  final void Function(String newContent, String newDescription)? onTapUpdateTask;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return KeyboardBottomPadding(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _TaskDetailsModalBackgroundExtent(sectionColor: taskSection.type.color),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 48,
                      child: Text(
                        data.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyles.headline(),
                      ),
                    ),
                    Text(
                      data.description.isEmpty ? i18n.task.label.noDescriptionLabel : data.description,
                      style: AppFontStyles.body(),
                    ),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            data.commentCount.toString(),
                            style: AppFontStyles.caption(color: AppColors.black),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          data.createdAt.toFormattedDateString(),
                          style: AppFontStyles.caption(),
                        ),
                      ],
                    ),
                    const Divider(
                      indent: 32,
                      endIndent: 32,
                      thickness: 0.5,
                      height: 32,
                    ),
                    StreamBuilder<TaskTimerState>(
                      stream: timerStream,
                      initialData: TaskTimerState(duration: data.trackingDuration),
                      builder: (context, snapshot) {
                        final trackingState = snapshot.data ?? TaskTimerState(duration: data.trackingDuration);

                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedDefaultTextStyle(
                                  style: trackingState.isRunning ? AppFontStyles.title() : AppFontStyles.caption(),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.fastOutSlowIn,
                                  child: Text(
                                    trackingState.duration.toFormattedString(),
                                  ),
                                ),
                                Text(
                                  i18n.task.label.taskDurationLabel,
                                  style: AppFontStyles.body(),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: trackingState.isRunning ? onPauseTimer : onResumeTimer,
                              icon: AssetWidget(
                                trackingState.isRunning ? Assets.pauseIcon : Assets.playIcon,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Gap(size.height * 0.1),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox.square(
                        dimension: 24,
                        child: IconButton(
                          onPressed: () {
                            context.pop();

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => TaskDetailsEditModal(
                                data: data,
                                taskSection: taskSection,
                                onTapUpdateTask: onTapUpdateTask,
                                timerStream: timerStream,
                              ),
                            );
                          },
                          icon: const AssetWidget(Assets.editIcon),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskDetailsModalBackgroundExtent extends StatelessWidget {
  const _TaskDetailsModalBackgroundExtent({required this.sectionColor});

  final Color sectionColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Positioned(
      top: -8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: sectionColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SizedBox(
          height: size.height,
          width: size.width,
        ),
      ),
    );
  }
}
