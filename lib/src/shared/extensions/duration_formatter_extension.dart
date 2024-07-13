extension DurationFormatterX on Duration {
  String toFormattedString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    var hoursString = hours > 0 ? '$hours' : '';
    var minutesString = minutes > 0 ? '$minutes' : '';
    var secondsString = seconds > 0 ? '$seconds' : '';

    hoursString = "${hoursString.padLeft(2, '0')}:";

    minutesString = "${minutesString.padLeft(2, '0')}:";

    secondsString = secondsString.padLeft(2, '0');

    return '$hoursString$minutesString$secondsString';
  }
}
