import 'package:intl/intl.dart';

import '../../../models/chase/chase.dart';

String dateAdded(Chase chase) {
  if (chase.createdAt == null) {
    return 'NA';
  }

  return chase.live ?? false ? 'LIVE!' : elapsedTimeForDate(chase.createdAt!);
}

String elapsedTimeForDate(DateTime date) {
  late final String dateMsg;

  final DateTime chaseDate = date;
  final DateTime today = DateTime.now().toLocal();
  final Duration diff = chaseDate.difference(today);
  if (diff.inDays.abs() == 0) {
    // Was the chase today?
    if (diff.inHours.abs() == 0) {
      // Chase in last hour?
      if (diff.inMinutes == 0) {
        // In the last minute? show seconds
        dateMsg = '${diff.inSeconds.abs()} seconds ago';
      } else {
        // Otherwise show how many minutes
        dateMsg = '${diff.inMinutes.abs()} minutes ago';
      }
    } else if (diff.inHours.abs() == 1) {
      // One hour ago
      dateMsg = '${diff.inHours.abs()} hr ago';
    } else if (diff.inHours.abs() > 1) {
      // Hours ago
      dateMsg = '${diff.inHours.abs()} hrs ago';
    }
  } else if (today.year != chaseDate.year) {
    dateMsg = DateFormat('MMM d, yyyy').format(chaseDate);
  } else {
    // get in the format of MM - DD
    dateMsg = DateFormat.MMMd().format(chaseDate);
  }

  return dateMsg;
}

String chaseDuration(DateTime? createdAt, DateTime? endedAt) {
  if (createdAt == null || endedAt == null) {
    return '';
  } else {
    final Duration diff = endedAt.difference(createdAt);

    return _chaseDurationDiffString(diff);
    // if (diff.inDays.abs() == 0) {
    //   // Was the chase today?
    //   if (diff.inHours.abs() == 0) {
    //     // Chase in last hour?
    //     if (diff.inMinutes == 0) {
    //       // In the last minute? show seconds
    //       dateMsg = '${diff.inSeconds.abs()} seconds ago';
    //     } else {
    //       // Otherwise show how many minutes
    //       dateMsg = '${diff.inMinutes.abs()} minutes ago';
    //     }
    //   } else if (diff.inHours.abs() == 1) {
    //     // One hour ago
    //     dateMsg = '${diff.inHours.abs()} hr ago';
    //   } else if (diff.inHours.abs() > 1) {
    //     // Hours ago
    //     dateMsg = '${diff.inHours.abs()} hrs ago';
    //   }
    // }

  }
}

String _chaseDurationDiffString(Duration duration) {
  // const Duration duration = Duration(
  //   // days: 2,
  //   hours: 4,
  //   minutes: 64,
  // );
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final String twoDigitDays = twoDigits(duration.inDays);
  final String twoDigitHrs = twoDigits(duration.inHours.remainder(24));
  final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  // final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  final String daysString = twoDigitDays == '00'
      ? ''
      : "$twoDigitDays ${duration.inDays == 1 ? "day" : "days"}";
  final String hrsString = twoDigitHrs == '00'
      ? ''
      : "$twoDigitHrs ${duration.inHours == 1 ? "hr" : "hrs"}";
  final String minutesString = twoDigitMinutes == '00'
      ? ''
      : "$twoDigitMinutes ${duration.inMinutes == 1 ? "minute" : "minutes"}";

  final String durationinString = '$daysString $hrsString $minutesString';

  return durationinString;
}
