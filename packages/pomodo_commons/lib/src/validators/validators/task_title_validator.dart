import '../input_validators.dart';

class TaskTitleValidator extends InputValidation {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Task title cannot be empty';
    }

    return null;
  }
}
