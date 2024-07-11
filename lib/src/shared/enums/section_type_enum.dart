enum SectionType {
  todo('To Do'),
  inProgress('In Progress'),
  done('Done'),
  invalid('');

  const SectionType(this.name);

  factory SectionType.fromMap(Map<String, dynamic> map) {
    return SectionType.values.firstWhere(
      (element) => element.name == map['name'],
      orElse: () => invalid,
    );
  }

  final String name;
}
