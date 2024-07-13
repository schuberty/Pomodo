import 'package:uuid/v4.dart';

// While not the best aproach, I only saw that certain updates can only be done via the Sync API at the last moment.
abstract class TaskCommand {
  const TaskCommand();

  String get type;

  Map<String, dynamic> toMap() {
    final uuid = const UuidV4().generate();

    return <String, dynamic>{
      'type': type,
      'uuid': uuid,
    };
  }
}
