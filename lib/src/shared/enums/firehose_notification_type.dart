enum FirehoseNotificationType {
  twitter,
  streams,
  chase,
  events,
}

FirehoseNotificationType? getFirehoseNotificationTypeFromString(String? type) {
  switch (type?.trim()) {
    case 'twitter':
      return FirehoseNotificationType.twitter;

    case 'streams':
      return FirehoseNotificationType.streams;

    case 'chase':
      return FirehoseNotificationType.chase;

    case 'events':
      return FirehoseNotificationType.events;

    default:
      return null;
  }
}
