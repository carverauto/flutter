import 'package:chaseapp/src/models/chase/chase.dart';

String dateAdded(Chase chase) {
  late final String dateMsg;
  if (chase.createdAt == null) {
    return "NA";
  }
  final chaseDate = DateTime.parse(chase.createdAt!.toIso8601String());
  final today = DateTime.now().toLocal();
  final diff = chaseDate.difference(today);
  if (chase.live ?? false) {
    dateMsg = 'LIVE!';
  } else if (diff.inDays.abs() == 0) {
    // Was the chase today?
    if (diff.inHours.abs() == 0) {
      // Chase in last hour?
      if (diff.inMinutes == 0) {
        // In the last minute? show seconds
        dateMsg = diff.inSeconds.abs().toString() + ' seconds ago';
      } else {
        // Otherwise show how many minutes
        dateMsg = diff.inMinutes.abs().toString() + ' minutes ago';
      }
    } else if (diff.inHours.abs() == 1) {
      // One hour ago
      dateMsg = diff.inHours.abs().toString() + ' hour ago';
    } else if (diff.inHours.abs() > 1) {
      // Hours ago
      dateMsg = diff.inHours.abs().toString() + ' hours ago';
    }
  } else {
    // More than a day ago, just print the date
    dateMsg = chaseDate.toIso8601String().substring(0, 10);
  }

  return dateMsg;
}
