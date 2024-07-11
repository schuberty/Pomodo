part of 'utils.dart';

String parseTrackingMetadataTag(int trackingTimeSeconds) {
  return '<${Constants.taskTrackingMetadataTag}:$trackingTimeSeconds>';
}

String parseTaskDescriptionWithTrackingMetadata(String description, int trackingTimeSeconds) {
  final tag = parseTrackingMetadataTag(trackingTimeSeconds);

  return '$description$tag';
}

({Duration trackingDuration, String parsedDescription}) parseTaskMetadataFromTaskDescription(String rawDescription) {
  final trackingTimeRegex = RegExp(Constants.taskTrackingMetadataRegexp);

  final trackingTimeMetadataMatch = trackingTimeRegex.firstMatch(rawDescription);
  final trackingTimeMetadata = trackingTimeMetadataMatch?.group(1);

  late final String parsedDescription;
  late final int parsedTrackingTimeSeconds;

  if (trackingTimeMetadata != null) {
    parsedTrackingTimeSeconds = int.parse(trackingTimeMetadata);

    parsedDescription = rawDescription.replaceAll(trackingTimeRegex, '');
  } else {
    parsedTrackingTimeSeconds = 0;

    parsedDescription = rawDescription;
  }

  return (
    parsedDescription: parsedDescription,
    trackingDuration: Duration(seconds: parsedTrackingTimeSeconds),
  );
}
