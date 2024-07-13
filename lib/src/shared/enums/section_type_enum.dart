import 'package:flutter/material.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

enum SectionType {
  todo('To-Do', color: AppColors.blue),
  inProgress('In Progress', color: AppColors.orange),
  done('Done', color: AppColors.green),
  invalid('', color: AppColors.transparent);

  const SectionType(this.name, {required this.color});

  factory SectionType.fromMap(Map<String, dynamic> map) {
    return SectionType.values.firstWhere(
      (element) => element.name == map['name'],
      orElse: () => invalid,
    );
  }

  final String name;
  final Color color;

  String get nameLocalized {
    return switch (this) {
      SectionType.todo => i18n.kanban.column.todo,
      SectionType.inProgress => i18n.kanban.column.inProgress,
      SectionType.done => i18n.kanban.column.done,
      _ => '',
    };
  }
}
