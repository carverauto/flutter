import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/shared/enums/interest_enum.dart';

Interests getInterestEnumFromString(String interest) {
  switch (interest) {
    case "chases-notifications":
      return Interests.chases;
    case "firehose-notifications":
      return Interests.firehose;
    case "AppUpdates":
      return Interests.appUpdates;
    default:
      return Interests.other;
  }
}

extension NotificationInterestEnum on ChaseAppNotification {
  Interests get getInterestEnumFromName =>
      getInterestEnumFromString(this.interest);
}

String getStringFromInterestEnum(Interests interest) {
  switch (interest) {
    case Interests.chases:
      return "chases-notifications";
    case Interests.firehose:
      return "firehose-notifications";
    case Interests.appUpdates:
      return "AppUpdates";
    case Interests.other:
      return "other";
    default:
      return "other";
  }
}
