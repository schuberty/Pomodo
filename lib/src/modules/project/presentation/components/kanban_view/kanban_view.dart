import 'package:flutter/material.dart';

import '../../../../../shared/enums/section_type_enum.dart';
import '../../../../../shared/models/project_model.dart';
import 'kanban_column.dart';

const kKanbanScrollAnimationDuration = Duration(milliseconds: 200);

class KanbanView extends StatefulWidget {
  const KanbanView({super.key, required this.project});

  final Project project;

  @override
  State<KanbanView> createState() => _KanbanViewState();
}

class _KanbanViewState extends State<KanbanView> {
  var currentColumn = 0;
  var isAnimatingToColumn = false;
  final kanbanScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    const middleColumnMargin = 16.0;
    final kanbanColumnWidth = size.width - 48.0;

    return GestureDetector(
      onHorizontalDragUpdate: (details) => onHorizontalDragUpdate(details, kanbanColumnWidth, middleColumnMargin),
      onHorizontalDragEnd: onHorizontalDragEnd,
      behavior: HitTestBehavior.deferToChild,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        controller: kanbanScrollController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            KanbanColumn(
              section: widget.project.sections.firstWhere((element) => element.type == SectionType.todo),
              width: kanbanColumnWidth,
              height: size.height,
            ),
            KanbanColumn(
              section: widget.project.sections.firstWhere((element) => element.type == SectionType.inProgress),
              width: kanbanColumnWidth,
              height: size.height,
              margin: const EdgeInsets.symmetric(horizontal: middleColumnMargin),
            ),
            KanbanColumn(
              section: widget.project.sections.firstWhere((element) => element.type == SectionType.done),
              width: kanbanColumnWidth,
              height: size.height,
            ),
          ],
        ),
      ),
    );
  }

  void onHorizontalDragUpdate(DragUpdateDetails details, double kanbanColumnWidth, double middleColumnMargin) {
    if (isAnimatingToColumn) {
      return;
    }

    var columnToAnimate = currentColumn;

    final isDraggingRight = details.delta.dx < -1;
    final isDraggingLeft = details.delta.dx > 1;

    if (isDraggingRight && currentColumn < 2) {
      columnToAnimate++;
    }

    if (isDraggingLeft && currentColumn > 0) {
      columnToAnimate--;
    }

    if (columnToAnimate == currentColumn) {
      return;
    }

    final offset = (columnToAnimate * (kanbanColumnWidth + (middleColumnMargin / 2)));

    isAnimatingToColumn = true;
    currentColumn = columnToAnimate;

    kanbanScrollController.animateTo(
      offset,
      duration: kKanbanScrollAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  void onHorizontalDragEnd(DragEndDetails _) {
    isAnimatingToColumn = false;
  }

  @override
  void dispose() {
    kanbanScrollController.dispose();

    super.dispose();
  }
}
