import 'package:chaseapp/src/shared/enums/firehose_notification_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Firehose Notification Type string parser', () {
    test('twitter', () {
      //arrange
      const String firehoseNotificationString = 'twitter';
      //act
      final FirehoseNotificationType? firehoseNotificationInterest =
          getFirehoseNotificationTypeFromString(firehoseNotificationString);

      //expect
      expect(firehoseNotificationInterest, FirehoseNotificationType.twitter);
    });
    test('streams', () {
      //arrange
      const String firehoseNotificationString = 'streams';
      //act
      final FirehoseNotificationType? firehoseNotificationInterest =
          getFirehoseNotificationTypeFromString(firehoseNotificationString);

      //expect
      expect(firehoseNotificationInterest, FirehoseNotificationType.streams);
    });
    test('chase', () {
      //arrange
      const String firehoseNotificationString = 'chase';
      //act
      final FirehoseNotificationType? firehoseNotificationInterest =
          getFirehoseNotificationTypeFromString(firehoseNotificationString);

      //expect
      expect(
        firehoseNotificationInterest,
        FirehoseNotificationType.chase,
      );
    });
    test('events', () {
      //arrange
      const String firehoseNotificationString = 'events';
      //act
      final FirehoseNotificationType? firehoseNotificationInterest =
          getFirehoseNotificationTypeFromString(firehoseNotificationString);

      //expect
      expect(firehoseNotificationInterest, FirehoseNotificationType.events);
    });
    test('Other', () {
      //arrange
      const String firehoseNotificationString = 'Other';
      //act
      final FirehoseNotificationType? firehoseNotificationInterest =
          getFirehoseNotificationTypeFromString(firehoseNotificationString);

      //expect
      expect(firehoseNotificationInterest, isNull);
    });
    test('null', () {
      //arrange
      const String? firehoseNotificationString = null;
      //act
      final FirehoseNotificationType? firehoseNotificationInterest =
          getFirehoseNotificationTypeFromString(firehoseNotificationString);

      //expect
      expect(firehoseNotificationInterest, isNull);
    });
  });
}
