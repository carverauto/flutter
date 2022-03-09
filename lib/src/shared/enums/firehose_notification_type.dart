enum FirehoseNotificationType {
  twitter,
  streams,
  live_on_patrol,
  events,
  other,
}

FirehoseNotificationType getFirehoseNotificationTypeFromString(String type) {
  switch (type.trim()) {
    case "twitter":
      return FirehoseNotificationType.twitter;

    case "streams":
      return FirehoseNotificationType.streams;

    case "Live on Patrol":
      return FirehoseNotificationType.live_on_patrol;

    case "events":
      return FirehoseNotificationType.events;

    default:
      return FirehoseNotificationType.other;
  }
}
