import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/enums/section_type_enum.dart';
import '../../../../../shared/models/project_model.dart';
import '../../../../project/presentation/cubit/project_store_cubit.dart';
import '../../../domain/objects/kanban_view_data.dart';
import 'cubit/kanban_cubit.dart';
import 'kanban_column_view.dart';

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
      behavior: HitTestBehavior.deferToChild,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onHorizontalDragUpdate: (details) => onHorizontalDragUpdate(details, kanbanColumnWidth, middleColumnMargin),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: kanbanScrollController,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer<KanbanCubit, KanbanState>(
          listener: (context, state) {
            if (state is KanbanUpdateFailed) {
              // TODO: Better error alert
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.reason.message)),
              );
            }
          },
          builder: (_, state) {
            final kanbanRowColumns = buildKanbanRowColumns(
              state.columnsData,
              Size(kanbanColumnWidth, size.height),
              middleColumnMargin,
            );

            return Row(
              children: kanbanRowColumns,
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildKanbanRowColumns(
    List<KanbanColumnViewData> columnsData,
    Size kanbanColumnSize,
    double middleColumnMargin,
  ) {
    final rowsColumn = <Widget>[];

    for (final columnData in columnsData) {
      final sectionMargin = columnData.section.type == SectionType.inProgress
          ? EdgeInsets.symmetric(horizontal: middleColumnMargin)
          : EdgeInsets.zero;

      rowsColumn.add(
        KanbanColumnView(
          margin: sectionMargin,
          tasks: columnData.tasks,
          section: columnData.section,
          width: kanbanColumnSize.width,
          height: kanbanColumnSize.height,
          onPullToRefreshColumn: () => context.read<ProjectStoreCubit>().loadMainProject(),
        ),
      );
    }

    return rowsColumn;
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
      curve: Curves.easeOut,
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
