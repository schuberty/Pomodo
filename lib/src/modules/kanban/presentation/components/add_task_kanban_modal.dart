import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import '../../../task/data/types.dart';

class AddTaskKanbanModal extends StatefulWidget {
  const AddTaskKanbanModal({super.key});

  @override
  State<AddTaskKanbanModal> createState() => _AddTaskKanbanModalState();
}

class _AddTaskKanbanModalState extends State<AddTaskKanbanModal> {
  final titleFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return KeyboardBottomPadding(
      extraPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(32),
              Text(
                i18n.task.addTaskTitle,
                style: AppFontStyles.headline(),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                child: TextFormField(
                  autofocus: true,
                  focusNode: titleFocusNode,
                  controller: titleTextController,
                  decoration: InputDecoration(
                    hintText: i18n.task.label.taskTitleHint,
                    border: InputBorder.none,
                  ),
                  style: AppFontStyles.title(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => descriptionFocusNode.requestFocus(),
                  validator: (value) => Validator(value).taskTitleValidation(),
                ),
              ),
              TextFormField(
                focusNode: descriptionFocusNode,
                controller: descriptionTextController,
                textInputAction: TextInputAction.send,
                style: AppFontStyles.body(),
                onEditingComplete: () => _onEditingComplete(context),
                decoration: InputDecoration(
                  hintText: i18n.task.label.taskDescriptionHint,
                ),
              ),
              const Gap(16),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _onEditingComplete(context),
                  icon: const AssetWidget(Assets.addIcon),
                ),
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }

  void _onEditingComplete(BuildContext context) {
    final isFormValid = formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    context.pop<NewTaskData>((
      taskContent: titleTextController.text,
      taskDescription: descriptionTextController.text,
    ));
  }
}
