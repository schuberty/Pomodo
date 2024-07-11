import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../shared/models/project_section_model.dart';
import '../../../../../shared/models/task_model.dart';
import '../../../../task/presentation/components/task_card.dart';

class KanbanColumn extends StatelessWidget {
  const KanbanColumn({
    super.key,
    required this.section,
    required this.width,
    required this.height,
    this.margin = EdgeInsets.zero,
  });

  final ProjectSection section;

  final double width;
  final double height;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: section.type.color,
                    borderRadius: const BorderRadius.all(Radius.circular(96)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(section.type.name),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Padding(
                  key: ValueKey(index),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TaskCard(
                    data: Task(
                      id: 'index',
                      content: 'Task $index',
                      order: index,
                      createdAt: DateTime.now(),
                      projectId: '',
                      sectionId: '',
                      description: 'Description',
                      commentCount: index,
                      trackingDuration: const Duration(seconds: 15),
                    ),
                  ),
                );
              },
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final animValue = Curves.easeInOut.transform(animation.value);

                    final scale = lerpDouble(1, 1.02, animValue) ?? 1;
                    final elevation = lerpDouble(0, 8, animValue) ?? 0;

                    return Material(
                      elevation: elevation,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      child: Transform.scale(
                        scale: scale,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text('asd'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: child,
                );
              },
              itemCount: 20,
              onReorder: (oldIndex, newIndex) {},
            ),
          ),
        ],
      ),
    );
  }
}
