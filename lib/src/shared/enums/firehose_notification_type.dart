enum FirehoseNotificationType {
  twitter,
  streams,
  chase,
  live_on_patrol,
  events,
}

FirehoseNotificationType? getFirehoseNotificationTypeFromString(String type) {
  switch (type.trim()) {
    case 'twitter':
      return FirehoseNotificationType.twitter;

    case 'streams':
      return FirehoseNotificationType.streams;
    // case "chase":
    //   return FirehoseNotificationType.chase;
    case 'Live on Patrol':
      return FirehoseNotificationType.live_on_patrol;

    case 'events':
      return FirehoseNotificationType.events;

    default:
      return null;
  }
}
