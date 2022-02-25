import 'package:chaseapp/src/core/notifiers/post_login_state_notifier.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';

Interests getInterestEnumFromString(String interest) {
  switch (interest) {
    case "chases-notifications":
      return Interests.chasesnotifications;
    case "appUpdates":
      return Interests.appUpdates;
    default:
      return Interests.other;
  }
}

enum Interests {
  chasesnotifications,
  appUpdates,
  other,
}

extension InterestEnum on Interest {
  Interests get getInterestEnum {
    switch (this.name) {
      case "chases-notifications":
        return Interests.chasesnotifications;
      case "appUpdates":
        return Interests.appUpdates;
      default:
        return Interests.other;
    }
  }
}

extension NotificationInterestEnum on NotificationData {
  Interests get getInterestEnumFromName {
    switch (this.interest) {
      case "chases-notifications":
        return Interests.chasesnotifications;
      case "appUpdates":
        return Interests.appUpdates;
      default:
        return Interests.other;
    }
  }
}
