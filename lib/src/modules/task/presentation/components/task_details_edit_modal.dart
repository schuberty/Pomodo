import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../../shared/models/project_section_model.dart';
import '../../../../shared/models/task_model.dart';
import '../../data/objects/task_timer_state.dart';
import 'task_details_modal.dart';

class TaskDetailsEditModal extends StatefulWidget {
  const TaskDetailsEditModal({
    super.key,
    required this.data,
    required this.taskSection,
    required this.timerStream,
    this.onTapUpdateTask,
  });

  final Task data;
  final ProjectSection taskSection;
  final Stream<TaskTimerState> timerStream;

  final void Function(String newContent, String newDescription)? onTapUpdateTask;

  @override
  State<TaskDetailsEditModal> createState() => _TaskDetailsEditModalState();
}

class _TaskDetailsEditModalState extends State<TaskDetailsEditModal> {
  final titleFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  late final titleTextController = TextEditingController(text: widget.data.content);
  late final descriptionTextController = TextEditingController(text: widget.data.description);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return UnfocusInputField(
      child: KeyboardBottomPadding(
        extraPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  child: TextFormField(
                    autofocus: true,
                    focusNode: titleFocusNode,
                    controller: titleTextController,
                    style: AppFontStyles.title(),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: i18n.task.label.taskTitleHint,
                    ),
                    validator: (value) => Validator(value).taskTitleValidation(),
                  ),
                ),
                TextFormField(
                  maxLines: 4,
                  style: AppFontStyles.body(),
                  focusNode: descriptionFocusNode,
                  controller: descriptionTextController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: i18n.task.label.taskDescriptionHint,
                  ),
                ),
                Gap(size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox.square(
                      dimension: 24,
                      child: IconButton(
                        onPressed: onBackPressed,
                        icon: const AssetWidget(Assets.chevronLeftIcon),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 24,
                      child: IconButton(
                        onPressed: onDonePressed,
                        icon: const AssetWidget(Assets.doneIcon),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onBackPressed() {
    context.pop();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskDetailsModal(
        data: widget.data,
        taskSection: widget.taskSection,
        onTapUpdateTask: widget.onTapUpdateTask,
        timerStream: widget.timerStream,
      ),
    );
  }

  void onDonePressed() {
    final isFormValid = formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final content = titleTextController.text;
    final description = descriptionTextController.text;

    widget.onTapUpdateTask?.call(content, description);

    context.pop();
  }
}
