import 'package:intl/intl.dart';

extension DatetimeFormatterExtension on DateTime {
  String toFormattedDateString() {
    return DateFormat('dd MMM yyyy').format(toLocal());
  }
}
