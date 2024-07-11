import 'package:flutter/material.dart';

enum SectionType {
  todo('To Do', color: Colors.blue),
  inProgress('In Progress', color: Colors.orange),
  done('Done', color: Colors.green),
  invalid('', color: Colors.transparent);

  const SectionType(this.name, {required this.color});

  factory SectionType.fromMap(Map<String, dynamic> map) {
    return SectionType.values.firstWhere(
      (element) => element.name == map['name'],
      orElse: () => invalid,
    );
  }

  final String name;
  final Color color;
}
