import 'validators/task_title_validator.dart';

abstract class InputValidation {
  String? validate(String? value);
}

class Validator {
  Validator(this.value);

  final String? value;

  String? taskTitleValidation() {
    return TaskTitleValidator().validate(value);
  }
}
