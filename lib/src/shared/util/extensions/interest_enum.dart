import 'package:chaseapp/src/core/notifiers/post_login_state_notifier.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';

Interests getInterestEnumFromString(String interest) {
  switch (interest) {
    case "chases-notifications":
      return Interests.chasesnotifications;
    default:
      return Interests.OTHER;
  }
}

enum Interests {
  chasesnotifications,
  OTHER,
}

extension InterestEnum on Interest {
  Interests get getInterestEnum {
    switch (this.name) {
      case "chases-notifications":
        return Interests.chasesnotifications;
      default:
        return Interests.OTHER;
    }
  }
}

extension NotificationInterestEnum on NotificationData {
  Interests get getInterestEnumFromName {
    switch (this.interest) {
      case "chases-notifications":
        return Interests.chasesnotifications;
      default:
        return Interests.OTHER;
    }
  }
}
