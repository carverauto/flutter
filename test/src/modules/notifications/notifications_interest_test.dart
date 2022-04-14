import 'package:chaseapp/src/shared/enums/interest_enum.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Notification Interests Type Getters from String', () {
    test('chases-notifications', () {
      final Interests? interest =
          getInterestEnumFromString('chases-notifications');

      expect(interest, Interests.chases);
    });
    test('firehose-notifications', () {
      final Interests? interest =
          getInterestEnumFromString('firehose-notifications');

      expect(interest, Interests.firehose);
    });
    test('AppUpdates', () {
      final Interests? interest = getInterestEnumFromString('AppUpdates');

      expect(interest, Interests.appUpdates);
    });
    test('Unknown', () {
      final Interests? interest = getInterestEnumFromString('Unknown');

      expect(interest, isNull);
    });
  });
  group('Notification Interests String Getters from Enum', () {
    test('chases-notifications', () {
      final String? chaseInterest = getStringFromInterestEnum(Interests.chases);

      expect(chaseInterest, 'chases-notifications');
    });
    test('firehose-notifications', () {
      final String? firehoseInterest =
          getStringFromInterestEnum(Interests.firehose);

      expect(firehoseInterest, 'firehose-notifications');
    });
    test('AppUpdates', () {
      final String? appUpdatesInterest =
          getStringFromInterestEnum(Interests.appUpdates);

      expect(appUpdatesInterest, 'AppUpdates');
    });
  });
}
